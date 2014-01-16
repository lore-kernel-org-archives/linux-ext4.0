From: Subranshu Patel <spatel.ml@gmail.com>
Subject: Dumpe2fs output with primary and backup superblock are different?
Date: Thu, 16 Jan 2014 16:14:14 +0530
Message-ID: <CAEUQcegq-ZmgJ2Cr+jqr=1HiOK+NqnvBoxH0JQ3fTYXOd+Z83g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:48796 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaAPKuC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Jan 2014 05:50:02 -0500
Received: by mail-we0-f171.google.com with SMTP id w61so3034223wes.30
        for <linux-ext4@vger.kernel.org>; Thu, 16 Jan 2014 02:50:01 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I am using dumpe2fs command using primary superblock (default) and
backup superblock. In both the cases the output is different.

 I followed the following steps:

1. Create EXT4 filesystem of 4TiB

2. Run dumpe2fs (unmounted filesyetm) using default parameters #
dumpe2fs /dev/mapper/my_vg-dup >file1

 3. Run dumpe2fs (unmounted filesystem) using backup superblock #
dumpe2fs -o superblock=32768 /dev/mapper/my_vg-dup >file2

4. The output of step-2 and step-3 are different

For example:

 # diff -Nrup file1 file2

 ------------------8<-------------------------------

Group 0: (Blocks 0-32767) [ITABLE_ZEROED]

-  Checksum 0xd85a, unused inodes 8181

+  Checksum 0x405c, unused inodes 0

   Primary superblock at 0, Group descriptors at 1-64

   Reserved GDT blocks at 65-1024

   Block bitmap at 1025 (+1025), Inode bitmap at 1041 (+1041)

   Inode table at 1057-1568 (+1057)

-  23513 free blocks, 8181 free inodes, 2 directories, 8181 unused inodes

+  23513 free blocks, 8181 free inodes, 2 directories

   Free blocks: 9255-32767

   Free inodes: 12-8192


-Group 1: (Blocks 32768-65535) [INODE_UNINIT, ITABLE_ZEROED]

-  Checksum 0xa883, unused inodes 8192

+Group 1: (Blocks 32768-65535) [ITABLE_ZEROED]

+  Checksum 0xb37f, unused inodes 0

   Backup superblock at 32768, Group descriptors at 32769-32832

   Reserved GDT blocks at 32833-33792

   Block bitmap at 1026 (+4294935554), Inode bitmap at 1042 (+4294935570)

   Inode table at 1569-2080 (+4294936097)

-  31743 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes

+  31743 free blocks, 8192 free inodes, 0 directories

   Free blocks: 33793-65535

-  Free inodes: 8193-16384

------------------8<-------------------------------

Here we can see that there are difference between the two outputs.

For example, in Group 0, with primary superblock it shows that unused
inodes is 8181. With backup superblock unused inodes is 0.

 Why there is a difference in the output. Shouldn't it should same
output with both primary and secondary superblock?

(E2progfs verison is 1.41.12)
