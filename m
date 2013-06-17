From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v4 15/20] ext4: use ext4_zero_partial_blocks in
 punch_hole
Date: Mon, 17 Jun 2013 14:46:29 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1306171435301.3270@localhost.localdomain>
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com> <1368549454-8930-16-git-send-email-lczerner@redhat.com> <20130614030154.GA18731@thunk.org> <alpine.LFD.2.00.1306141216070.2327@localhost.localdomain> <20130614133710.GA6250@localhost>
 <alpine.LFD.2.00.1306171104540.3270@localhost.localdomain> <20130617122518.GA24403@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1097702182-1371473192=:3270"
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756175Ab3FQMqf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Jun 2013 08:46:35 -0400
In-Reply-To: <20130617122518.GA24403@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1097702182-1371473192=:3270
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 17 Jun 2013, Theodore Ts'o wrote:

> Date: Mon, 17 Jun 2013 08:25:18 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH v4 15/20] ext4: use ext4_zero_partial_blocks in punch_hole
> 
> On Mon, Jun 17, 2013 at 11:08:32AM +0200, Lukáš Czerner wrote:
> > > Correction...  reverting patches #15 through #19 (which is what I did in
> > > the dev-with-revert branch found on ext4.git) causes the problem to go
> > > away in the nojournal case, but it causes a huge number of other
> > > problems.  Some of the reverts weren't clean, so it's possible I
> > > screwed up one of the reverts.  It's also possible that only applying
> > > part of this series leaves the tree in an unstable state.
> > > 
> > > I'd much rather figure out how to fix the problem on the dev branch,
> > > so thank you for looking into this!
> > 
> > Wow, this looks bad. Theoretically reverting patches %15 through
> > #19 should not have any real impact. So far I do not see what is
> > causing that, but I am looking into this.
> 
> I've been looking into this more intensively over the weekend.  I'm
> now beginning to think we have had a pre-existing race, and the
> changes in question has simply changed the timing.  I tried a version
> of the dev branch (you can find it as the branch dev2 in my
> kernel.org's ext4.git tree) which only had patches 1 through 10 of the
> invalidate page range patches (dropping patches 11 through 20), and I
> found that generic/300 was failing in the configuration ext3 (a file
> system with nodelalloc, no flex_bg, and no extents).  I also found
> the same failure with a 3.10-rc2 configuration.
> 
> The your changes seem to make generic/300 failure consistently for me
> using the nojournal configuration, but looking at patches in question,
> I don't think they could have directly caused the problem.  Instead, I
> think they just changed the timing to unmask the problem.

Ok, I though that there is something weird because patches #1-#14
should not cause anything like that and from my testing (see my
previous mail) it really seems it does not cause it, at least not
directly.

> 
> Given that I've seen generic/300 test failures in various different
> baselines going all the way back to 3.9-rc4, this isn't a recent
> regression.  And given that it does seem to be timing sensitive,
> bisecting it is going to be difficult.  On the other hand, given that
> using the dev (or master) branch, generic/300 is failing with a
> greater than 70% probability using kvm with 2 cpu's, 2 megs of RAM and
> 5400 rpm laptop drives in nojournal mode, the fact that it's
> reproducing relatively reliably hopefully will make it easier to find
> the problem.

As mentioned in previous email test generic/300 runs without any
problems (even in the loop) without journal with patches #1 through
#14 applied on 3.10-rc2 (c7788792a5e7b0d5d7f96d0766b4cb6112d47d75).
This is on kvm with 24 cpu's, 8GB of RAM (I suppose you're not using
2MB of ram in your setup, but rather 2GB :) and server drives with
linear lvm on top of it.

-Lukas

> 
> > I see that there are problems in other mode, not just nojournal. Are
> > those caused by this as well, or are you seeing those even without
> > the patchset ?
> 
> I think the other problems in my dev-with-revert branch was caused by
> some screw up on my part when did the revert using git.  I found that
> dropping the patches from a copy of the guilt patch stack, and then
> applying all of the patches except for the last half of the invalidate
> page range patch series, resulted in a clean branch that didn't have
> any of these failures.  It's what I should have done late last week,
> instead of trying to use "git revert".
> 
> Cheers,
> 
> 					- Ted
> 
--8323328-1097702182-1371473192=:3270--
