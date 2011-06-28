From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH 0/3] block: Fix fsync slowness with CFQ cgroups
Date: Tue, 28 Jun 2011 09:04:57 -0400
Message-ID: <20110628130457.GA17552@redhat.com>
References: <1309205864-13124-1-git-send-email-vgoyal@redhat.com>
 <1309223932.15392.186.camel@sli10-conroe>
 <20110628014039.GA15850@redhat.com>
 <1309226634.15392.197.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"jaxboe@fusionio.com" <jaxboe@fusionio.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"khlebnikov@openvz.org" <khlebnikov@openvz.org>,
	"jmoyer@redhat.com" <jmoyer@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757630Ab1F1NFB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Jun 2011 09:05:01 -0400
Content-Disposition: inline
In-Reply-To: <1309226634.15392.197.camel@sli10-conroe>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 28, 2011 at 10:03:54AM +0800, Shaohua Li wrote:

[..]
> > > > Any feedback on how to solve this issue is appreciated.
> > > Hi Vivek,
> > > can we introduce a group think time check in cfq? say in a group the
> > > last queue is backed for the group and the queue is a non-idle queue, if
> > > the group think time is big, we don't allow the group idle and preempt
> > > could happen. The fsync thread is a non-idle queue with Corrado's patch,
> > > this allows fast group switch.
> > 
> > In this case regular queue idle is hitting and not group idle. So some
> > kind of think time stats probably might be useful for group idle check
> > but not necessarily for queue idle.
> I thought your problem is group idle issue. fsync uses WRITE_SYNC, which
> will make the queue be sync-non-idle because REQ_NOIDLE is set. This is
> exactly what Corrado's patch for. a fsync queue itself isn't idle unless
> it's the last queue in a group. Am I missing anything?

We idle on last queue on sync-noidle tree. So we idle on fysnc queue as
it is last queue on sync-noidle tree. That's how we provide protection
to all sync-noidle queues against sync-idle queues. Instead of idling
on individual quues we do idling in group and that is on service tree.

> 
> > Secondly, for this case think time will change. If you stop idling on
> > fsync and jbd threads, both will be dispatching IOs fast and both will
> > have small thinktime. We will think that thinktime is small so we
> > will enable idle. Then there think time will increase as both will
> > get blocked behind each other. And then we will removing idling. So
> > looks like we will be oscillating between enabling and disabling
> > think time.
> That is possible, the think time check (even for queues) always has such
> issue. Not sure how severe the issue is. Assume jbd will dispatch
> several requests and this will make fsync thread think time big.
> 
> > If we don't allow idling on sync-no-idle queues, then basic CFQ will
> > be broken.
> Hmm, CFQ only allows idling on sync queues, sync-no-idle queue isn't
> allowed idling.

See above.

Thanks
Vivek
