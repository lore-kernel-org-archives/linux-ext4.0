From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Reserved blocks list in ext* filesystem
Date: Mon, 15 Dec 2014 15:15:39 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1412151507280.2842@localhost.localdomain>
References: <CACMrma6mbrN3f82F+tXTPJdBcWHOu+yB4JcK9U-ALjwb=YcQ9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Jitendra Pawar <jitendra.pawar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbaLOOPn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Dec 2014 09:15:43 -0500
In-Reply-To: <CACMrma6mbrN3f82F+tXTPJdBcWHOu+yB4JcK9U-ALjwb=YcQ9A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 15 Dec 2014, Jitendra Pawar wrote:

> Date: Mon, 15 Dec 2014 19:31:11 +0530
> From: Jitendra Pawar <jitendra.pawar@gmail.com>
> To: linux-ext4@vger.kernel.org
> Subject: Reserved blocks list in ext* filesystem
> 
> Hi,
> 
> Below is snippet of superblock information of one of the block
> device(say /dev/sda1)
> Which mentions about the reserved blocks-
> Reserved block count:     25600
> Does anyone know about how to find out list of blocks which are
> reserved(actual block numbers not count).

There are no statically reserved blocks. Reserved block count is a
number of free block bellow which a non-privileged processes are no
more allowed to allocate additional space from the file system.


In other words (see man mkfs.ext4):

Specify the percentage of the filesystem blocks reserved for the
super-user.  This avoids fragmentation,  and  allows root-owned  daemons,
such as syslogd(8), to continue to function correctly after non-privileged
processes are prevented from writing to the filesystem.  The default
percentage is 5%.

-Lukas

> 
> -------------------------------------------------
> Filesystem volume name:   <none>
> Last mounted on:          /boot
> Filesystem UUID:          99ec51e5-8729-4cab-b2ea-6b55b302aae6
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal ext_attr resize_inode dir_index
> filetype needs_recovery extent flex_bg sparse_super huge_file
> uninit_bg dir_nlink extra_isize
> Filesystem flags:         signed_directory_hash
> Default mount options:    user_xattr acl
> Filesystem state:         clean
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              128016
> Block count:              512000
> Reserved block count:     25600
> Free blocks:              439769
> Free inodes:              127977
> First block:              1
> Block size:               1024
> Fragment size:            1024
> Reserved GDT blocks:      256
> Blocks per group:         8192
> Fragments per group:      8192
> Inodes per group:         2032
> Inode blocks per group:   254
> Flex block group size:    16
> Filesystem created:       Thu Aug  8 06:35:16 2013
> Last mount time:          Tue Nov 25 18:52:26 2014
> Last write time:          Tue Nov 25 18:52:26 2014
> Mount count:              12
> Maximum mount count:      -1
> Last checked:             Thu Aug  8 06:35:16 2013
> Check interval:           0 (<none>)
> Lifetime writes:          105 MB
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:              128
> Journal inode:            8
> Default directory hash:   half_md4
> Directory Hash Seed:      4c6e20ac-c46d-4bf1-81c1-3c5ae77eaab7
> Journal backup:           inode blocks
> Journal features:         journal_incompat_revoke
> Journal size:             8M
> Journal length:           8192
> Journal sequence:         0x00000028
> Journal start:            0
> ---------------------------------------------
> 
> Thanks,
> -Jitendra
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
