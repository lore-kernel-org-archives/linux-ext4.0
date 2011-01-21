From: Josef Bacik <josef@redhat.com>
Subject: Re: Severe slowdown caused by jbd2 process
Date: Fri, 21 Jan 2011 09:03:06 -0500
Message-ID: <20110121140306.GA11313@dhcp231-156.rdu.redhat.com>
References: <1295568782.2459.29.camel@tybalt> <20110121013140.GA8949@dhcp231-156.rdu.redhat.com> <1295601083.5799.3.camel@tybalt> <20110121125922.GB8949@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jon Leighton <j@jonathanleighton.com>, linux-ext4@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab1AUOGw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jan 2011 09:06:52 -0500
Content-Disposition: inline
In-Reply-To: <20110121125922.GB8949@dhcp231-156.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 21, 2011 at 07:59:22AM -0500, Josef Bacik wrote:
> On Fri, Jan 21, 2011 at 09:11:23AM +0000, Jon Leighton wrote:
> > Hi Josef,
> > 
> > Thanks for the reply.
> > 
> > On Thu, 2011-01-20 at 20:31 -0500, Josef Bacik wrote:
> > > What kind of database is this?  Does it use lots of files?
> > 
> > This happens with all databases that I test with: sqlite3, mysql and
> > postgresql. Which would seem to indicate that the issue is not actually
> > related to the databases, but is being made evident by them when they do
> > lots of reads/writes. (The jbd2 every 2 seconds thing happens even when
> > all database are completely shut down.)
> >
> 
> Right I'm not trying to blame the database, more trying to get an idea the kind
> of IO that they are generating so we can figure out what is being slow.
>  
> > > When it's being
> > > particularly slow could you run
> > > 
> > > echo w > /proc/sysrq-trigger
> > > 
> > > a couple of times, spread out.  This will give us an idea of what everybody is
> > > doing when things are going slow.  Thanks,
> > 
> > Cool, I have done that and attached the results. The partition in
> > question (the one with the databases on) is /dev/sda4.
> >
> 
> Hrm so an fsync heavy workload it looks like.  I'll run some fsync tests locally
> and see if I can see the kind of slowdowns you are experiencing.  Thanks,
>

Heh so now that I've had a moment to wake up, how about running your test on
ext3, but mount the partition with

mount -o barrier

and see if it's still faster than ext4.  Thanks,

Josef 
