---
title: PHP工具函数-图片工具-生成微信分享图片
date: 2019-08-13 19:45:06
tags:
  - PHP
  - 工具函数
  - 图片函数
categories: rd
---

先上效果图
![微信分享自定义图片](/images/20190813-1.jpeg)

用到的函数
`getimagesize()`
`imagecreatetruecolor()`
`imagecreatefromjpeg()`
`imagecopyresized()`
`imagecreatefrompng()`
`imagealphablending()`
`imagesavealpha()`
`imagecopy()`
`imagecolorallocate()`
`imagettftext()`

***
```
    /**
     * 获取远程图片
     * @param $file
     * @param $from
     */
    function get_file($file, $from) {
        file_put_contents(sys_get_temp_dir() . "/" . $file, file_get_contents($from));
    }

    /**
     * 合成图片
     */
    public function test_merge_image() {
        // 将两个远程的图片存到本地临时文件夹
        $this->get_file('egg', 'https://goods-image.qiniu.cainiaoshicai.cn/Fg1pPDcuBpeSqA1L7OOyIjY4b470');
        $this->get_file('date', 'http://cm-images.cainiaoshicai.cn/wxminiapp/image/pricecontainer.png');

        $bannerimg = sys_get_temp_dir() . '/egg';
        $bottom = sys_get_temp_dir() . '/date';

        // 获取图片原式
        list($width, $height) = getimagesize($bannerimg);
        // 创建微信5:4的画布
        $thumb = imagecreatetruecolor(800, 640);

        $image_1 = imagecreatefromjpeg($bannerimg);
        // 改变背景图大小 并画到画布上
        imagecopyresized($thumb, $image_1, 0, 0, 0, 0, 800, 640, $width, $height);

        $image_2 = imagecreatefrompng($bottom);

        imagealphablending($thumb, true);
        imagesavealpha($thumb, true);
        // 将底部图片 放到图片上
        imagecopy($thumb, $image_2, 0, 0, 0, 160, 800, 800);

        $textColor = imagecolorallocate($thumb, 255, 255, 255);
        $black = imagecolorallocate($thumb, 0, 0, 0);

        // 往图片上写文字 *.otf *.ttf 都是字体文件
        imagettftext($thumb, 40, 0, 40, 600, $textColor, sys_get_temp_dir() . 'a.otf', '￥');
        imagettftext($thumb, 60, 0, 90, 600, $textColor, sys_get_temp_dir() . 'b.ttf', '23.50');

        imagettftext($thumb, 30, 0, 330, 596, $textColor, sys_get_temp_dir() . 'a.otf', '￥' . number_format('23.50' * 1.2, 2));
        imagettftext($thumb, 30, 0, 335, 592, $textColor, sys_get_temp_dir() . 'a.otf', '————');

        imagettftext($thumb, 30, 0, 570, 600, $black, sys_get_temp_dir() . 'a.otf', '销量20076');
        // 输出图片格式的响应
        header('Content-type: image/png;charset=utf-8');
        // 生成图片 第二个参数可以传本地路径
        imagepng($thumb);
        // 销毁图片
        imagedestroy($thumb);
    }

    /**
     * 获取图片拓展名
     */
    public function test_image_extension() {
        $this->autoRender = false;
        print_r(getimagesize('https://goods-image.qiniu.cainiaoshicai.cn/Fg1pPDcuBpeSqA1L7OOyIjY4b470'));
    }
```
