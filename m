From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/6] findsuper: improve output if s_mkfs_time unset
Date: Sun, 6 Mar 2016 18:16:19 -0500
Message-ID: <20160306231619.GE30238@thunk.org>
References: <1457224716-72388-1-git-send-email-adilger@dilger.ca>
 <1457224716-72388-5-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38316 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbcCFXQV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Mar 2016 18:16:21 -0500
Content-Disposition: inline
In-Reply-To: <1457224716-72388-5-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 05, 2016 at 05:38:35PM -0700, Andreas Dilger wrote:
> If s_mkfs_time is not set in the superblock, print the s_mtime field
> instead to identify the different superblocks.  This can happen if the
> superblock is corrupted, since s_mkfs_time is not reset by e2fsck.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

						- Ted
