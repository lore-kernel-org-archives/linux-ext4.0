From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/74] libext2fs: don't overflow when punching indirect
 blocks with large blocks
Date: Thu, 12 Dec 2013 12:06:46 -0500
Message-ID: <20131212170646.GA13547@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211011821.30655.67004.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39348 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab3LLRGv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 12:06:51 -0500
Content-Disposition: inline
In-Reply-To: <20131211011821.30655.67004.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:18:21PM -0800, Darrick J. Wong wrote:
> On a FS with a rather large blockize (> 4K), the old block map
> structure can construct a fat enough "tree" (or whatever we call that
> lopsided thing) that (at least in theory) one could create mappings
> for logical blocks higher than 32 bits.  In practice this doesn't
> happen, but the 'max' and 'iter' variables that the punch helpers use
> will overflow because the BLOCK_SIZE_BITS shifts are too large to fit
> a 32-bit variable.  The current variable declarations also cause punch
> to fail on TIND-mapped blocks even if the file is < 16T.  So enlarge
> the fields to fit.
> 
> Yes this is an obscure corner case, but it seems a little silly if we
> can't punch a file's block 300,000,000 on a 64k-block filesystem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
