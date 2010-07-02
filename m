From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 0/6 v6][RFC] jbd[2]: enhance fsync performance when using CFQ
Date: Fri, 02 Jul 2010 16:32:31 -0400
Message-ID: <x49iq4xtyjk.fsf@segfault.boston.devel.redhat.com>
References: <1278100699-24132-1-git-send-email-jmoyer@redhat.com>
	<20100702202342.GH7001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, axboe@kernel.dk,
	linux-kernel@vger.kernel.org, tao.ma@oracle.com
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758758Ab0GBUch (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Jul 2010 16:32:37 -0400
In-Reply-To: <20100702202342.GH7001@redhat.com> (Vivek Goyal's message of
	"Fri, 2 Jul 2010 16:23:42 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Vivek Goyal <vgoyal@redhat.com> writes:

> On Fri, Jul 02, 2010 at 03:58:13PM -0400, Jeff Moyer wrote:
>
> [..]
>> Changes from the last posting:
>> - Yielding no longer expires the current queue.  Instead, it sets up new
>>   requests from the target process so that they are issued in the yielding
>>   process' cfqq.  This means that we don't need to worry about losing group
>>   or workload share.
>> - Journal commits are now synchronous I/Os, which was required to get any
>>   sort of performance out of the fs_mark process in the presence of a
>>   competing reader.
>> - WRITE_SYNC I/O no longer sets RQ_NOIDLE, for a similar reason.
>
> Hi Jeff,
>
> So this patchset relies on idling on WRITE_SYNC queues. Though in general
> we don't have examples that why one should idle on processes doing WRITE_SYNC
> IO because previous IO does not tell anything about the upcoming IO. I am
> bringing up this point again to make sure that fundamentally we agree that
> continue to idle on WRITE_SYNC is the right thing to do otherwise this patch
> will fall apart.

I think a mail server would be an example of an application that might
do this.  I'll see if I can get a real world test case (or perhaps some
real world data) and verify that.

I agree that if we choose not to idle on write's, then this approach can
be thrown out the window.

> I have yet to go through the patch in detail but allowing other queue to
> dispatch requests in the same queue sounds like queue merging. So can
> we use that semantics to say elv_merge_context() or elv_merge_queue()
> instead of elv_yield(). In the code we can just merge the two queues when
> the next request comes in and separate them out at the slice expiry I 
> guess.

I considered that approach, but then you run into all of the questions
about losing fairness across workloads and across groups.  I believe the
approach I've taken here is *significantly* simpler than merging and
unmerging would be.

Cheers,
Jeff
