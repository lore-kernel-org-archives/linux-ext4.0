From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Severe slowdown caused by jbd2 process
Date: Mon, 24 Jan 2011 12:41:28 -0800
Message-ID: <20110124204128.GB32261@tux1.beaverton.ibm.com>
References: <1295568782.2459.29.camel@tybalt> <20110121013140.GA8949@dhcp231-156.rdu.redhat.com> <1295601083.5799.3.camel@tybalt> <20110121125922.GB8949@dhcp231-156.rdu.redhat.com> <20110121140306.GA11313@dhcp231-156.rdu.redhat.com> <1295620109.22802.1.camel@tybalt> <20110121143145.GB11313@dhcp231-156.rdu.redhat.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jon Leighton <j@jonathanleighton.com>, linux-ext4@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:58801 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1AXUle (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Jan 2011 15:41:34 -0500
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e31.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p0OKR8br021851
	for <linux-ext4@vger.kernel.org>; Mon, 24 Jan 2011 13:27:08 -0700
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p0OKfUti070094
	for <linux-ext4@vger.kernel.org>; Mon, 24 Jan 2011 13:41:30 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p0OKfTJ9013330
	for <linux-ext4@vger.kernel.org>; Mon, 24 Jan 2011 13:41:29 -0700
Content-Disposition: inline
In-Reply-To: <20110121143145.GB11313@dhcp231-156.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 21, 2011 at 09:31:45AM -0500, Josef Bacik wrote:
> On Fri, Jan 21, 2011 at 02:28:29PM +0000, Jon Leighton wrote:
> > Hi there,
> > 
> > On Fri, 2011-01-21 at 09:03 -0500, Josef Bacik wrote:
> > > Heh so now that I've had a moment to wake up, how about running your test on
> > > ext3, but mount the partition with
> > > 
> > > mount -o barrier
> > > 
> > > and see if it's still faster than ext4.  Thanks,
> > 
> > You're right, that slows it down significantly on the ext3 partition. Is
> > this expected behaviour with ext4 then?
> >
> 
> Yup, whatever you are doing in your webapp is making your database do lots of
> fsyncs, which is going to suck.  If you are on a battery backed system or just
> don't care if you lose your database and rather it be faster you can mount your
> ext4 fs with -o nobarrier.  Thanks,

If for some reason you can't change the database to be less fsync-happy and
there are a lot of threads issuing fsync in parallel, you might try building a
kernel with the patch set that Tejun Heo has put together
(https://lkml.org/lkml/2011/1/21/251) to merge flush requests coming from
multiple threads.  It might speed things up for you.

(I don't know how much that patch set will change between now and the time it
goes upstream...)

--D
