From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add fallocate mode blocking for debugging purposes
Date: Tue, 15 Apr 2014 19:30:39 -0400
Message-ID: <20140415233039.GR4456@thunk.org>
References: <1397420518-29218-1-git-send-email-tytso@mit.edu>
 <20140413220016.GD8122@thunk.org>
 <alpine.LFD.2.00.1404151749490.2146@localhost.localdomain>
 <534D5B2D.70408@redhat.com>
 <20140415184442.GC4456@thunk.org>
 <534DB38B.7030805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Namjae Jeon <linkinjeon@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54817 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbaDOXam (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Apr 2014 19:30:42 -0400
Content-Disposition: inline
In-Reply-To: <534DB38B.7030805@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 15, 2014 at 05:32:43PM -0500, Eric Sandeen wrote:
> > I also had a sneaking suspicion that we might have a similar issue
> > with the INSERT RANGE patches which are coming down the pike, and so
> > having a general way of also being able INSERT RANGE if to be able to
> > quickly determine whether a potential bug was caused by INSERT RANGE
> > or some other pending changes might also be useful.
> 
> Also: I'd humbly suggest just not merging those until they pass stringent
> tests like fsx & fsstress...
> 
> Adding a pre-emptive knob to turn them off post-merge when they turn
> out to be broken sounds backwards to me...

Having learned from COLLAPSE RANGE, I agree.  The fact that we didn't
have full testing during the whole development cycle was unfortunate.
And we got lucky with the renameat patches, since I wasn't able to get
tha testing done because the xfstests commits didn't get merged until
*after* the they renameat commits got merged, and also because I
didn't notice that the i386 system call wasn't wired up when I was
doing my manual "just before I push to Linus" testing.

I plan on insisting that INSERT RANGE support being in the VFS, and be
fully enabled, and that we have full INSERT RANGE testing into
xfstests, during the development cycle.  Some of the work that I've
been doing with kvm-xfstests and why I created a github tytso/xfstests
git tree is specifically to make sure things go much more smoothly
this time around.  (That way, if there is some new fs feature patch,
such as COLLAPSE RANGE or renameat(2) where the tests are still being
refined for xfstests inclusion, we can still have something we can all
use on an interim basis during the development cycle.)

However, with all of this being said, while new feature patches such
sa INSERT RANGE are cooking in the ext4.git tree, so that multiple
developers *can* do that testing, having a knob to turn the feature on
and off without having to do a kernel recompile is convenient.

Cheers,

						- Ted
