From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/47] libext2fs: fix endian handling error; reduce
 fragmentation some
Date: Mon, 17 Nov 2014 16:26:55 -0500
Message-ID: <20141117212655.GD9693@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215108.883.87199.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35070 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbaKQV1T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Nov 2014 16:27:19 -0500
Content-Disposition: inline
In-Reply-To: <20141107215108.883.87199.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:51:08PM -0800, Darrick J. Wong wrote:
> If we're going to read the "nr - 1" entry in an indirect block for use
> as a "goal" input to the block allocator, we need to byteswap the
> entry.  While we're at it, if we're allocating blocks for the zeroth
> entry in the indirect block, we might as well use the indirect block
> as the starting point to try to reduce fragmentation.
> 
> (d_fallocate_blkmap will test this...)
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
