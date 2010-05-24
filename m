From: tytso@mit.edu
Subject: Re: [PATCH 1/2] ext4: Use bitops to read/modify
 EXT4_I(inode)->i_flags
Date: Sun, 23 May 2010 23:09:54 -0400
Message-ID: <20100524030954.GA4606@thunk.org>
References: <1271687537-15655-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:45065 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756008Ab0EXDJ5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 May 2010 23:09:57 -0400
Content-Disposition: inline
In-Reply-To: <1271687537-15655-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 19, 2010 at 06:32:16PM +0400, Dmitry Monakhov wrote:
> At several places we modify EXT4_I(inode)->i_flags without holding
> i_mutex (ext4_do_update_inode, ...). These modifications are racy and we can
> lose updates to i_flags. So convert handling of i_flags to use bitops
> which are atomic.
> https://bugzilla.kernel.org/show_bug.cgi?id=15792

I don't think it would cause any harm, since those flags aren't used
(yet) but this patch is buggy; The values for EXT4_INODE_EA_INODE, and
EXT4_INODE_RESERVED are wrong.  Fortunately I'm a paranoid b*stard, so
I caught it by *not* deleting the explicit EXT4_XXX_FL flags, and
using this:

#define TEST_FLAG_VALUE(FLAG) (EXT4_##FLAG##_FL == (1 << EXT4_INODE_##FLAG))
#define CHECK_FLAG_VALUE(FLAG) if (!TEST_FLAG_VALUE(FLAG)) { \
	printk("EXT4 flag fail: " #FLAG ": %d %d\n", EXT4_##FLAG##_FL, \
	       EXT4_INODE_##FLAG); BUG_ON(1); }

/*
 * Since it's pretty easy to mix up bit numbers and hex values, and we
 * can't do a compile-time test for ENUM values, we use a run-time
 * test to make sure that EXT4_XXX_FL is consistent with respect to
 * EXT4_INODE_XXX.  If all is well the printk and BUG_ON will all drop
 * out so it won't cost any extra space in the compiled kernel image.
 * But it's important that these values are the same, since we are
 * using EXT4_INODE_XXX to test for the flag values, but EXT4_XX_FL
 * must be consistent with the values of FS_XXX_FL defined in
 * include/linux/fs.h and the on-disk values found in ext2, ext3, and
 * ext4 filesystems, and of course the values defined in e2fsprogs.
 *
 * It's not paranoia if Murphy's Law really *is* out to get you.  :-)
 */
static inline void ext4_check_flag_values(void)
{
	CHECK_FLAG_VALUE(SECRM);
	CHECK_FLAG_VALUE(UNRM);
	CHECK_FLAG_VALUE(COMPR);
	CHECK_FLAG_VALUE(SYNC);
	CHECK_FLAG_VALUE(IMMUTABLE);
	CHECK_FLAG_VALUE(APPEND);
	CHECK_FLAG_VALUE(NODUMP);
	CHECK_FLAG_VALUE(NOATIME);
	CHECK_FLAG_VALUE(DIRTY);
	CHECK_FLAG_VALUE(COMPRBLK);
	CHECK_FLAG_VALUE(NOCOMPR);
	CHECK_FLAG_VALUE(ECOMPR);
	CHECK_FLAG_VALUE(INDEX);
	CHECK_FLAG_VALUE(IMAGIC);
	CHECK_FLAG_VALUE(JOURNAL_DATA);
	CHECK_FLAG_VALUE(NOTAIL);
	CHECK_FLAG_VALUE(DIRSYNC);
	CHECK_FLAG_VALUE(TOPDIR);
	CHECK_FLAG_VALUE(HUGE_FILE);
	CHECK_FLAG_VALUE(EXTENTS);
	CHECK_FLAG_VALUE(EA_INODE);
	CHECK_FLAG_VALUE(EOFBLOCKS);
	CHECK_FLAG_VALUE(RESERVED);
}

I'll send the full patch after I finish doing some testing, but I
thought I'd just point this out before I hit the sack...

	    	       	    	       	 - Ted
