From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Thu, 3 Sep 2009 11:47:09 +0200
Message-ID: <20090903094709.GG3793@elf.ucw.cz>
References: <4A9468E8.607@redhat.com> <20090825225114.GE4300@elf.ucw.cz> <4A946DD1.8090906@redhat.com> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <20090825235359.GJ4300@elf.ucw.cz> <4A947DA9.2080906@redhat.com> <20090826001645.GN4300@elf.ucw.cz> <4A948259.40007@redhat.com> <20090826010018.GA17684@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50320 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbZICJr3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Sep 2009 05:47:29 -0400
Content-Disposition: inline
In-Reply-To: <20090826010018.GA17684@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 2009-08-25 21:00:18, Theodore Tso wrote:
> On Tue, Aug 25, 2009 at 08:31:21PM -0400, Ric Wheeler wrote:
> >>> You are simply incorrect, Ted did not say that ext3 does not work
> >>> with MD raid5.
> >>
> >> http://lkml.org/lkml/2009/8/25/312
> >
> > I will let Ted clarify his text on his own, but the quoted text says "... 
> > have potential...".
> >
> > Why not ask Neil if he designed MD to not work properly with ext3?
> 
> So let me clarify by saying the following things.   
> 
> 1) Filesystems are designed to expect that storage devices have
> certain properties.  These include returning the same data that you
> wrote, and that an error when writing a sector, or a power failure
> when writing sector, should not be amplified to cause collateral
> damage with previously succfessfully written sectors.

Yes. Unfortunately, different filesystems expect different properties
from block devices. ext3 will work with write cache enabled/barriers
enabled, while ext2 needs write cache disabled.

The requirements are also quite surprising; AFAICT ext3 can handle
disk writing garbage to single sector during powerfail, while xfs can
not handle that.

Now, how do you expect users to know these subtle details when it is
not documented anywhere? And why are you fighting against documenting
these subtleties?

> Secondly, what's the probability of a failure causes the RAID array to
> become degraded, followed by a power failure, versus a power failure
> while the RAID array is not running in degraded mode?  Hopefully you
> are running with the RAID array in full, proper running order a much
> larger percentage of the time than running with the RAID array in
> degraded mode.  If not, the bug is with the system administrator!

As was uncovered, MD RAID does not properly support barriers,
so... you don't actually need drive failure.

> Maybe a random OS engineer doesn't know these things --- but trust me
> when I say a competent system administrator had better be familiar
> with these concepts.  And someone who wants their data to be
> reliably

Trust me, 99% of sysadmins are not compentent by your definition. So
this should be documented.

> At the end of the day, filesystems are not magic.  They can't
> compensate for crap hardware, or incompetently administered machines.

ext3 greatly contributes to administrator incomentency:

# The journal supports the transactions start and stop, and in case of a
# crash, the journal can replay the transactions to quickly put the
# partition back into a consistent state.

...it does not mention that (non-default!) barrier=1 is needed to make
this reliable, nor it mentions that there are certain requirements for
this to work. It just says that journal will magically help you.

And you wonder while people expect magic from your filesystem?

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
