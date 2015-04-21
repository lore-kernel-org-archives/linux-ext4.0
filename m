From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/35] libext2fs/e2fsck: provide routines to read-ahead
 metadata
Date: Mon, 20 Apr 2015 23:03:40 -0400
Message-ID: <20150421030340.GD3238@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023419.25243.1245.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49221 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbbDUDDt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2015 23:03:49 -0400
Content-Disposition: inline
In-Reply-To: <20150402023419.25243.1245.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2015 at 07:34:19PM -0700, Darrick J. Wong wrote:
> This patch adds to e2fsck the ability to pre-fetch metadata into the
> page cache in the hopes of speeding up fsck runs.  There are two new
> functions -- the first allows a caller to readahead a list of blocks,
> and the second is a helper function that uses that first mechanism to
> load group data (bitmaps, inode tables).
> 
> These new e2fsck routines require the addition of a dblist API to
> allow us to iterate a subset of a dblist.  This will enable
> incremental directory block readahead in e2fsck pass 2.
> 
> There's also a function to estimate the readahead given a FS.
> 
> v2: Add an API to create a dblist with a given number of list elements
> pre-allocated.  This enables us to save ~2ms per call to
> e2fsck_readahead() (assuming a 2MB RA buffer) by not having to
> repeatedly call ext2_resize_mem as we add blocks to the list.
> 
> v3: Instead of creating dblists of arbitrary size, change the dblist
> iterator to allow iterating a sub-range.  This eliminates a lot of
> unnecessary list copying during e2fsck part2.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
