From: Autif Khan <autif.mlist@gmail.com>
Subject: Filesystem state: clean with errors - what errors?
Date: Mon, 3 Jun 2013 14:45:07 -0400
Message-ID: <CADzUK1K08XjYuz_Mrv6sF8e7-M9ToStfjN7e7s3v+2q9wX+-xQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:33254 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982Ab3FCSuq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Jun 2013 14:50:46 -0400
Received: by mail-la0-f51.google.com with SMTP id lx15so3827985lab.10
        for <linux-ext4@vger.kernel.org>; Mon, 03 Jun 2013 11:50:44 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Executing dumpe2fs -h on one of the partitions says

...
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype extent flex_bg sparse_super large_file huge_file uninit_bg
dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean with errors
...

How can I find out what the errors are - the details of the errors.

Thanks

Autif

Some more logs (I am not sure I see an error here):

Group 0: (Blocks 0-32767) [ITABLE_ZEROED]
  Checksum 0xc4c7, unused inodes 0
  Primary superblock at 0, Group descriptors at 1-1
  Reserved GDT blocks at 2-256
  Block bitmap at 257 (+257), Inode bitmap at 273 (+273)
  Inode table at 289-800 (+289)
  21467 free blocks, 0 free inodes, 1834 directories
  Free blocks: 11301-32767
  Free inodes:
Group 1: (Blocks 32768-65535) [ITABLE_ZEROED]
  Checksum 0xc9c2, unused inodes 623
  Backup superblock at 32768, Group descriptors at 32769-32769
  Reserved GDT blocks at 32770-33024
  Block bitmap at 258 (bg #0 + 258), Inode bitmap at 274 (bg #0 + 274)
  Inode table at 801-1312 (bg #0 + 801)
  0 free blocks, 623 free inodes, 974 directories, 623 unused inodes
  Free blocks:
  Free inodes: 15762-16384
Group 2: (Blocks 65536-98303) [INODE_UNINIT, ITABLE_ZEROED]
...
Group 16: (Blocks 524288-557055) [ITABLE_ZEROED]
  Checksum 0xcee5, unused inodes 0
  Block bitmap at 524288 (+0), Inode bitmap at 524304 (+16)
  Inode table at 524320-524831 (+32)
  22714 free blocks, 0 free inodes, 1672 directories
  Free blocks: 534342-557055
  Free inodes:
Group 17: (Blocks 557056-589823) [ITABLE_ZEROED]
  Checksum 0x9983, unused inodes 7375
  Block bitmap at 524289 (bg #16 + 1), Inode bitmap at 524305 (bg #16 + 17)
  Inode table at 524832-525343 (bg #16 + 544)
  16730 free blocks, 7375 free inodes, 140 directories, 7375 unused inodes
  Free blocks: 557571-558079, 565411-573439, 581632-589823
  Free inodes: 140082-147456
Group 18: (Blocks 589824-622591) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
...

Everything else is INODE_UNINIT
