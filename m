From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [E2FSPROGS, RFC] mke2fs: New bitmap and inode table allocation
 for FLEX_BG
Date: Wed, 23 Apr 2008 00:48:43 -0500
Message-ID: <20080423004843.72f65d2b@gara>
References: <1208868379-17580-1-git-send-email-tytso@mit.edu>
	<1208868379-17580-2-git-send-email-tytso@mit.edu>
	<1208868379-17580-3-git-send-email-tytso@mit.edu>
	<20080422091847.50708436@gara>
	<20080422145125.GB12836@mit.edu>
	<20080422103212.1c974bd9@gara>
	<20080422185728.GC20668@mit.edu>
	<20080422172751.22d5aef9@gara>
	<20080423012149.GF20668@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Valerie Clement <valerie.clement@bull.net>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:39286 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbYDWFtE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Apr 2008 01:49:04 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3N5n1ZA003920
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 01:49:01 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3N5n1fp254742
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 01:49:01 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3N5mplX017088
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 01:48:51 -0400
In-Reply-To: <20080423012149.GF20668@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 22 Apr 2008 21:21:49 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Tue, Apr 22, 2008 at 05:27:51PM -0500, Jose R. Santos wrote:
> > > Let's stay with 16 then for now.  Spindle speed doesn't actually
> > > matter here; what matters is seek speed, and the density of the disk
> > 
> > Well higher spindle speed affect cylinder seek times which affect
> > overall seek time, which is why I think it should be tested as well.
> 
> Well, I looked at some laptop drives with spindle speeds of 4200rpm,
> 5400rpm, and 7200rpm, and they have an average read/write seek time of
> of 10.5/12.5ms.
> 
> Comparing Western Digital's current enterprise disk drives (the RE-2)
> which are 7200rpm, and their Enterprise "Green Power" drives (the
> RE2-GP) which try to hide the fact that their disks are 5400RPM, but
> which web sites have outed by using doing a frequency analysis of its
> acoustic output --- both have the same read/write seek time of 8.9ms.

Well, these Green Power drives from Western Digital dont have constant
spindle speed and I believe that they run at 7200 rpm under load and
5400 when mostly idle.  Makes sense why the seek times would be the
same.  On the other hand, the VelociRaptor drives with 10k rpm have a
latency of 5.5ms.

Looking at the specs of Seagate Savvio and Cheetah family of drives, a
33% increase in spindle speed from 10k to 15K rpms give out around 25%
improvement in average seek latency.  Also note that benchmark
publishes that are sensitive to IO latencies tend to use smaller 15k
rpm disk than their larger but slower counter parts.  RPM speeds
usually beats density when it comes to seek time improvements.

> 
> Interestingly, some of the older disks have faster seek times (i.e.,
> 4ms), at the same disk platters, and I doubt it's because hard drive
> head positioning motors have gotten slower; rather, it's probably that
> as the platter density has increased, the time to position the hard
> drive heads is what's taking longer.  

Or it could be that hard drive manufactures in the digital media age
care more about capacity at a cheaper price than tuning a drive for
best seek performance.  For those user that demand speed, there are
options available like the VelociRaptor family of drives but those come
at a cost of both capacity and price.

I got to say 4ms is really good.  Was this on IDE?  Most drive I've
seen in this category have been stuck in the 7-8ms barrier.  Dont
recall seeing them lower than this, but I have not been paying much
attention in the last couple of years.

> Something that would be interesting to do is to do some experiments
> measuring small seeks (i.e., within a 1 gigabyte or so), and long
> seeks (i.e., across 10-20% and 50% of the disk drive).  The difference
> between those two times is what's probably driving your flex_bg
> performance numbers, and it might be easier simply to measure that
> directly.

I may have some data related to that since I did run blktrace on
some of my runs.  Need check if I still have the data so that I can run
seekwatcher on them.  I had to erase most of them since the traces where
huge. :(

> 
> 							- Ted



-JRS
