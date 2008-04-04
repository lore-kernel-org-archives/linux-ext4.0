From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH][e2fsprogs] New bitmap and inode table allocation for
	FLEX_BG
Date: Fri, 4 Apr 2008 08:43:58 -0400
Message-ID: <20080404124358.GB29297@mit.edu>
References: <20080401031311.10442.12267.stgit@gara.konoha.net> <20080403131240.GA13486@mit.edu> <20080403092858.5e3a7bb2@gara.konoha.net> <20080404032443.GA362@mit.edu> <20080404003757.0894cce1@gara.konoha.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:33326 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752658AbYDDMoH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Apr 2008 08:44:07 -0400
Content-Disposition: inline
In-Reply-To: <20080404003757.0894cce1@gara.konoha.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 04, 2008 at 12:37:57AM -0500, Jose R. Santos wrote:
> Getting the right free block count for every group descriptor seems to
> be the tricky part since libe2fs make all sort of assumptions about
> number of used blocks that break when meta-data is no longer on the
> same block group.  

Originally the overlap you're referring to was very simple.
ext2fs_initialize() set the free block counts, and then
ext2fs_alloc_tables() actually did the allocation of the bitmaps and
inode tables.

Flex_bg made things more complex, but it transferred the
responsibility of setting the block number to the routines that
allocate the inode and bitmaps.

> Seems like I forgot a check for the adjusted flexbg
> block group size in meta_bg since the first place it barfs is in group
> 127 which is the last group of the meta_bg with a group descriptor
> block being used.  This should be easy to find and fix.

It can't be just that since e2fsck is also reporting a block bitmap
discrepancy.  And there's the question of why e2fsck is doing that in
an infinite loop.

Hmm....  So at least part of the problem is that BLOCK_UNINIT isn't
getting set when it should.  That seems to be bug #1, and that was the
proximate cause of the failure, that was triggered by the flex-bg
allocation patch.

In e2fsck pass5, the uninit_groups patch changed it to compare the
actual bitmap against a virtual bitmap if the bitmap block hadn't been
initialized.  (Around line 180, in e2fsck/pass5.c, in the function
check_block_bitmaps()).  The problem is that it is using
ext2fs_bg_has_super(), and assuming that if it is set, that the
superblock and block group descriptors are present using the old-style
non-meta_bg layout.  What it *should* have used is
ext2fs_super_and_bgd_loc(), and used it to set the pseudo-bitmap
correctly.  That's bug #2.

Since it is wrong, it is attempting to fix it, but code to clear
BLOCK_UNINIT is only when the block is used but marked so in the
bitmap --- and not in the other case, when the block isn't used, but
is apparently marked as such.  That's bug #3.

Bugs #2 and #3 is my fault, and reflects the fact that LAZY_BG was a
quick hack that I had coded up only for testing purposes for people
who wanted to play with really big filesystems.  I'll take care of
that, which is why e2fsck was looping.  In retrospect, lazy_bg was a
mistake, or at least should have been implemented *much* more
carefully, and I'm beginning to think it should be removed entirely in
favor of uninit_groups, per my other e-mail.

		    	     		    	   - Ted
