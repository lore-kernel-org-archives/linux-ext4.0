From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: ext4: journal has aborted
Date: Fri, 04 Jul 2014 16:38:50 +0400
Message-ID: <87oax5z4bp.fsf@openvz.org>
References: <CAFnufp3TepsxxX8=WCJ0V=3TELP0rWR-NxFukSL8X=qS1q6Eew@mail.gmail.com> <20140701082619.1ac77f1d@archvile> <20140701084206.GG9743@birch.djwong.org> <CAFnufp2TPSyZe4NUSTVeSWuSDwsCLHDogBvAWV4_+JaQFRrw-w@mail.gmail.com> <20140703134338.GE2374@thunk.org> <20140703161551.5fd13245@archvile> <87tx6yzdxz.fsf@openvz.org> <20140704114031.2915161a@archvile> <87r421zavi.fsf@openvz.org> <20140704132802.0d43b1fc@archvile> <20140704122022.GC10514@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matteo Croce <technoboy85@gmail.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, David Jander <david@protonic.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:49724 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbaGDMiy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jul 2014 08:38:54 -0400
Received: by mail-lb0-f177.google.com with SMTP id u10so1111800lbd.22
        for <linux-ext4@vger.kernel.org>; Fri, 04 Jul 2014 05:38:52 -0700 (PDT)
In-Reply-To: <20140704122022.GC10514@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 4 Jul 2014 08:20:22 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> On Fri, Jul 04, 2014 at 01:28:02PM +0200, David Jander wrote:
> > 
> > Here is the output I am getting... AFAICS no problems on the raw device. Is
> > this sufficient testing, Ted?
> 
> I'm not sure what theory Dmitry was trying to pursue when he requested
> that you run the fio test.  Dmitry?
Because at this moment we have some complex storage+fs interaction,
My idea was to simply isolate raw dev case and run integrity test on that storage.
fio/libaio is trivial and easy way to do it(except it does not issued
flush cmd).  Unfortunetly according to David test finished w/o any
error. So my theory about broken strorage driver was not confirmed.

> 
> 
> Please note that at this point there may be multiple causes with
> similar symptoms that are showing up.  So just because one person
> reports one set of data points, such as someone claiming they've seen
> this without a power drop to the storage device, that therefore all of
> the problems were caused by flaky I/O to the device.
> 
> Right now, there are multiple theories floating around --- and it may
> be that more than one of them are true (i.e., there may be multiple
> bugs here).  Some of the possibilities, which again, may not be
> mutually exclusive:
> 
> 1) Some kind of eMMC driver bug, which is possibly causing the CACHE
> FLUSH command not to be sent.
> 
> 2) Some kind of hardware problem involving flash translation layers
> not having durable transactions of their flash metadata across power
> failures.
> 
> 3) Some kind of ext4/jbd2 bug, recently introduced, where we are
> modifying some ext4 metadata (either the block allocation bitmap or
> block group summary statistics) outside of a valid transaction handle.
> 
> 4) Some other kind of hard-to-reproduce race or wild pointer which is
> sometimes corrupting fs data structures.
> 
> 
> If someone has a easy to reproduce failure case, the first step is to
> do a very rough bisection test.  Does the easy-to-reproduce failure go
> away if you use 3.14?  3.12?  Also, if you can describe in great
> detail your hardware and software configuration, and under what
> circumstances the problem reproduces, and when it doesn't, that would
> also be critical.  Whether you are just doing reset or a power cycle
> if an unclean shutdown is involved, might also be important.
> 
> And at this point, because I'm getting very suspicious that there may
> be more than one root cause, we should try to keep the debugging of
> one person's reproduction, such as David's, separate from another's,
> such as Matteo's.  It may be that there ultimately have the same root
> cause, and so if one person is able to get an interesting reproduction
> result, it would be great for the other person to try running the same
> experiment on their hardware/software configuration.  But what we must
> not do is assume that one person's experiment is automatically
> applicable to other circumstances.
> 
> Cheers,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
