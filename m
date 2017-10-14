From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [1/2] libext2fs: Prevent allocating inode table from already
 used blocks
Date: Sat, 14 Oct 2017 10:50:34 -0400
Message-ID: <20171014145034.v2gxdeihhyxgjebr@thunk.org>
References: <1503581739-6385-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47332 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753198AbdJNOuh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 14 Oct 2017 10:50:37 -0400
Content-Disposition: inline
In-Reply-To: <1503581739-6385-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 24, 2017 at 03:35:38PM +0200, Lukas Czerner wrote:
> Currently it's possible for ext2fs_allocate_group_table() to place inode
> tables to blocks that are already occupied by different inode table.
> This can be reproduced by resize2fs on the file system where we need to
> move more than one inode table to a different location due to increase
> in group descriptor blocks, inode and block bitmaps.
> 
> Best way I can reproduce this is to create big enough file system with
> huge amount of inodes and without resize_inode
> 
> mke2fs -F -b 1024 -i 1024 -O ^resize_inode -t ext4 /dev/loop0 1024000
> resize2fs /dev/loop0 10240000
> 
> e2fsck -fn /dev/loop0 | less
> e2fsck 1.43.5 (04-Aug-2017)
> ext2fs_check_desc: Corrupt group descriptor: bad block for inode table
> e2fsck: Group descriptors look bad... trying backup blocks...
> e2fsck: The journal superblock is corrupt while checking journal for /dev/loop0
> e2fsck: Cannot proceed with file system check
> Superblock has an invalid journal (inode 8).
> Clear? no
> 
> /dev/loop0: ********** WARNING: Filesystem still has errors **********
> 
> None of the settings are strictly necessary and it can be reproducer in
> various ways. This is just an example of one easy way to reproduce this.
> 
> This bug was introduced with commit fccdbac39454 ("libext2fs: optimize
> ext2fs_allocate_group_table()") and is caused by the fact that wrong
> bitmap is used to mark the blocks as used.
> 
> Fix this by using ext2fs_mark_block_bitmap_range2() in both (flex_bg and
> non flex_bg) cases and handle flex_bg case manually instead of relying
> on ext2fs_block_alloc_stats_range() because there is no way in that
> function to use different bitmap than fs->block_map.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.  Apologies for taking so long to apply this.

		  	    	       - Ted
