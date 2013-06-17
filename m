From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v4 15/20] ext4: use ext4_zero_partial_blocks in punch_hole
Date: Mon, 17 Jun 2013 08:25:18 -0400
Message-ID: <20130617122518.GA24403@thunk.org>
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
 <1368549454-8930-16-git-send-email-lczerner@redhat.com>
 <20130614030154.GA18731@thunk.org>
 <alpine.LFD.2.00.1306141216070.2327@localhost.localdomain>
 <20130614133710.GA6250@localhost>
 <alpine.LFD.2.00.1306171104540.3270@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58623 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203Ab3FQMZW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Jun 2013 08:25:22 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1306171104540.3270@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 17, 2013 at 11:08:32AM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> > Correction...  reverting patches #15 through #19 (which is what I d=
id in
> > the dev-with-revert branch found on ext4.git) causes the problem to=
 go
> > away in the nojournal case, but it causes a huge number of other
> > problems.  Some of the reverts weren't clean, so it's possible I
> > screwed up one of the reverts.  It's also possible that only applyi=
ng
> > part of this series leaves the tree in an unstable state.
> >=20
> > I'd much rather figure out how to fix the problem on the dev branch=
,
> > so thank you for looking into this!
>=20
> Wow, this looks bad. Theoretically reverting patches %15 through
> #19 should not have any real impact. So far I do not see what is
> causing that, but I am looking into this.

I've been looking into this more intensively over the weekend.  I'm
now beginning to think we have had a pre-existing race, and the
changes in question has simply changed the timing.  I tried a version
of the dev branch (you can find it as the branch dev2 in my
kernel.org's ext4.git tree) which only had patches 1 through 10 of the
invalidate page range patches (dropping patches 11 through 20), and I
found that generic/300 was failing in the configuration ext3 (a file
system with nodelalloc, no flex_bg, and no extents).  I also found
the same failure with a 3.10-rc2 configuration.

The your changes seem to make generic/300 failure consistently for me
using the nojournal configuration, but looking at patches in question,
I don't think they could have directly caused the problem.  Instead, I
think they just changed the timing to unmask the problem.

Given that I've seen generic/300 test failures in various different
baselines going all the way back to 3.9-rc4, this isn't a recent
regression.  And given that it does seem to be timing sensitive,
bisecting it is going to be difficult.  On the other hand, given that
using the dev (or master) branch, generic/300 is failing with a
greater than 70% probability using kvm with 2 cpu's, 2 megs of RAM and
5400 rpm laptop drives in nojournal mode, the fact that it's
reproducing relatively reliably hopefully will make it easier to find
the problem.

> I see that there are problems in other mode, not just nojournal. Are
> those caused by this as well, or are you seeing those even without
> the patchset ?

I think the other problems in my dev-with-revert branch was caused by
some screw up on my part when did the revert using git.  I found that
dropping the patches from a copy of the guilt patch stack, and then
applying all of the patches except for the last half of the invalidate
page range patch series, resulted in a clean branch that didn't have
any of these failures.  It's what I should have done late last week,
instead of trying to use "git revert".

Cheers,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
