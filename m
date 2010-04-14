From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 1/4] cfq-iosched: Keep track of average think time for the sync-noidle workload.
Date: Wed, 14 Apr 2010 19:06:38 -0400
Message-ID: <x49zl15k51d.fsf@segfault.boston.devel.redhat.com>
References: <1271279826-30294-1-git-send-email-jmoyer@redhat.com>
	<1271279826-30294-2-git-send-email-jmoyer@redhat.com>
	<20100414213745.GC3167@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756198Ab0DNXGo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Apr 2010 19:06:44 -0400
In-Reply-To: <20100414213745.GC3167@redhat.com> (Vivek Goyal's message of
	"Wed, 14 Apr 2010 17:37:45 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Vivek Goyal <vgoyal@redhat.com> writes:

> On Wed, Apr 14, 2010 at 05:17:03PM -0400, Jeff Moyer wrote:

>> @@ -3678,11 +3710,14 @@ static void *cfq_init_queue(struct request_queue *q)
>>  
>>  	/* Init root service tree */
>>  	cfqd->grp_service_tree = CFQ_RB_ROOT;
>> +	cfqd->grp_service_tree.last_end_request = jiffies;
>>  
>
> This assignment is not required as we never update think time analsys of
> service tree where all the groups are hanging.  So for grp_service_tree,
> last_end_request can be zero and there will be no harm.

OK, thanks.

> Otherwise patch looks good to me. Can you please run some simple blkio
> cgroup tests to make sure that functionality is not broken.

Yes, I'll add that to my list and get back to you.

Thanks for the review, Vivek.

Cheers,
Jeff
