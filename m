From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 09/19] e2fsck: correctly preserve fs flags when modifying
 ignore-csum-error flag
Date: Sat, 2 Aug 2014 22:48:52 -0400
Message-ID: <20140803024852.GI24826@thunk.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
 <20140801181241.12496.65228.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41960 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbaHCCsx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Aug 2014 22:48:53 -0400
Content-Disposition: inline
In-Reply-To: <20140801181241.12496.65228.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 01, 2014 at 11:12:41AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we need to modify the "ignore checksum error" behavior flag to
> get us past a library call, it's possible that the library call can
> result in other flag bits being changed.  Therefore, it is not correct
> to restore unconditionally the previous flags value, since this will
> have unintended side effects on the other fs->flags; nor is it correct
> to assume that we can unconditionally set (or clear) the "ignore csum
> error" flag bit.  Therefore, we must merge the previous value of the
> "ignore csum error" flag with the value of flags after the call.
> 
> Note that we want to leave checksum verification on as much as
> possible because doing so exposes e2fsck bugs where two metadata
> blocks are "sharing" the same disk block, and attempting to fix one
> before relocating the other causes major filesystem damage.  The
> damage is much more obvious when a previously checked piece of
> metadata suddenly fails in a subsequent pass.
> 
> The modifications to the pass 2, 3, and 3A code are justified as
> follows: When e2fsck encounters a block of directory entries and
> cannot find the placeholder entry at the end that contains the
> checksum, it will try to insert the placeholder.  If that fails, it
> will schedule the directory for a pass 3A reconstruction.  Until that
> happens, we don't want directory block writing (pass 2), block
> iteration (pass 3), or block reading (pass 3A) to fail due to checksum
> errors, because failing to find the placeholder is itself a checksum
> verification error, which causes e2fsck to abort without fixing
> anything.
> 
> The e2fsck call to ext2fs_read_bitmaps must never fail due to a
> checksum error because e2fsck subsequently (a) verifies the bitmaps
> itself; or (b) decides that they don't match what has been observed,
> and rewrites them.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
