From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [patch,rfc v2] ext3/4: enhance fsync performance when using cfq
Date: Thu, 8 Apr 2010 10:10:04 -0400
Message-ID: <20100408141004.GC10879@redhat.com>
References: <x49ochv7yi3.fsf@segfault.boston.devel.redhat.com> <20100408110045.GJ10103@kernel.dk> <20100408135901.GA10879@redhat.com> <x49pr2a9h3n.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <jens.axboe@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758639Ab0DHOK1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Apr 2010 10:10:27 -0400
Content-Disposition: inline
In-Reply-To: <x49pr2a9h3n.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 08, 2010 at 10:03:24AM -0400, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Thu, Apr 08, 2010 at 01:00:45PM +0200, Jens Axboe wrote:
> 
> >> I like the concept, it's definitely useful (and your results amply
> >> demonstrate that). I was thinking if there was a way in through the ioc
> >> itself, rather than bdi -> queue and like you are doing. But I can't
> >> think of a nice way to do it, so this is probably as good as it gets.
> >> 
> >
> > I think, one issue with ioc based approach will be that it will then call
> > yield operation on all the devices in the system where this context has ever
> > done any IO. With bdi based approach this call will remain limited to
> > a smaller set of devices.
> 
> Which actually brings up the question of whether this needs some
> knowledge of whether the journal is on the same device as the file
> system!  In such a case, we need not yield.  I think I'll stick my head
> in the sand for this one.  ;-)

Jeff even if journal is not on same device, what harm yielding could do?
Anyway there is no IO on that queue and we are idling. Only side affect is
that yielding process could lose a bit if after fsync it immediately submits
more IO. Because this process has yielded it slice, it is back in the queue
instead of doing more IO in the current slice immediately.

Vivek
