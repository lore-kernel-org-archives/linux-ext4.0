From: =?utf-8?b?6Zmz54Kr5bu3?= <acht93@cs.ccu.edu.tw>
Subject: Re: E2fsprogs master branch now has all 64-bit patch applied
Date: Mon, 21 Jun 2010 21:59:50 +0800
Message-ID: <20100621215950.96874n172zixms2s@mail.cs.ccu.edu.tw>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.cs.ccu.edu.tw ([140.123.101.188]:59974 "EHLO
	mail.cs.ccu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab0FUOIw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jun 2010 10:08:52 -0400
Received: from mail.cs.ccu.edu.tw (unknown [127.0.0.1])
	by localhost (Postfix) with SMTP id AD73D153487
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jun 2010 21:59:50 +0800 (CST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

    Resize seems not work when the size is bigger than 16TB (offline resize).

My test machine:
x64 platform 2.6.32 kernel + this newest patch

1. <16TB ext4 enlarge to >16TB (offline)

     a. I use "8 x 2TB WD disks" and "mdadm" build linear raid
     b. then use mkfs.ext4 to make ext4 file system
     c. grow the linear raid to "10 X 2TB"
     d. finally it grow to "2.X TB" smaller than before

2. >16TB offline resize, the steps is similiar as before.
    a. I use "9 x 2TB WD disks" build linear raid
    b. mkfs.ext4 and not mount

    c. grow the linear raid to "10 X 2TB"
    d. do resize
    e. finally it grow to "2.X TB" smaller than before

*. Base on my trace, seems the "EXT4_FEATURE_INCOMPAT_64BIT"
not on when mkfs.ext4. So the new_size is wrong when do "resize",
*. When do resize,  "EXT2_FLAG_64BITS" not add to fs->flags.
So when execute "ext2fs_allocate_block_bitmap" function in resize process,
it won't go to 64bit check path.
*. And in "adjust_fs_info" function, I think should modify the following code
-       fs->desc_blocks = ext2fs_div_ceil(fs->group_desc_count,
+      fs->desc_blocks = ext2fs_div64_ceil(fs->group_desc_count,
                                           EXT2_DESC_PER_BLOCK(fs->super));

I try to on "EXT4_FEATURE_INCOMPAT_64BIT" and "EXT2_FLAG_64BITS"
when mkfs and resize.
And modify ext2fs_div_ceil code to ext2fs_div64_ceil.
It seems work something, the fs size isn't grow but also not deduce,
remain the same.

If you have any new patch, I can help to test. Thanks.

                                                                        
                  -HsuanTing
Best Regards,
