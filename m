From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 25/37] libext2fs: when appending to a file, don't split
 an index block in equal halves
Date: Sat, 2 Aug 2014 19:43:48 -0400
Message-ID: <20140802234348.GC29146@thunk.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
 <20140501231505.31890.96782.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41819 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbaHBXqA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Aug 2014 19:46:00 -0400
Content-Disposition: inline
In-Reply-To: <20140501231505.31890.96782.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 01, 2014 at 04:15:05PM -0700, Darrick J. Wong wrote:
> When we're appending an extent to the end of a file and the index
> block is full, don't split the index block into two half-full index
> blocks because this leaves us with under utilized index blocks, at
> least in the fallocate case.  Instead, copy the last extent from the
> full block into the new block.  This isn't perfect utilization, but
> there's a lot of work involved in teaching extent.c to be able to goto
> a nonexistent node in a newly allocated (and empty) extent block.
> 
> This patch does not fix the general problem of keeping the extent tree
> balanced.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
