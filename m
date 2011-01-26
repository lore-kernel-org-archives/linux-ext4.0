From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH 4/3] block: skip elevator initialization for flush
 requests -- was never BUGGY relative to upstream
Date: Wed, 26 Jan 2011 00:27:19 -0500
Message-ID: <20110126052719.GA31818@redhat.com>
References: <1295625598-15203-1-git-send-email-tj@kernel.org>
 <1295625598-15203-4-git-send-email-tj@kernel.org>
 <20110125204158.GA3013@redhat.com>
 <20110125215500.GA6836@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, tytso@mit.edu, djwong@us.ibm.com, shli@kernel.org,
	neilb@suse.de, adilger.kernel@dilger.ca, jack@suse.cz,
	linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
	josef@redhat.com, jmoyer@redhat.com
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742Ab1AZF1j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Jan 2011 00:27:39 -0500
Content-Disposition: inline
In-Reply-To: <20110125215500.GA6836@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 25 2011 at  4:55pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Jan 25 2011 at  3:41pm -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > Hi Tejun,
> > 
> > On Fri, Jan 21 2011 at 10:59am -0500,
> > Tejun Heo <tj@kernel.org> wrote:
> > > 
> > > * As flush requests are never put on the IO scheduler, request fields
> > >   used for flush share space with rq->rb_node.  rq->completion_data is
> > >   moved out of the union.  This increases the request size by one
> > >   pointer.
> > > 
> > >   As rq->elevator_private* are used only by the iosched too, it is
> > >   possible to reduce the request size further.  However, to do that,
> > >   we need to modify request allocation path such that iosched data is
> > >   not allocated for flush requests.
> > 
> > I decided to take a crack at using rq->elevator_private* and came up
> > with the following patch.

...

> It is an interesting duality that:
> 1) REQ_ELVPRIV is never set because priv=0 is passed to blk_alloc_request
> 2) yet when blk_free_request() checks rq->cmd_flags REQ_ELVPRIV is set;
>    resulting in the call to elv_put_request()

Turns out priv=0 was never actually being established in get_request()
on the kernel I was testing (see below).

> > I know this because in my following get_request() change to _not_ call
> > elv_set_request() for flush requests hit cfq_put_request()'s
> > BUG_ON(!cfqq->allocated[rw]).
> 
> FYI, here is the backtrace:

That backtrace was from a RHEL6 port of your recent flush merge work.
One RHELism associated with the RHEL6 flush+fua port in general (and now
this flush merge port) is that bio and request flags are _not_ shared.

As such I introduced BIO_FLUSH and BIO_FUA flags in RHEL6.  Long story
short, my 4/3 patch works just fine ontop of your 3 patches that Jens
just staged for 2.6.39.

So sorry for the noise!  I'm kicking myself for having tainted my patch
(and your work indirectly) by making an issue out of nothing.

Taking a step back, what do you think of my proposed patch?

Mike
