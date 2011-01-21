From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 3/3] block: reimplement FLUSH/FUA to support merge
Date: Fri, 21 Jan 2011 14:19:20 -0500
Message-ID: <20110121191920.GJ12072@redhat.com>
References: <1295625598-15203-1-git-send-email-tj@kernel.org>
 <1295625598-15203-4-git-send-email-tj@kernel.org>
 <20110121185617.GI12072@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, tytso@mit.edu, djwong@us.ibm.com, shli@kernel.org,
	neilb@suse.de, adilger.kernel@dilger.ca, jack@suse.cz,
	snitzer@redhat.com, linux-kernel@vger.kernel.org,
	kmannth@us.ibm.com, cmm@us.ibm.com, linux-ext4@vger.kernel.org,
	rwheeler@redhat.com, hch@lst.de, josef@redhat.com
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386Ab1AUTUE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jan 2011 14:20:04 -0500
Content-Disposition: inline
In-Reply-To: <20110121185617.GI12072@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 21, 2011 at 01:56:17PM -0500, Vivek Goyal wrote:
> On Fri, Jan 21, 2011 at 04:59:58PM +0100, Tejun Heo wrote:
> 
> [..]
> > + * The actual execution of flush is double buffered.  Whenever a request
> > + * needs to execute PRE or POSTFLUSH, it queues at
> > + * q->flush_queue[q->flush_pending_idx].  Once certain criteria are met, a
> > + * flush is issued and the pending_idx is toggled.  When the flush
> > + * completes, all the requests which were pending are proceeded to the next
> > + * step.  This allows arbitrary merging of different types of FLUSH/FUA
> > + * requests.
> > + *
> > + * Currently, the following conditions are used to determine when to issue
> > + * flush.
> > + *
> > + * C1. At any given time, only one flush shall be in progress.  This makes
> > + *     double buffering sufficient.
> > + *
> > + * C2. Flush is not deferred if any request is executing DATA of its
> > + *     sequence.  This avoids issuing separate POSTFLUSHes for requests
> > + *     which shared PREFLUSH.
> 
> Tejun, did you mean "Flush is deferred" instead of "Flush is not deferred"
> above?
> 
> IIUC, C2 might help only if requests which contain data are also going to 
> issue postflush. Couple of cases come to mind.
> 
> - If queue supports FUA, I think we will not issue POSTFLUSH. In that
>   case issuing next PREFLUSH which data is in flight might make sense.
> 
> - Even if queue does not support FUA and we are only getting requests
>   with REQ_FLUSH then also waiting for data requests to finish before
>   issuing next FLUSH might not help.
> 
> - Even if queue does not support FUA and say we have a mix of REQ_FUA
>   and REQ_FLUSH, then this will help only if in a batch we have more
>   than 1 request which is going to issue POSTFLUSH and those postflush
>   will be merged.
> 
> - Ric Wheeler was once mentioning that there are boxes which advertise
>   writeback cache but are battery backed so they ignore flush internally and
>   signal completion immediately. I am not sure how prevalent those
>   cases are but I think waiting for data to finish will delay processing
>   of new REQ_FLUSH requests in pending queue for such array. There
>   we will not anyway benefit from merging of FLUSH.
> 
> Given that C2 is going to benefit primarily only if queue does not support
> FUA and we have many requets with REQ_FUA set, will it make sense to 
> put additional checks for C2. Atleast a simple queue support FUA
> check might help.

Reading through the blk_insert_flush() bit more, looks like pure REQ_FUA
requests will not even show up in data list if queue supports FUA. But
IIUC requests with both REQ_FLUSH and REQ_FUA set will still show up even if
queue supports FUA.

Thanks
Vivek
