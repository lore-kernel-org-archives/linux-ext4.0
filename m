From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: PATCH ext4: fix to call_filldir
Date: Mon, 24 Nov 2008 21:05:29 -0500
Message-ID: <20081125020529.GD20928@mit.edu>
References: <20081124182105.184338C977@localhost> <20081124215146.GC20928@mit.edu> <6601abe90811241459p3b03e4cay58b45464c906482f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59326 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752471AbYKYCKa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Nov 2008 21:10:30 -0500
Content-Disposition: inline
In-Reply-To: <6601abe90811241459p3b03e4cay58b45464c906482f@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 24, 2008 at 02:59:41PM -0800, Curt Wohlgemuth wrote:
> 
> Sorry for the confusion; but this does point out a problem of mine:
> where should I be looking for ext4 patches?  I've been using
> 
>        http://repo.or.cz/w/ext4-patch-queue.git
> 
> where I'm not seeing this patch (am I just missing it?).  

You're not seeing that patch because it was already applied.  The key
is to look at the series file, where you will see something like this:

# BASE 2.6.28-rc6
#

This means that the patches in the patch queue are designed to be
applied against 2.6.28-rc6.  After they are accepted into mainline
(i.e., Linus Torvalds' git tree), the next time I rebase the patch
series, those patches which have been accepted get dropped.  So for
example, in 2.6.28-rc3, we had some urgent bug fxies that I pushed to
Linus.  Once they had been accepted, when 2.6.28-rc4 was released,
they were in Linus's tree, so when I rebased the patch series to
2.6.28-rc4, I removed the patches from the patch queue.

> Should I simply be using
> 
>        http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git

So the "master" branch in the ext4 git tree essentially contains all
of the ext4 patch queue applied against the appropriate base kernel
revision (as described in the series file).  

The "next" branch is a subset of the master branch which contains
patches which are intended to be pushed to Linus at the next
appropriate time.  These patches are the ones in the ext4 patch queue
before the "stable-boundary" patch in the series file.  Usually, "the
appropriate time" is the next merge window (i.e., after Linus released
2.6.27, there was a merge window which lasted approximately two weeks
until 2.6.28-rc1 was released; during that time, Linus accepts patches
and git pull requests ).  After the merge window closes, urgent bug
fixes (to fix really critical bugs or fixes to regressions introduced
during the merge window) are put at the beginning of the ext4 patch
queue, so that a pull request can be sent to Linus for these critical
bug fixes.  The "next" branche is also used to create the linux-next
tree which Stephen Rothwell maintains, which is why it I use the
branch name "next".

The "master" and "next" branches do not get updated as frequently as
the ext4 patch queue, especially when I've been travelling a lot and
so I don't have as much time to do testing on the full set of patches.
I usually like to do a basic smoke test to make sure things are
working correctly before I update the ext4 git tree.  The testing and
updates will be intensifying in the next two weeks, since we are
anticipating the merge window opening up for the major release.

Also useful is the "ext4-stable" branch of the ext4 git tree, which
contains all of the ext4 patches that have been accepted into mainline
backported to the last major 2.6 release.  So at the moment, this
contains all of the ext4 patches applied during the the 2.6.28-rcX
development series applied to 2.6.27.  When the 2.6.28 releases,
ext4-stable will get rebased so it will contain all of the 2.6.28 with
all newer patches that have been integrated into the mainline durin
the 2.6.29-rcX development cycle.

In theory, it would be possible to keep an ext4-stable-2.6.26 and
ext4-stable-2.6.27 going indefinitely, with patches cherry picked from
mainline so that someone who wanted the latest ext4 patches but on a
stable 2.6.26 kernel or 2.6.27 kernel could have that.  The main
reason why this doesn't happen is the lack of (my) time.  If you or
others would be interested in maintaining something like that, either
for 2.6.26 (because that seems to be Google's internal choice of
stable kernel) or 2.6.27 (because that seems to be what a number of
community distributions have settled on), I'd be happy to publish such
branches on the ext4 git tree --- or they could maintain their own git
tree.  The challenge is the time and effort to backport patches (which
gets harder over time as the newer patches may start depending on
newer kernel infrastructure that won't be present on a 2.6.26 kernel)
or the effort in testing and bugfixing said kernel (which also gets
harder over time since the divergences with the ext4 code at the tip
of Linus's tree grows over time).

Regards,

						- Ted
