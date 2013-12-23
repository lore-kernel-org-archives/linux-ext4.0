From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] e2fsck: verify s_desc_size is power-of-two value
Date: Mon, 23 Dec 2013 16:07:38 -0500
Message-ID: <20131223210738.GB11299@thunk.org>
References: <1387268344-8320-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42884 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757622Ab3LWVO7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Dec 2013 16:14:59 -0500
Content-Disposition: inline
In-Reply-To: <1387268344-8320-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 17, 2013 at 01:19:03AM -0700, Andreas Dilger wrote:
> Add a LOG2_CHECK mode for check_super_value() so that it is easy
> to verify values that are supposed to be power-of-two values
> (s_desc_size and s_inode_size so far).  In ext2fs_check_desc()
> also check for a power-of-two s_desc_size.
> 
> Print out s_desc_size in debugfs "stats" and dumpe2fs output, if
> it is non-zero.
> 
> It turns out that the s_desc_size validation in check_super_block()
> is not currently used by e2fsck, because the group descriptors are
> verified earlier by ext2fs_check_desc(), and even without an
> explicit check of s_desc_size the group descriptors fail to align
> correctly on disk.  It makes sense to keep the check_super_block()
> regardless, in case the code changes at some point in the future.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

						- Ted
