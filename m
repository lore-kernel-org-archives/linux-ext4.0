From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/39] libext2fs: don't memcpy identical pointers when
 writing a cache block
Date: Tue, 4 Nov 2014 11:48:52 -0500
Message-ID: <20141104164852.GF30614@thunk.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
 <20141025205655.532.5784.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sami Liedes <sami.liedes@iki.fi>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38325 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbaKDQs5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Nov 2014 11:48:57 -0500
Content-Disposition: inline
In-Reply-To: <20141025205655.532.5784.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 25, 2014 at 01:56:55PM -0700, Darrick J. Wong wrote:
> Sami Liedes found a scenario where we could memcpy incorrectly:
> 
> If a block read fails during an e2fsck run, the UNIX IO manager will
> call the io->read_error routine with a pointer to the internal block
> cache.  The e2fsck read error handler immediately tries to write the
> buffer back out to disk(!), at which point the block write code will
> try to copy the buffer contents back into the block cache.  Normally
> this is fine, but not when the write buffer is the cache itself!
> 
> So, plumb in a trivial check for this condition.  A more thorough
> solution would pass a duplicated buffer to the IO error handlers, but
> I don't know if that happens frequently enough to be worth the extra
> point of failure.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reported-by: Sami Liedes <sami.liedes@iki.fi>

Applied, thanks.

	 				- Ted
