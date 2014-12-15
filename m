From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 26/47] resize2fs: use old_fs to detect per-bg metadata
 blocks to free
Date: Sun, 14 Dec 2014 21:09:51 -0500
Message-ID: <20141215020951.GB17575@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215335.883.83617.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55832 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbaLOCJw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Dec 2014 21:09:52 -0500
Content-Disposition: inline
In-Reply-To: <20141107215335.883.83617.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:53:35PM -0800, Darrick J. Wong wrote:
> When shrinking a filesystem, resize2fs wants to free per-bg metadata
> blocks that are no longer needed.  This behavior is gated on whether
> there's a superblock in the group as told by new_fs.  The check really
> should be against old_fs, since we're effectively freeing blocks out
> of old_fs in the transition to new_fs, but prior to sparse_super2 this
> didn't matter since superblocks didn't move, so it didn't matter.
> 
> Under sparse_super2, however, there's a superblock in the last group,
> so now we need to change the test to use old_fs as it should.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
