From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Remove some deprecated mount options
Date: Thu, 30 Jun 2011 11:20:08 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106301106270.4489@dhcp-27-109.brq.redhat.com>
References: <1309276394-11536-1-git-send-email-lczerner@redhat.com> <B9B585C1-330D-487B-9E1A-B55255377451@dilger.ca> <4E0AE886.6060005@gmail.com> <alpine.LFD.2.00.1106291249550.6151@dhcp-27-109.brq.redhat.com> <4E0B3E3A.5030509@redhat.com>
 <469EED47-CF7D-4F1C-92BA-7C7277D31448@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Sandeen <sandeen@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Ric Wheeler <ricwheeler@gmail.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab1F3JUR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Jun 2011 05:20:17 -0400
In-Reply-To: <469EED47-CF7D-4F1C-92BA-7C7277D31448@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 29 Jun 2011, Andreas Dilger wrote:

> On 2011-06-29, at 9:01 AM, Eric Sandeen wrote:
> > On 6/29/11 6:03 AM, Lukas Czerner wrote:
> >> On Wed, 29 Jun 2011, Ric Wheeler wrote:
> >> 
> >>> On 06/28/2011 05:35 PM, Andreas Dilger wrote:
> >>>> On 2011-06-28, at 9:53 AM, Lukas Czerner wrote:
> >>>>> Remove deprecated mount options bsddf, nogrpid, sysvgroups which has
> >>>>> been marked as deprecated since 2.6.23 and should be removed in 2.6.28.
> >>>>> However it is not a big deal because those are defaults anyway and the
> >>>>> options for setting their opposites still remains in kernel (however are
> >>>>> still deprecated). Also push the kernel version to remove those leftover
> >>>>> options further in time.
> >> 
> >>>> 
> >>>> One problem is that these options haven't been deprecated in major vendor
> >>>> releases (e.g. 2.6.32 for RHEL6 and SLES11), which is what most people are
> >>>> using.  I think that they should be deprecated for at least one major
> >>>> vendor release before being removed, otherwise it is nearly the same as just
> >>>> deleting them on some random kernel version without telling anyone.
> >>>> 
> >>>> I'm not sure where you got "2.6.23" and "2.6.28" from, maybe you meant
> >>>> "2.6.33",
> >> 
> >> Oh, sure it should be 2.6.33 and 2.6.38, sorry!
> >> 
> >>>> which is unfortunately just after the cutoff for both RHEL6 and SLES11SP1.
> >>> 
> >>> I am not sure that I follow the concern - people who use upstream follow that,
> >>> people who use vendor kernels get some branched version of something old.
> >>> 
> >>> In fact, we try hard *not* to do things in RHEL kernels that are not
> >>> upstream first. I would be perfectly happy to drop it upstream first and
> >>> then deprecate it in a future RHEL release.
> >> 
> >> Ric has a valid point, it does not matter that the deprecation change
> >> did not appear in RHEL, SLES or others because it is really a distributor
> >> decision what code from what kernel version to use and communicate
> >> changes with their customers.
> >> 
> >> That said, I do not think there is a point in upstream waiting for
> >> distributors to adopt some change. Especially when it is not a question
> >> feature test coverage.
> > 
> > *nod* I don't mean to turn this into an RH me-too fest, but we usually
> > go the other way; make changes we want to see upstream first, and then
> > they find their way into a distro.
> > 
> > We try to be pretty conservative on which of the filesystem configurations
> > we support (you all know of my love for mount option matrices by now)
> > so I'll shed no tear over losing these ...
> 
> I think you are all missing my point.
> 
> The reason we mark options deprecated is so that users have some chance to
> see this in advance and allow them to fix up their userspace and stop using
> the options so that their mounts don't start failing when they upgrade to
> some kernel that doesn't support them.
> 
> If the majority of users (~= RHEL and SLES users) have never used a kernel
> where these options were marked deprecated (i.e. 2.6.33+), then from their
> POV it will be the same as if the options were just yanked out from under
> their feet when they eventually do upgrade the kernel, since they will never
> have seen an intermediate kernel.
> 
> I understand that you want to incorporate changes into RHEL that are already
> upstream, so I would suggest FIRST to merge into RHEL6.x changes marking
> these mount options as deprecated (which are upstream since 2.6.33), and we
> can try to do the same for SLES11 SP1.  This will give a much wider exposure
> to the option deprecation.  If there are no serious complaints from users
> in the next year (which you are already confident of, if you want to remove
> the options entirely) we can safely remove the mount options in upstream,
> still leaving plenty of time to include this change into RHEL7.
> 
> Cheers, Andreas

So there are two problems.

1. The first one is that people have to notice that it has been deprecated
before we actually remove the option. Upstream people had a lot of time
to notice that (since 2.6.33) and it should have been removed in 2.6.38.
The reason it was not removed is that some people (actually two people,
one for each option) showed up asking for not removing those option.
Namely it was bsdgroups and minixdf.

This has nothing to do with distributors since they can decide what to
take and what not (once it is upstream of course). So in this case there
is no reason for delaying the removal any further.

2. The second is that there still might be people actually using this
and the should have had the opportunity to react against the removal. As
I understand it this is your point. Once we remove it upstream and
distributors will deprecate it first there might be people arguing
against it, which would be already too late for upstream.

Well, in this case we do not have to be that extra careful. Those
options this patch removes are default, so no one actually needs to use
it. The only people who might be remotely interested in it are those two
I mentioned above, if they want (for some crazy reason) switch back and
forth between the functionalities, but I very seriously doubt that.

So I do not see any reason for not removing it, actually it should have
been removed in 2.6.38 since noone argued against it.

Thanks!
-Lukas
