From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/6] libext2fs/e2fsck: provide routines to read-ahead
 metadata
Date: Mon, 11 Aug 2014 02:24:15 -0400
Message-ID: <20140811062415.GG15431@thunk.org>
References: <20140809042610.2441.6868.stgit@birch.djwong.org>
 <20140809042643.2441.79312.stgit@birch.djwong.org>
 <20140811052151.GA2808@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53855 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbaHKGYS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Aug 2014 02:24:18 -0400
Content-Disposition: inline
In-Reply-To: <20140811052151.GA2808@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 10, 2014 at 10:21:51PM -0700, Darrick J. Wong wrote:
> 
> It turns out that each of the calls to ext2fs_resize_mem in the
> ext2fs_add_dir_block2() function is costing us ~2ms for each call to this
> function.  I'll add a new ext2fs_init_dblist() APi that lets us specify the
> initial size of the list.  This seems to reduce the fsck runtime by a few more
> seconds.

I suspect dblist is the wrong abstraction to use here.  Since the
blocks we want to read ahead are generally going to be contiguous, why
not use a rbtree bitmap, setting the blocks that should be subject to
readahead, and then use the find_first_set() function to iterate over
the bitmap?  Or if you want to be even more efficient, create an
interator function which takes a bitmap and returns blocks that are
set in the bitmap, one by one.

						- Ted
