From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: data corruption with ext4 (from 2.6.27.4) exposed by rtorrent
Date: Thu, 6 Nov 2008 15:45:21 +0530
Message-ID: <20081106101521.GB25194@skywalker>
References: <3d3ce57e0811030442o377cf2bet212eefba79d714bb@mail.gmail.com> <20081103134008.GE29102@mit.edu> <319012f0811030734s6d14b2b3t13c32a41ac48e852@mail.gmail.com> <20081103165144.6514f003@starbug.prg01.itonis.net> <18705.63392.489856.682976@frecb006361.adech.frec.bull.fr> <20081105195713.GB9266@mit.edu> <18705.64906.497902.219660@frecb006361.adech.frec.bull.fr> <18706.44.567787.592343@frecb006361.adech.frec.bull.fr> <20081105204223.GC9266@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Solofo.Ramangalahy@bull.net,
	Jindrich Makovicka <makovick@gmail.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:39137 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbYKFKPh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 05:15:37 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id mA6AFT0V014825
	for <linux-ext4@vger.kernel.org>; Thu, 6 Nov 2008 15:45:29 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA6AFMmZ3383376
	for <linux-ext4@vger.kernel.org>; Thu, 6 Nov 2008 15:45:22 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id mA6AFSm2013249
	for <linux-ext4@vger.kernel.org>; Thu, 6 Nov 2008 15:45:29 +0530
Content-Disposition: inline
In-Reply-To: <20081105204223.GC9266@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 05, 2008 at 03:42:23PM -0500, Theodore Tso wrote:
> On Wed, Nov 05, 2008 at 09:21:00PM +0100, Solofo.Ramangalahy@bull.net wrote:
> > Solofo.Ramangalahy@bull.net writes:
> >  >  > The next question is whether the problem is more easily triggerred
> >  >  > when under memory pressure.
> >  > 
> >  > I was currently testing other kernels, but, right, I will retest with more memory.
> > 
> > with -m 2048 I do not observe the problem.
> > 
> > I should add that with 2.6.28-rc3 + ext4 patch queue, I am observing
> > what seems to be lockdep bug:
> > [   31.603020] BUG: key c9f315a8 not in .data!
> 
> Aneesh has some new patches in the ext4 patch queue that add new
> lockdep annotations.  I'm guessing there's a problem there.  Aneesh,
> can you look into this?  Solofo, can you send the .config you used
> in case it was unique to replicating the problem?

The patch aneesh-9-fix-lockdeep-recursive-locking-warning
should add the key in .data.  Do you have a stack trace ?
Can you find out which lock the lockdep is warning about

-aneesh
