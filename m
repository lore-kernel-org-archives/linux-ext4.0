From: Jitendra Pawar <jitendra.pawar@gmail.com>
Subject: Reserved blocks list in ext* filesystem
Date: Mon, 15 Dec 2014 19:31:11 +0530
Message-ID: <CACMrma6mbrN3f82F+tXTPJdBcWHOu+yB4JcK9U-ALjwb=YcQ9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:53493 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaLOOBM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Dec 2014 09:01:12 -0500
Received: by mail-oi0-f48.google.com with SMTP id u20so7948940oif.7
        for <linux-ext4@vger.kernel.org>; Mon, 15 Dec 2014 06:01:11 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Below is snippet of superblock information of one of the block
device(say /dev/sda1)
Which mentions about the reserved blocks-
Reserved block count:     25600
Does anyone know about how to find out list of blocks which are
reserved(actual block numbers not count).

-------------------------------------------------
Filesystem volume name:   <none>
Last mounted on:          /boot
Filesystem UUID:          99ec51e5-8729-4cab-b2ea-6b55b302aae6
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype needs_recovery extent flex_bg sparse_super huge_file
uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              128016
Block count:              512000
Reserved block count:     25600
Free blocks:              439769
Free inodes:              127977
First block:              1
Block size:               1024
Fragment size:            1024
Reserved GDT blocks:      256
Blocks per group:         8192
Fragments per group:      8192
Inodes per group:         2032
Inode blocks per group:   254
Flex block group size:    16
Filesystem created:       Thu Aug  8 06:35:16 2013
Last mount time:          Tue Nov 25 18:52:26 2014
Last write time:          Tue Nov 25 18:52:26 2014
Mount count:              12
Maximum mount count:      -1
Last checked:             Thu Aug  8 06:35:16 2013
Check interval:           0 (<none>)
Lifetime writes:          105 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:              128
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      4c6e20ac-c46d-4bf1-81c1-3c5ae77eaab7
Journal backup:           inode blocks
Journal features:         journal_incompat_revoke
Journal size:             8M
Journal length:           8192
Journal sequence:         0x00000028
Journal start:            0
---------------------------------------------

Thanks,
-Jitendra
