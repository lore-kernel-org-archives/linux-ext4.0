From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Question about ext4 project feature
Date: Thu, 29 Jun 2017 18:46:21 +0800
Message-ID: <1939863a-d866-69ff-f3ab-55692102473e@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, <adilger@dilger.ca>,
        <miaoxie@huawei.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([45.249.212.189]:8401 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752463AbdF2Kql (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Jun 2017 06:46:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All:

I find a problem when I use project quota, my base environment is
radhat7.2 (kernel-3.10.y + e2fsprogs-1.42.9).

It will be reproduced with the following steps:
1. mkfs.ext4 /dev/vdb1
2. mount /dev/vdb1 /mnt
3. touch /mnt/testfile
4. umount /mnt
5. Update kernel and e2fsprogs to *upstream stable version*
6. tune2fs -O quota,project /dev/vdb1
7. mount /dev/vdb1 /mnt
8. chattr -p 123 /mnt/testfile

Execute fail and output:
/bin/chattr: Value too large for defined data type while setting project on /mnt/aa

The immediate reason is the following check, i_extra_isize is not updated.
static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
{
	...
	raw_inode = ext4_raw_inode(&iloc);
	if (!EXT4_FITS_IN_INODE(raw_inode, ei, i_projid)) {
		err = -EOVERFLOW;
		brelse(iloc.bh);
		goto out_unlock;
	}
	...
}

So if I write something to testfile before "step 8" ,the chattr will execute
successfully, because it trigger ext4_expand_extra_isize() to update
i_extra_isize. So is this a BUG or I miss something?
