From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch,rfc v2] ext3/4: enhance fsync performance when using cfq
Date: Thu, 8 Apr 2010 16:03:06 +0200
Message-ID: <20100408140306.GO10103@kernel.dk>
References: <x49ochv7yi3.fsf@segfault.boston.devel.redhat.com> <20100408110045.GJ10103@kernel.dk> <20100408135901.GA10879@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57240 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab0DHODI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Apr 2010 10:03:08 -0400
Content-Disposition: inline
In-Reply-To: <20100408135901.GA10879@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 08 2010, Vivek Goyal wrote:
> On Thu, Apr 08, 2010 at 01:00:45PM +0200, Jens Axboe wrote:
> > On Wed, Apr 07 2010, Jeff Moyer wrote:
> > > Hi again,
> > > 
> > > So, here's another stab at fixing this.  This patch is very much an RFC,
> > > so do not pull it into anything bound for Linus.  ;-)  For those new to
> > > this topic, here is the original posting:  http://lkml.org/lkml/2010/4/1/344
> > > 
> > > The basic problem is that, when running iozone on smallish files (up to
> > > 8MB in size) and including fsync in the timings, deadline outperforms
> > > CFQ by a factor of about 5 for 64KB files, and by about 10% for 8MB
> > > files.  From examining the blktrace data, it appears that iozone will
> > > issue an fsync() call, and will have to wait until it's CFQ timeslice
> > > has expired before the journal thread can run to actually commit data to
> > > disk.
> > > 
> > > The approach below puts an explicit call into the filesystem-specific
> > > fsync code to yield the disk so that the jbd[2] process has a chance to
> > > issue I/O.  This bring performance of CFQ in line with deadline.
> > > 
> > > There is one outstanding issue with the patch that Vivek pointed out.
> > > Basically, this could starve out the sync-noidle workload if there is a
> > > lot of fsync-ing going on.  I'll address that in a follow-on patch.  For
> > > now, I wanted to get the idea out there for others to comment on.
> > > 
> > > Thanks a ton to Vivek for spotting the problem with the initial
> > > approach, and for his continued review.
> > 
> > I like the concept, it's definitely useful (and your results amply
> > demonstrate that). I was thinking if there was a way in through the ioc
> > itself, rather than bdi -> queue and like you are doing. But I can't
> > think of a nice way to do it, so this is probably as good as it gets.
> > 
> 
> I think, one issue with ioc based approach will be that it will then call
> yield operation on all the devices in the system where this context has ever
> done any IO. With bdi based approach this call will remain limited to
> a smaller set of devices.

Oh, you'd want the bdi as well. And as I said, I don't think it was
workable, just trying to think it over and consider potentially other
ways to accomplish this.

At one point I had a patch that did the equivalant of this yield on
being scheduled out on the CPU side, which is probably why I was in the
ioc mindset.

-- 
Jens Axboe

