From: Andreas Dilger <adilger@dilger.ca>
Subject: broken commit 25567a7b0fa98b390fd1ff0d4702b29c23a75bbb
Date: Fri, 8 Jul 2011 18:07:14 -0600
Message-ID: <7EF281B4-882D-4F81-AEF8-404D2C3C0B76@dilger.ca>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:16619 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab1GIAHP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Jul 2011 20:07:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In my pull from e2fsprogs git "master" branch, it contains commit
25567a7b0fa98b390fd1ff0d4702b29c23a75bbb "support for bigalloc
file systems with a blocksize of 1024" that deletes the initialization
of the flexbg_size variable from lib/ext2fs/alloc_tables.c::flexbg_offset():

-       flexbg_size = 1 << fs->super->s_log_groups_per_flex;
-       flexbg = group / flexbg_size;
+       size = rem_grp * elem_size;

but it continues to use flexbg_size later on in this function:

       start_blk = ext2fs_group_first_block2(fs, flexbg_size * flexbg);
       last_grp = group | (flexbg_size - 1);

This provokes an uninitialized compiler warning (I always use CFLAGS=-Wall),
but it isn't clear to me at first glance what the intention of this change
is or how to fix it.

It doesn't cause any "make check" errors, but that is almost certainly
only because very few tests run with flex_bg enabled, but it is definitely
a bug that would cause strange behaviour.

Cheers, Andreas





