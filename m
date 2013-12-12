From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 33/74] libext2fs: don't error out when punching a totally
 sparse file
Date: Thu, 12 Dec 2013 13:26:00 -0500
Message-ID: <20131212182600.GD13547@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012200.30655.65221.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39456 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab3LLS0C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 13:26:02 -0500
Content-Disposition: inline
In-Reply-To: <20131211012200.30655.65221.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:22:00PM -0800, Darrick J. Wong wrote:
> If we're asked to punch a file with no data blocks mapped to it and a
> non-zero length, we don't need to do any work in ext2fs_punch_extent()
> and can return success.  Unfortunately, the extent_get() function
> returns "no current node" because it (correctly) failed to find any
> extents, which is bubbled up to callers.  Since no extents being found
> is not an error in this corner case, fix up ext2fs_punch_extent() to
> return 0 to callers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
