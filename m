From: Theodore Tso <tytso@mit.edu>
Subject: Re: Problem with delayed allocation
Date: Mon, 4 Aug 2008 10:08:54 -0400
Message-ID: <20080804140854.GE8592@mit.edu>
References: <E1KPNNn-0003IN-0B@closure.thunk.org> <20080804031652.GA11278@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:47123 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753325AbYHDOI5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2008 10:08:57 -0400
Content-Disposition: inline
In-Reply-To: <20080804031652.GA11278@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 04, 2008 at 08:46:52AM +0530, Aneesh Kumar K.V wrote:
> __fsync_super use filemap_fdatawait(mapping) for waiting on writeback
> pages. But all the dirty pages of the inode are not in writeback because
> we might have had block allocation failures.

Yes, but that should only happen if the filesystem is full or a user's
quota is overrun, correct?

> Also with the current code base I am seeing buffer_heads which are
> unmapped, non delay and dirty That means writepages won't allocate
> block for them and writepage cannot write them.

I thought all writes went through the page cache?  Are you saying that
the *pages* are clean but the buffer_heads are marked dirty?  In that
case, ext4_da_writepages, if wbc.sync_mode is not WB_SYNC_NONE, *must*
wait on them and not return until the buffers are safely on disk,
since filemap_fdatawait(mapping) won't in __sync_single_inode() won't
do the waiting for the writepages routine.

							- Ted
