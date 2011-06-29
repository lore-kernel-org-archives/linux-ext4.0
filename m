From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH 0/3] block: Fix fsync slowness with CFQ cgroups
Date: Tue, 28 Jun 2011 21:29:55 -0400
Message-ID: <20110629012955.GA19041@redhat.com>
References: <1309205864-13124-1-git-send-email-vgoyal@redhat.com>
 <1309223932.15392.186.camel@sli10-conroe>
 <20110628014039.GA15850@redhat.com>
 <1309226634.15392.197.camel@sli10-conroe>
 <20110628130457.GA17552@redhat.com>
 <1309309495.15392.213.camel@sli10-conroe>
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
Received: from mx1.redhat.com ([209.132.183.28]:54992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab1F2B36 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Jun 2011 21:29:58 -0400
Content-Disposition: inline
In-Reply-To: <1309309495.15392.213.camel@sli10-conroe>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 29, 2011 at 09:04:55AM +0800, Shaohua Li wrote:

[..]
> > We idle on last queue on sync-noidle tree. So we idle on fysnc queue as
> > it is last queue on sync-noidle tree. That's how we provide protection
> > to all sync-noidle queues against sync-idle queues. Instead of idling
> > on individual quues we do idling in group and that is on service tree.
> Ok. but this looks silly. We are idling in a noidle service tree or a
> group (backed by the last queue of the tree or group) because we assume
> the tree or group can dispatch a request soon. But if the think time of
> the tree or group is big, the assumption isn't true. Doing idle here is
> blind. I thought we can extend the think time check for both service
> tree and group.

We can implement the thinktime for noidle service tree and group idle as
well. That's not a problem, though I am yet to be convinced that thinktime
still makes sense for the group. I guess it will just mean that in the
past have you done a bunch of IO with gap between IO less than 8ms. If
yes, then we expect you to do more IO in future. Frankly speaking, I am
not too sure that how past IO pattern predicts the future IO pattern
of the group.

But anyway, the point is, even if you we implement it, it will not solve
the fsync issue at hand. The reason I explained in previous mail. We 
will be oscillating between high think time and low thinktime depending
on whether we are idling or not. There is no correlation between think
time of fsync thread and idling here.

I think you are banking on the fact that after fsync, journaling thread
IO can take more than 8ms hence delaying next IO to fsync thread, pushing
its thinktim more than 8ms hence we will not idle on fsync thread at
all. It is just one corner case and I think it is broken in multiple
cases.

- If filesystem barriers are disabled or backend storage has battery
  backup then journal IO most likely will go in cache and barriers
  will be ignored. In that case write will finish almost instantly
  and we will get next IO from fsync thread very soon hence pushing
  down thinktime of fsync thread which will enable idling and we will
  be back to the problem we are trying to solve.

- Fsync thread might be submitting string of IOs (say 10-12) before it
  moves to journal thread to commit meta data. In that case we might
  have lowered thinktime of fsync hence enable idle. 

So implementing think time for service tree/group might be a good idea
in general but it will not solve this IO dependecny issue across cgroups.

Thanks
Vivek
