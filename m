From: Josef Bacik <josef@redhat.com>
Subject: Re: Severe slowdown caused by jbd2 process
Date: Fri, 21 Jan 2011 09:31:45 -0500
Message-ID: <20110121143145.GB11313@dhcp231-156.rdu.redhat.com>
References: <1295568782.2459.29.camel@tybalt> <20110121013140.GA8949@dhcp231-156.rdu.redhat.com> <1295601083.5799.3.camel@tybalt> <20110121125922.GB8949@dhcp231-156.rdu.redhat.com> <20110121140306.GA11313@dhcp231-156.rdu.redhat.com> <1295620109.22802.1.camel@tybalt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org
To: Jon Leighton <j@jonathanleighton.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab1AUOfb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jan 2011 09:35:31 -0500
Content-Disposition: inline
In-Reply-To: <1295620109.22802.1.camel@tybalt>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 21, 2011 at 02:28:29PM +0000, Jon Leighton wrote:
> Hi there,
> 
> On Fri, 2011-01-21 at 09:03 -0500, Josef Bacik wrote:
> > Heh so now that I've had a moment to wake up, how about running your test on
> > ext3, but mount the partition with
> > 
> > mount -o barrier
> > 
> > and see if it's still faster than ext4.  Thanks,
> 
> You're right, that slows it down significantly on the ext3 partition. Is
> this expected behaviour with ext4 then?
>

Yup, whatever you are doing in your webapp is making your database do lots of
fsyncs, which is going to suck.  If you are on a battery backed system or just
don't care if you lose your database and rather it be faster you can mount your
ext4 fs with -o nobarrier.  Thanks,

Josef 


