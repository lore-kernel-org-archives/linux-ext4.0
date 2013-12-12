From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 32/74] libext2fs: fix punching extents when there are no
 left extents
Date: Thu, 12 Dec 2013 13:25:13 -0500
Message-ID: <20131212182513.GC13547@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012154.30655.52115.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39453 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab3LLSZQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 13:25:16 -0500
Content-Disposition: inline
In-Reply-To: <20131211012154.30655.52115.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:21:54PM -0800, Darrick J. Wong wrote:
> When deleting an entire extent, we cannot always slip to the previous
> leaf extent because there might not /be/ a previous extent.
> Attempting to correct for that error by asking for the 'current' leaf
> extent also doesn't work, because the failed attempt to change to the
> previous extent leaves us with no current extent.
> 
> Fix this problem by recording the lblk of the next extent before
> deleting the current extent and _goto()ing to the next extent after
> the deletion.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
