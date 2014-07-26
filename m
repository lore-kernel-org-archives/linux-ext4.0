From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/18] e2fsck: during pass1b delete_file, only free a
 cluster once
Date: Sat, 26 Jul 2014 16:30:32 -0400
Message-ID: <20140726203032.GN6725@thunk.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
 <20140726003410.28334.82583.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58713 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbaGZUae (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 16:30:34 -0400
Content-Disposition: inline
In-Reply-To: <20140726003410.28334.82583.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 25, 2014 at 05:34:10PM -0700, Darrick J. Wong wrote:
> If we're forced to delete a crosslinked file, only call
> ext2fs_block_alloc_stats2() on cluster boundaries, since the block
> bitmaps are all cluster bitmaps at this point.  It's safe to do this
> only once per cluster since we know all the blocks are going away.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
