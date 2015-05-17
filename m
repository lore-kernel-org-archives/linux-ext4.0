From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 07/14] libext2fs: support allocating uninit blocks in
 bmap2()
Date: Sat, 16 May 2015 20:54:41 -0400
Message-ID: <20150517005441.GF4489@thunk.org>
References: <20150514002108.10785.85860.stgit@birch.djwong.org>
 <20150514002153.10785.94335.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40772 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbbEQAym (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 May 2015 20:54:42 -0400
Content-Disposition: inline
In-Reply-To: <20150514002153.10785.94335.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 13, 2015 at 05:21:53PM -0700, Darrick J. Wong wrote:
> As part of supporting fallocate-like functionality, extend
> ext2fs_bmap() with two flags -- BMAP_UNINIT and BMAP_ZERO.  The first
> will cause it to mark/set a block uninitialized, if it's part of an
> extent based file.  For a block mapped file, the mapping is put in,
> but there is no way to remember the uninitialized status.  The second
> flag causes the block to be zeroed to support the use case of
> emulating uninitialized blocks on a block-map file by zeroing them.
> 
> Eventually fallocate or fuse2fs or somebody will use these.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
