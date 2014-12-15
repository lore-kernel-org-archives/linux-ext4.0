From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 30/47] resize2fs: don't play stupid games with the block
 count
Date: Sun, 14 Dec 2014 22:13:28 -0500
Message-ID: <20141215031328.GF17575@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215401.883.74477.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55908 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaLODNb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Dec 2014 22:13:31 -0500
Content-Disposition: inline
In-Reply-To: <20141107215401.883.74477.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:54:01PM -0800, Darrick J. Wong wrote:
> While it may be true that playing games with old_fs' block count
> during a grow operation shuts up a bunch of warnings, resize2fs
> doesn't actually expand the group descriptor array to match the size
> we're artificially stuffing into old_fs, which means that if we
> actually need to allocate a block out of the larger fs (i.e. we're in
> desperation mode), ext2fs_block_alloc_stats2() scribbles on the heap,
> leading to crashes if you're lucky and FS corruption if not.
> 
> So, rip that piece out and turn off com_err warnings properly and add
> a test case to deal with growing a nearly full filesystem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
