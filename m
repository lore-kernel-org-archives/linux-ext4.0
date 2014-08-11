From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/6] libext2fs/e2fsck: provide routines to read-ahead
 metadata
Date: Mon, 11 Aug 2014 10:34:23 -0400
Message-ID: <20140811143423.GB3506@thunk.org>
References: <20140809042610.2441.6868.stgit@birch.djwong.org>
 <20140809042643.2441.79312.stgit@birch.djwong.org>
 <20140811052151.GA2808@birch.djwong.org>
 <20140811062415.GG15431@thunk.org>
 <20140811063120.GB2808@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54502 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914AbaHKOeZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Aug 2014 10:34:25 -0400
Content-Disposition: inline
In-Reply-To: <20140811063120.GB2808@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 10, 2014 at 11:31:20PM -0700, Darrick J. Wong wrote:
> 
> Hmm, I'll try that, though I'm almost tempted just to issue io_cache_readahead
> calls directly from the for loop.  The only reason I'm using the list here at
> all is to handle the case of reading multiple groups in a flexbg (pass5 RA).

In that case you could just use an accumulator for each of the block
and inode bitmaps, and so long as the next group's block and inode
bitmaps are contiguous with the previous one, you can bump a counter.
Once you reach a discontiguous bitmap block, you can issue a single
readahead request for N blocks starting at block B.  That way you only
issue a single syscall, instead of one for every single block, and you
don't have the overhead involved with storing the list of blocks and
then sorting them.

					- Ted
