From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 08/14] libext2fs: find/alloc a range of empty blocks
Date: Sat, 16 May 2015 21:02:31 -0400
Message-ID: <20150517010231.GG4489@thunk.org>
References: <20150514002108.10785.85860.stgit@birch.djwong.org>
 <20150514002159.10785.73282.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40780 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbbEQBCc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 May 2015 21:02:32 -0400
Content-Disposition: inline
In-Reply-To: <20150514002159.10785.73282.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 13, 2015 at 05:22:00PM -0700, Darrick J. Wong wrote:
> Provide a function that, given a goal pblk and a range, will try to
> find a run of free blocks to satisfy the allocation.  By default the
> function will look anywhere in the filesystem for the run, though this
> can be constrained with optional flags.  One flag indicates that the
> range must start at the goal block; the other flag indicates that we
> should not return a range shorter than len.
> 
> v2: Add a second function to allocate a range of blocks.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
