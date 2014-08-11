From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/6] libext2fs/e2fsck: provide routines to read-ahead
 metadata
Date: Mon, 11 Aug 2014 11:05:09 -0700
Message-ID: <20140811180509.GE2808@birch.djwong.org>
References: <20140809042610.2441.6868.stgit@birch.djwong.org>
 <20140809042643.2441.79312.stgit@birch.djwong.org>
 <20140811052151.GA2808@birch.djwong.org>
 <20140811062415.GG15431@thunk.org>
 <20140811063120.GB2808@birch.djwong.org>
 <20140811143423.GB3506@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36628 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbaHKSFP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Aug 2014 14:05:15 -0400
Content-Disposition: inline
In-Reply-To: <20140811143423.GB3506@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 11, 2014 at 10:34:23AM -0400, Theodore Ts'o wrote:
> On Sun, Aug 10, 2014 at 11:31:20PM -0700, Darrick J. Wong wrote:
> > 
> > Hmm, I'll try that, though I'm almost tempted just to issue io_cache_readahead
> > calls directly from the for loop.  The only reason I'm using the list here at
> > all is to handle the case of reading multiple groups in a flexbg (pass5 RA).
> 
> In that case you could just use an accumulator for each of the block
> and inode bitmaps, and so long as the next group's block and inode
> bitmaps are contiguous with the previous one, you can bump a counter.
> Once you reach a discontiguous bitmap block, you can issue a single
> readahead request for N blocks starting at block B.  That way you only
> issue a single syscall, instead of one for every single block, and you
> don't have the overhead involved with storing the list of blocks and
> then sorting them.

Using the bitmap turns out to be pretty quick (~130us to start RA for 4 groups
vs. ~70us per group if I issue the RA directly).  Each fadvise call seems to
cost us ~1ms, so I'll keep using the bitmap to minimize the number of fadvise
calls, since it's also a lot less code.

--D

> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
