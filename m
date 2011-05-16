From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Use of consistent types in e2fsprogs
Date: Mon, 16 May 2011 15:55:54 -0600
Message-ID: <DC591D7D-86E5-4FA6-BC8F-859F1965C51D@dilger.ca>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:46024 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1EPVzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 May 2011 17:55:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While inspecting the qcow2 format code, I was checking whether it was going to correctly support 64-bit filesystems.  It looks like the qcow2 format itself supports 64-bit filesystems, which is good, but I also found inconsistent use of types within libext2fs for block numbers, file offsets, groups, inodes, etc.

There are uses of blk64_t, ext2_off64_t, long long, (unsigned) long, etc. in the libext2fs code.  The currently defined types are:

typedef __u32           blk_t;
typedef __u64           blk64_t;
typedef __u32           dgrp_t;
typedef __u32           ext2_off_t;
typedef __u64           ext2_off64_t;
typedef __s64           e2_blkcnt_t;

It would be nice to get some consistent naming for these types, like ext2_blk_t, ext2_blk64_t (or possibly ext2_fsblk_t to match the kernel), ext2_group_t, and ext2_blkcnt_t (this appears to be negative in some places, so isn't easily replaced with ext2_blk64_t.

For example, io_channel_read_blk64() uses "long long", while both ext2fs_{read,write}_inode_full() _incorrectly_ use "unsigned long".  I guess this wasn't noticed because > 16TB isn't directly usable on 32-bit Linux due to the block device limits, but it doesn't seem right to leave it as-is.

I understand it would be a lot of code churn, but I think it would be valuable to fix up the types used in e2fsprogs in order to clarify usage and remove errors, just like we did with the kernel code.  Is there any interest in accepting patches like this upstream?  Both ext2fs_{read,write}_inode_full() need to be fixed, and I expect even more places will need fixing.

Cheers, Andreas






Cheers, Andreas





