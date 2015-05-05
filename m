From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 11/35] undo-io: be more flexible about setting block size
Date: Tue, 5 May 2015 10:21:28 -0400
Message-ID: <20150505142128.GC12468@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023513.25243.34847.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45871 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993154AbbEEOV3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 May 2015 10:21:29 -0400
Content-Disposition: inline
In-Reply-To: <20150402023513.25243.34847.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2015 at 07:35:13PM -0700, Darrick J. Wong wrote:
> Most of the e2fsprogs utilities set the IO block size multiple times
> (once to 1k to read the superblock, then again to set the real block
> size if we find a real superblock).  Unfortunately, the undo IO
> manager only lets the block size be set once.  For the non-mke2fs
> utilities we'd rather catch the real block size and use that.  mke2fs
> of course wants to use a really large block size since it's probably
> writing a lot of data.
> 
> Therefore, if we haven't written any blocks to the undo file, it's
> perfectly fine to allow block size changes.  For mke2fs, we'll modify
> the IO channel option that lets us set the huge size to lock that
> in place.  This greatly reduces index overhead for undo files for
> e2fsck/tune2fs/resize2fs while continuing the practice of reducing
> it even more for mke2fs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
