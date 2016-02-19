//
//  ViewController.m
//  homework1
//
//  Created by 余玺 on 15/6/14.
//  Copyright (c) 2015年 yx. All rights reserved.
//

#import "ViewController.h"
#import "change.h"
#define MAXBIT      100
#define MAXVALUE  10000
#define MAXLEAF     100
#define MAXNODE    MAXLEAF*2 -1

typedef struct
{
    int bit[MAXBIT];
    int start;
} HCodeType;
typedef struct
{
    int weight;
    int parent;
    int lchild;
    int rchild;
} HNodeType;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *gc;
@property (weak, nonatomic) IBOutlet UIScrollView *liulan;
@end
@implementation ViewController
- (IBAction)takepicture:(UIButton *)sender {
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择文件来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"照相机",@"本地相簿",nil];
    [actionSheet showInView:self.view];

}
#pragma mark -
#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex = [%d]",buttonIndex);
    switch (buttonIndex) {
        case 0://照相机
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //            [self presentModalViewController:imagePicker animated:YES];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;

        case 1://本地相簿
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //            [self presentModalViewController:imagePicker animated:YES];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{   UIImage *img = (UIImage*)[info objectForKey:UIImagePickerControllerEditedImage];
    img = [change imageCompressForWidth:img targetWidth:15];//进行图片的压缩
    img = [change grayscaleImage:img];//将图片灰度化
    self.gc.image = img;//用选择的图片替换现有的图片
    CGFloat width;
    CGFloat height;
    UIImage *heightmap = img;
    CGImageRef imageRef = [heightmap CGImage];
    width = CGImageGetWidth(imageRef);
    height = CGImageGetHeight(imageRef);
    CGDataProviderRef provider = CGImageGetDataProvider(imageRef);
    NSData* data = (id)CFBridgingRelease(CGDataProviderCopyData(provider));//获取图片每个像素的灰度值
    
    int flag = 1;
    const uint8_t *heightData = [data bytes];
    int ii = 0;
    int jj = 0;
    int z = 0;
    int a[300];
    for (ii = 0; ii < width * height; ii++)
    {
        flag = 1;
        for (jj = 0; jj < ii; jj++)
        {
            
            if(heightData[jj] == heightData[ii]){
                flag = 0;
                break;
    
            }
            
        }
        
        if(flag == 0){
            continue;
        }
        a[z] = heightData[ii];
        z = z+1;
    }
    
       int m = 0;
    int l = 0;
    int b[300];
    for(int k=0;k<z;k++){
        m = 0;
        for(int u = 0;u<width*height;u++){
            if(a[k]==heightData[u]){
                m=m+1;
            }
                
        }
        b[l] = m;
        l = l+1;
    }
    //整理出像素的种类以及每种像素有多少个
    
    HNodeType HuffNode[MAXNODE];
    HCodeType HuffCode[MAXLEAF],  cd;
   
    int i, j, m1, m2, x1, x2;
   
    for (i=0; i<2*l-1; i++)
    {
        HuffNode[i].weight = 0;
        HuffNode[i].parent =-1;
        HuffNode[i].lchild =-1;
        HuffNode[i].lchild =-1;
    }
    

    for (i=0; i<l; i++)
    {
      HuffNode[i].weight = b[i];
    }
    
    
    for (i=0; i<l-1; i++)
    {
        m1=m2=MAXVALUE;
        x1=x2=0;
        
        for (j=0; j<l+i; j++)
        {
            if (HuffNode[j].weight < m1 && HuffNode[j].parent==-1)
            {
                m2=m1;
                x2=x1;
                m1=HuffNode[j].weight;
                x1=j;
            }
            else if (HuffNode[j].weight < m2 && HuffNode[j].parent==-1)
            {
                m2=HuffNode[j].weight;
                x2=j;
            }
        }
        HuffNode[x1].parent  = l+i;
        HuffNode[x2].parent  = l+i;
        HuffNode[l+i].weight = HuffNode[x1].weight + HuffNode[x2].weight;
        HuffNode[l+i].lchild = x1;
        HuffNode[l+i].rchild = x2;
    }
        int c,p;
        for (int i=0; i < l; i++)
        {
            cd.start = l-1;
            c = i;
            p = HuffNode[c].parent;
            while (p != -1)
            {
                if (HuffNode[p].lchild == c)
                    cd.bit[cd.start] = 0;
                else
                    cd.bit[cd.start] = 1;
                cd.start--;
                c=p;
                p=HuffNode[c].parent;
            }
            
           
            for (j=cd.start+1; j<l; j++)
            { HuffCode[i].bit[j] = cd.bit[j];}
            HuffCode[i].start = cd.start;
        }
    int y = 0;
        for (int i=0; i<l; i++)
        {
            for (j=HuffCode[i].start+1; j < l; j++)
            {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(210+10*y,400+20*i,300,150)];
                label.text = [NSString stringWithFormat:@"%d",HuffCode[i].bit[j]];
                y = y+1;
                [self.liulan addSubview:label];

            }
            y = 0;
             printf ("\n");
        }//显示哈弗曼编码的结果
    for(int n=0;n<l;n++){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(120,400+20*n,300,150)];
        label.text = [NSString stringWithFormat:@"%d",b[n]];
        [self.liulan addSubview:label];
    }

    for(int n=0;n<l;n++){
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30,400+20*n,300,150)];
        label.text = [NSString stringWithFormat:@"%d",a[n]];
        [self.liulan addSubview:label];
    }
    
//显示其余项的数值
       [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
        //[picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gc.image = [UIImage imageNamed:@"symbol.jpg"];
    self.liulan.contentSize=CGSizeMake(0, 2200);
[super viewDidLoad];
       // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
