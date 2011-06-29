From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [RFC PATCH 0/3] block: Fix fsync slowness with CFQ cgroups
Date: Wed, 29 Jun 2011 09:04:55 +0800
Message-ID: <1309309495.15392.213.camel@sli10-conroe>
References: <1309205864-13124-1-git-send-email-vgoyal@redhat.com>
	 <1309223932.15392.186.camel@sli10-conroe>
	 <20110628014039.GA15850@redhat.com>
	 <1309226634.15392.197.camel@sli10-conroe>
	 <20110628130457.GA17552@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"jaxboe@fusionio.com" <jaxboe@fusionio.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"khlebnikov@openvz.org" <khlebnikov@openvz.org>,
	"jmoyer@redhat.com" <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2032 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab1F2BE5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Jun 2011 21:04:57 -0400
In-Reply-To: <20110628130457.GA17552@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2011-06-28 at 21:04 +0800, Vivek Goyal wrote:
> On Tue, Jun 28, 2011 at 10:03:54AM +0800, Shaohua Li wrote:
> 
> [..]
> > > > > Any feedback on how to solve this issue is appreciated.
> > > > Hi Vivek,
> > > > can we introduce a group think time check in cfq? say in a group the
> > > > last queue is backed for the group and the queue is a non-idle queue, if
> > > > the group think time is big, we don't allow the group idle and preempt
> > > > could happen. The fsync thread is a non-idle queue with Corrado's patch,
> > > > this allows fast group switch.
> > > 
> > > In this case regular queue idle is hitting and not group idle. So some
> > > kind of think time stats probably might be useful for group idle check
> > > but not necessarily for queue idle.
> > I thought your problem is group idle issue. fsync uses WRITE_SYNC, which
> > will make the queue be sync-non-idle because REQ_NOIDLE is set. This is
> > exactly what Corrado's patch for. a fsync queue itself isn't idle unless
> > it's the last queue in a group. Am I missing anything?
> 
> We idle on last queue on sync-noidle tree. So we idle on fysnc queue as
> it is last queue on sync-noidle tree. That's how we provide protection
> to all sync-noidle queues against sync-idle queues. Instead of idling
> on individual quues we do idling in group and that is on service tree.
Ok. but this looks silly. We are idling in a noidle service tree or a
group (backed by the last queue of the tree or group) because we assume
the tree or group can dispatch a request soon. But if the think time of
the tree or group is big, the assumption isn't true. Doing idle here is
blind. I thought we can extend the think time check for both service
tree and group.

Thanks,
Shaohua

