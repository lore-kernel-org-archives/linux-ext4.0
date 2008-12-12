From: Theodore Tso <tytso@mit.edu>
Subject: Re: [BUG][PATCH 1/4] ext3: fix a cause of __schedule_bug via
	blkdev_releasepage
Date: Fri, 12 Dec 2008 01:21:48 -0500
Message-ID: <20081212062148.GJ10890@mit.edu>
References: <20081202200647.72cc5807.toshi.okajima@jp.fujitsu.com> <20081208140138.GA17700@mit.edu> <4941B63A.3090302@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: aneesh.kumar@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
	linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:42310 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751230AbYLLGVy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Dec 2008 01:21:54 -0500
Content-Disposition: inline
In-Reply-To: <4941B63A.3090302@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 12, 2008 at 09:54:18AM +0900, Toshiyuki Okajima wrote:
> To tell the truth, at first, I imagined the same patch as yours to fix this
> problem. But I have made another patch because I thought that ext3(or ext4)
> should not know the contents of the processing of journal_try_to_free_buffers
>  in detail. (ext3 should not know there is a possibility to call
> journal_wait_for_transaction_sync_data from journal_try_to_free_buffers.)

I agree, but ext3 doesn't need to know that.  What my change did was
to mask off the _GFP_WAIT flag, which prohibits the function it calls
from blocking, because it knows that its caller is holding a spinlock.

And actually, come to think of it.  We can do even better; the right
fix is to have blkdev_releasepage() mask off the _GFP_WAIT flag; this
is the function which is taking spinlock, and by masking off the
__GFP_WAIT flag, this is simply requesting all of the downstream
functions not to block, but to do the best job they can do without
blocking.  It doesn't need to know whether it's going to call
log_wait_commit(), or anything else; all it needs to do is request
"please don't block".

That means we only make the request once, in the function which is
taking spinlock, so all of the per-filesystem implementations of
release_metadata() don't need to know that its caller is holding a
spinlock. 

							- Ted

