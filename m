From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/35] e2fsck: rebuild sparse extent trees/convert
 non-extent ext3 files
Date: Tue, 21 Apr 2015 12:33:00 -0400
Message-ID: <20150421163300.GA14091@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023440.25243.95250.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50643 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933107AbbDUQdE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Apr 2015 12:33:04 -0400
Content-Disposition: inline
In-Reply-To: <20150402023440.25243.95250.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2015 at 07:34:40PM -0700, Darrick J. Wong wrote:
> Teach e2fsck to (re)construct extent trees.  This enables us to do
> either of the following: compress a highly sparse extent tree into
> fewer ETB blocks; or convert a ext3-style block mapped file to an
> extent file.  The reconstruction is performed during pass 1E or 3A,
> as detailed below.
> 
> For files that are already extent based, this algorithm will
> automatically run (pending user approval) if pass1 determines either
> (1) that a whole level of extent tree will fit into a higher level of
> the tree; (2) that the size of any level can be reduced by at least
> one ETB block; or (3) the extent tree is unnecessarily deep.  It will
> not run at all if errors are found and the user declines to fix the
> errors.
> 
> The option "-E bmap2extent" can be used to force e2fsck to convert all
> block map files to extent trees, and to rebuild all extent files'
> extent trees.  After conversion, files larger than 12 blocks should be
> defragmented to eliminate empty holes where a block lives.
> 
> The extent tree constructor is pretty dumb -- it creates a list of
> leaf extents (adjacent extents are collapsed), marks all indirect
> blocks / ETB blocks free, installs a new extent tree root in the
> inode, then loads the leaf extents into the tree.
> 
> v2: Account for extent tree block slack that we create when splitting
> a block, so that we don't repeatedly annoy the user to rebuild a tree
> that we can't optimize further.
> 
> v3: For any directory being rebuilt during pass 3A, defer any extent
> tree rebuilding until after the rehash.  It's quite possible that the
> act of compressing an aged directory will cause it to shrink far
> enough to enable us to knock a level off the dir's extent tree.
> 
> v4: Add a fixes_only option (and a E2FSCK_FIXES_ONLY environment
> variable) that disables optimization activities unless they are
> required to make the filesystem consistent.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
