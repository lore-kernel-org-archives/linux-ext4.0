From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/6 v6][RFC] jbd[2]: enhance fsync performance when using
 CFQ
Date: Fri, 2 Jul 2010 16:23:42 -0400
Message-ID: <20100702202342.GH7001@redhat.com>
References: <1278100699-24132-1-git-send-email-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, axboe@kernel.dk,
	linux-kernel@vger.kernel.org, tao.ma@oracle.com
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757613Ab0GBUXs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Jul 2010 16:23:48 -0400
Content-Disposition: inline
In-Reply-To: <1278100699-24132-1-git-send-email-jmoyer@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 02, 2010 at 03:58:13PM -0400, Jeff Moyer wrote:

[..]
> Changes from the last posting:
> - Yielding no longer expires the current queue.  Instead, it sets up new
>   requests from the target process so that they are issued in the yielding
>   process' cfqq.  This means that we don't need to worry about losing group
>   or workload share.
> - Journal commits are now synchronous I/Os, which was required to get any
>   sort of performance out of the fs_mark process in the presence of a
>   competing reader.
> - WRITE_SYNC I/O no longer sets RQ_NOIDLE, for a similar reason.

Hi Jeff,

So this patchset relies on idling on WRITE_SYNC queues. Though in general
we don't have examples that why one should idle on processes doing WRITE_SYNC
IO because previous IO does not tell anything about the upcoming IO. I am
bringing up this point again to make sure that fundamentally we agree that
continue to idle on WRITE_SYNC is the right thing to do otherwise this patch
will fall apart.

I have yet to go through the patch in detail but allowing other queue to
dispatch requests in the same queue sounds like queue merging. So can
we use that semantics to say elv_merge_context() or elv_merge_queue()
instead of elv_yield(). In the code we can just merge the two queues when
the next request comes in and separate them out at the slice expiry I 
guess.

Thanks
Vivek

> - I did test OCFS2, and it does experience performance improvements, though
>   I forgot to record those.
> 
> Previous postings can be found here:
>   http://lkml.org/lkml/2010/4/1/344
>   http://lkml.org/lkml/2010/4/7/325
>   http://lkml.org/lkml/2010/4/14/394
>   http://lkml.org/lkml/2010/5/18/365
>   http://lkml.org/lkml/2010/6/22/338
> 
> [1] http://lkml.org/lkml/2010/6/21/307
> 
> [PATCH 1/6] block: Implement a blk_yield function to voluntarily give up the I/O scheduler.
> [PATCH 2/6] jbd: yield the device queue when waiting for commits
> [PATCH 3/6] jbd2: yield the device queue when waiting for journal commits
> [PATCH 4/6] jbd: use WRITE_SYNC for journal I/O
> [PATCH 5/6] jbd2: use WRITE_SYNC for journal I/O
> [PATCH 6/6] block: remove RQ_NOIDLE from WRITE_SYNC
