From: Nikhilesh Reddy <reddyn@codeaurora.org>
Subject: Emergency remount readonly and EFBIG errors when unlinking files
 on 3.18 android kernel
Date: Tue, 26 Apr 2016 15:08:27 -0700
Message-ID: <571FE6DB.8030604@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48822 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbcDZWIa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Apr 2016 18:08:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

As you know Android uses emergency remount instead of doing something 
like "umount -a" in its shutdown/reboot path.

https://android.googlesource.com/platform/system/core/+/master/libcutils/android_reboot.c#132

I have seen a strange issue that sometimes occurs when there are a large 
number of writes to an ext4 file system and an adb reboot is issued ( 
triggering an emergency remount readonly and a reboot)

Teh issue doesnt happen all the writer processes are killed before the 
emergency remount

And on disk we see that one of the files being written to has incorrect
ext4_inode->i_blocks_lo ( which is less than the the size of the file by 
something like 2k)

When unlinking this file the vfs inode->iblocks underflows and we end up 
with EFBIG if EXT4_FEATURE_RO_COMPAT_HUGE_FILE is not enabled in the 
superblock.

Is this a known issue?

I am still trying to figure out why we have a incorrect i_blocks_lo on 
the disk.

Running fsck on the partition does fix the issue but i am trying to 
figure out why this would happen and how to fix it.

I would appreciate if you could point me in the right direction and any 
help you can give me.

-- 
Thanks
Nikhilesh Reddy

Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
