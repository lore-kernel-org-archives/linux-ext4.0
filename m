From: Chanho Park <chanho61.park@samsung.com>
Subject: [e2fsprogs] resizing to minimum was failed since 45a78b
Date: Wed, 29 Apr 2015 17:33:20 +0900
Message-ID: <01cb01d08257$26157350$724059f0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: darrick.wong@oracle.com, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:48562 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031507AbbD2IdW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Apr 2015 04:33:22 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NNK00BMT7RKTC20@mailout2.samsung.com> for
 linux-ext4@vger.kernel.org; Wed, 29 Apr 2015 17:33:20 +0900 (KST)
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

When I tried to resize a loop ext4 image to minimum, I couldn't get correct
result.
Please see below test and results:

1. e2fsprogs 1.43-WIP version:

mke2fs -F -t ext4 foo.img 512M
mount foo.img mnt1
dd if=/dev/zero of=mnt1/test bs=1M count=350
df | grep mnt1
/dev/loop0        499656  358796    104164  78% /mnt1

umount mnt1
e2fsck -f foo.img

resize2fs -M foo.img
resize2fs 1.43-WIP (29-Mar-2015)
Resizing the filesystem on foo.img to 129175 (4k) blocks.
The filesystem on foo.img is now 129175 (4k) blocks long.

ls -al foo.img
-rw-r--r-- 1 root root 529100800 Apr 29 08:00 foo.img

2. e2fsprogs 1.42.9 version:
mke2fs -F -t ext4 bar.img 512M
mount bar.img mnt2
dd if=/dev/zero of=mnt2/test bs=1M count=350
umount mnt2
e2fsck -f bar.img

resize2fs -M bar.img
resize2fs 1.42.9 (28-Dec-2013)
Resizing the filesystem on bar.img to 103592 (4k) blocks.
The filesystem on bar.img is now 103592 blocks long.

ls -al bar.img
-rw-r--r-- 1 root root 424312832 Apr 29 08:04 bar.img

1.43-WIP version: 529100800 -> 529100800
1.42.9 version: 529100800 -> 424312832

Furthermore, the resizing to minimum was failed if the loop image was filled
over 84%.
I found it was changed since (45a78b8 resize2fs: refine minimum required
blocks for flex_bg file systems)
Is it correct or something's wrong?

Best Regards,
Chanho Park

