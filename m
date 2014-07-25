From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 20/24] e2fsck: pass2 should not process directory blocks
 that are impossibly large
Date: Fri, 25 Jul 2014 08:42:03 -0400
Message-ID: <20140725124203.GK1865@thunk.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225446.31374.67903.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56302 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbaGYMmG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2014 08:42:06 -0400
Content-Disposition: inline
In-Reply-To: <20140718225446.31374.67903.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2014 at 03:54:46PM -0700, Darrick J. Wong wrote:
> Currently, directories cannot be fallocated, which means that the only
> way they get bigger is for the kernel to append blocks one by one.
> Therefore, if we encounter a logical block offset that is too big, we
> needn't bother adding it to the dblist for pass2 processing, because
> it's unlikely to contain a valid directory block.  The code that
> handles extent based directories also does not add toobig blocks to
> the dblist.
> 
> Note that we can easily cause e2fsck to fail with ENOMEM if we start
> feeding it really large logical block offsets, as the dblist
> implementation will try to realloc() an array big enough to hold it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
