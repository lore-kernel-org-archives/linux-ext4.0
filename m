From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] debugfs, e2fsck: fix s_desc_size handling
Date: Mon, 23 Dec 2013 16:07:50 -0500
Message-ID: <20131223210749.GC11299@thunk.org>
References: <1387268344-8320-1-git-send-email-adilger@dilger.ca>
 <1387268344-8320-2-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42883 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab3LWVO6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Dec 2013 16:14:58 -0500
Content-Disposition: inline
In-Reply-To: <1387268344-8320-2-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 17, 2013 at 01:19:04AM -0700, Andreas Dilger wrote:
> The s_desc_size in the superblock specifies the group descriptor
> size in bytes, but in various places the EXT4_FEATURE_INCOMPAT_64BIT
> flag implies that the descriptor size is EXT2_MIN_DESC_SIZE_64BIT
> (64 bytes) instead of checking the actual size.  In other places,
> the s_desc_size field is used without checking for INCOMPAT_64BIT.
> 
> In the case of ext2fs_group_desc() the s_desc_size was being ignored,
> and assumed to be sizeof(struct ext4_group_desc), which would result
> in garbage for any but the first group descriptor.  Similarly, in
> ext2fs_group_desc_csum() and print_csum() they assumed that the
> maximum group descriptor size was sizeof(struct ext4_group_desc).
> Fix these functions to use the actual superblock s_desc_size if
> INCOMPAT_64BIT.
> 
> Conversely, in ext2fs_swap_group_desc2() s_desc_size was used
> without checking for INCOMPAT_64BIT being set.
> 
> The e2fsprogs behaviour is different than that of the kernel,
> which always checks INCOMPAT_64BIT, and only uses s_desc_size to
> determine the offset of group descriptors and what range of bytes
> to checksum.
> 
> Allow specifying the s_desc_size field at mke2fs time with the
> "-E desc_size=NNN" option.  Allow a power-of-two s_desc_size
> value up to s_blocksize if INCOMPAT_64BIT is specified.  This
> is not expected to be used by regular users at this time, so it
> is not currently documented in the mke2fs usage or man page.
> 
> Add m_desc_size_128, f_desc_size_128, and f_desc_bad test cases to
> verify mke2fs and e2fsck handling of larger group descriptor sizes.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

						- Ted
