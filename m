From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/6] libext2fs/e2fsck: provide routines to read-ahead
 metadata
Date: Sun, 10 Aug 2014 23:31:20 -0700
Message-ID: <20140811063120.GB2808@birch.djwong.org>
References: <20140809042610.2441.6868.stgit@birch.djwong.org>
 <20140809042643.2441.79312.stgit@birch.djwong.org>
 <20140811052151.GA2808@birch.djwong.org>
 <20140811062415.GG15431@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22301 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaHKGb1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Aug 2014 02:31:27 -0400
Content-Disposition: inline
In-Reply-To: <20140811062415.GG15431@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 11, 2014 at 02:24:15AM -0400, Theodore Ts'o wrote:
> On Sun, Aug 10, 2014 at 10:21:51PM -0700, Darrick J. Wong wrote:
> > 
> > It turns out that each of the calls to ext2fs_resize_mem in the
> > ext2fs_add_dir_block2() function is costing us ~2ms for each call to this
> > function.  I'll add a new ext2fs_init_dblist() APi that lets us specify the
> > initial size of the list.  This seems to reduce the fsck runtime by a few more
> > seconds.
> 
> I suspect dblist is the wrong abstraction to use here.  Since the
> blocks we want to read ahead are generally going to be contiguous, why
> not use a rbtree bitmap, setting the blocks that should be subject to
> readahead, and then use the find_first_set() function to iterate over
> the bitmap?  Or if you want to be even more efficient, create an
> interator function which takes a bitmap and returns blocks that are
> set in the bitmap, one by one.

Hmm, I'll try that, though I'm almost tempted just to issue io_cache_readahead
calls directly from the for loop.  The only reason I'm using the list here at
all is to handle the case of reading multiple groups in a flexbg (pass5 RA).

--D
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
