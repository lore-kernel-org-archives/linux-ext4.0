From: Keith Mannthey <kmannth@us.ibm.com>
Subject: Re: Ext4 performance regression: Post 2.6.30
Date: Wed, 31 Mar 2010 15:14:36 -0700
Message-ID: <1270073676.7193.34.camel@keith-laptop>
References: <1269843935.13369.52.camel@keith-laptop>
	 <87f94c371003290810u58f64ce6uc20be6bbac420e73@mail.gmail.com>
	 <1270000565.7193.14.camel@keith-laptop> <4BB2CA41.5050406@redhat.com>
	 <1270072944.7193.29.camel@keith-laptop>
	 <x2i87f94c371003311506w94321779nfc3f48d939073e47@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57188 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756182Ab0CaWOk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Mar 2010 18:14:40 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e5.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o2VLxxue005731
	for <linux-ext4@vger.kernel.org>; Wed, 31 Mar 2010 17:59:59 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2VMEaMg1347742
	for <linux-ext4@vger.kernel.org>; Wed, 31 Mar 2010 18:14:36 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o2VMEaXp007950
	for <linux-ext4@vger.kernel.org>; Wed, 31 Mar 2010 19:14:36 -0300
In-Reply-To: <x2i87f94c371003311506w94321779nfc3f48d939073e47@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2010-03-31 at 18:06 -0400, Greg Freemyer wrote:
> On Wed, Mar 31, 2010 at 6:02 PM, Keith Mannthey <kmannth@us.ibm.com> wrote:
> > On Tue, 2010-03-30 at 23:06 -0500, Eric Sandeen wrote:
> >> Keith Mannthey wrote:
> >> > On Mon, 2010-03-29 at 11:10 -0400, Greg Freemyer wrote:
> >> >> On Mon, Mar 29, 2010 at 2:25 AM, Keith Mannthey <kmannth@us.ibm.com> wrote:
> >> >>>
> >> >>> After 2.6.30 I am seeing large performance regressions on a raid setup.
> >> >>> I am working to publish a larger amount of data but I wanted to get some
> >> >>> quick data out about what I am seeing.
> >> >>>
> >> >> Is mdraid involved?
> >> >>
> >> >> They added barrier support for some configs after 2.6.30 I believe.
> >> >> It can cause a drastic perf change, but it increases reliability and
> >> >> is "correct".
> >> >
> >> > lvm and device mapper are is involved.  The git bisect just took me to:
> >> >
> >> > 374bf7e7f6cc38b0483351a2029a97910eadde1b is first bad commit
> >> > commit 374bf7e7f6cc38b0483351a2029a97910eadde1b
> >> > Author: Mikulas Patocka <mpatocka@redhat.com>
> >> > Date:   Mon Jun 22 10:12:22 2009 +0100
> >> >
> >> >     dm: stripe support flush
> >> >
> >> >     Flush support for the stripe target.
> >> >
> >> >     This sets ti->num_flush_requests to the number of stripes and
> >> >     remaps individual flush requests to the appropriate stripe devices.
> >> >
> >> >     Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> >> >     Signed-off-by: Alasdair G Kergon <agk@redhat.com>
> >> >
> >> > :040000 040000 542f4b9b442d1371c6534f333b7e00714ef98609 d490479b660139fc1b6b0ecd17bb58c9e00e597e M  drivers
> >> >
> >> >
> >> > This may be correct behavior but the performance penalty in this test
> >> > case is pretty high.
> >> >
> >> > I am going to move back to current kernels and starting looking into
> >> > ext4/dm flushing.
> >>
> >> It would probably be interesting to do a mount -o nobarrier to see if
> >> that makes the regression go away.
> >
> > -o nobarrier takes the regression away with 2.6.34-rc3:
> >
> > Default mount: ~27500
> >
> > -o nobarrier: ~12500
> >
> > Barriers on this setup cost ALOT during writes.
> >
> > Interestingly as well the "mailserver" workload regression is also
> > removed by mounting with "-o nobarrier".
> >
> > I am going to see what impact is seen on a single disk setup.
> >
> > Thanks,
> >  Keith Mannthey
> >  LTC FS-Dev
> 
> I'm curious if your using an internal or external journal?

I am unsure.  How do I tell?  I am using defaults except with the -o
nobarrier.   I know jdb2 is being used. 

Thanks,
  Keith 

> I'd guess the cost of barriers is much greater with an internal
> journal, but I don't recall seeing any benchmarks one way or the
> other.
> 
> Greg

