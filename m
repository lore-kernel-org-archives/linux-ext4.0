From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: ext4: journal has aborted
Date: Thu, 10 Jul 2014 17:13:34 -0700
Message-ID: <20140711001334.GF10417@birch.djwong.org>
References: <20140704122022.GC10514@thunk.org>
 <20140704154559.026331ec@archvile>
 <20140704184539.GA11103@thunk.org>
 <20140707141701.2f9529af@archvile>
 <20140707155310.GB8254@thunk.org>
 <20140707225619.GD8254@thunk.org>
 <20140710185748.GA26636@wallace>
 <20140710200126.GE10417@birch.djwong.org>
 <CAFnufp2yDsbHby6Ye-Ldjz=qGWyxOJUMv8JZJa-5+f6CUFSpYw@mail.gmail.com>
 <20140710223245.GB12018@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matteo Croce <technoboy85@gmail.com>,
	Eric Whitney <enwlinux@gmail.com>,
	David Jander <david@protonic.nl>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org, Azat Khuzhin <a3at.mail@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17774 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaGKANv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2014 20:13:51 -0400
Content-Disposition: inline
In-Reply-To: <20140710223245.GB12018@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 10, 2014 at 06:32:45PM -0400, Theodore Ts'o wrote:
> To be clear, what you would need to do is to revert commit
> 007649375f6af242d5b1df2c15996949714303ba to prevent the fs corruption.
> Darrick's patch is one that tries to fix the problem addressed by that
> commit in a different fashion.
> 
> Quite frankly, reverting the commit, which is causing real damage, is
> far more impotrant to me right now than what to do in order allow
> CONFIG_EXT4FS_DEBUG to work (which is nice, but it's only something
> that file system developers need, and to be honest I can't remember
> the last time I've used said config option).  But if we know that
> Darrick's fix works, I'm willing to push that to Linus at the same
> time that I push a revert of 007649375f6af242d5b1df2c15996949714303ba

Reverting the 007649375... patch doesn't seem to create any obvious regressions
on my test box (though again, I was never able to reproduce it as consistently
as Eric W.).

Tossing in the [1] patch also fixes the crash when CONFIG_EXT4_DEBUG=y on
3.16-rc4.  I'd say it's safe to send both to Linus and stable.

If anyone experiences problems that I'm not seeing, please yell loudly and
soon!

--D

[1] http://www.spinics.net/lists/linux-ext4/msg43287.html
> 
> Cheers,
> 
> 						- Ted
> 
> On Thu, Jul 10, 2014 at 11:31:14PM +0200, Matteo Croce wrote:
> > Will do, thanks!
> > 
> > 2014-07-10 22:01 GMT+02:00 Darrick J. Wong <darrick.wong@oracle.com>:
> > > On Thu, Jul 10, 2014 at 02:57:48PM -0400, Eric Whitney wrote:
> > >> * Theodore Ts'o <tytso@mit.edu>:
> > >> > On Mon, Jul 07, 2014 at 11:53:10AM -0400, Theodore Ts'o wrote:
> > >> > > An update from today's ext4 concall.  Eric Whitney can fairly reliably
> > >> > > reproduce this on his Panda board with 3.15, and definitely not on
> > >> > > 3.14.  So at this point there seems to be at least some kind of 3.15
> > >> > > regression going on here, regardless of whether it's in the eMMC
> > >> > > driver or the ext4 code.  (It also means that the bug fix I found is
> > >> > > irrelevant for the purposes of working this issue, since that's a much
> > >> > > harder to hit, and that bug has been around long before 3.14.)
> > >> > >
> > >> > > The problem in terms of narrowing it down any further is that the
> > >> > > Pandaboard is running into RCU bugs which makes it hard to test the
> > >> > > early 3.15-rcX kernels.....
> > >> >
> > >> > In the hopes of making it easy to bisect, I've created a kernel branch
> > >> > which starts with 3.14, and then adds on all of the ext4-related
> > >> > commits since then.   You can find it at:
> > >> >
> > >> > git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git test-mb_generate_buddy-failure
> > >> >
> > >> > https://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/log/?h=test-mb_generate_buddy-failure
> > >> >
> > >> > Eric, can you see if you can repro the failure on your Panda Board?
> > >> > If you can, try doing a bisection search on these series:
> > >> >
> > >> > git bisect start
> > >> > git bisect good v3.14
> > >> > git bisect bad test-mb_generate_buddy-failure
> > >> >
> > >> > Hopefully if it is caused by one of the commits in this series, we'll
> > >> > be able to pin point it this way.
> > >>
> > >> First, the good news (with luck):
> > >>
> > >> My testing currently suggests that the patch causing this regression was
> > >> pulled into 3.15-rc3 -
> > >>
> > >> 007649375f6af242d5b1df2c15996949714303ba
> > >> ext4: initialize multi-block allocator before checking block descriptors
> > >>
> > >> Bisection by selectively reverting ext4 commits in -rc3 identified this patch
> > >> while running on the Pandaboard.  I'm still using generic/068 as my reproducer.
> > >> It occasionally yields a false negative, but it has passed 10 consecutive
> > >> trials on my revert/bisect kernel derived from 3.15-rc3.  Given the frequency
> > >> of false negatives I've seen, I'm reasonably confident in that result.  I'm
> > >> going to run another series with just that patch reverted on 3.16-rc3.
> > >>
> > >> Looking at the patch, the call to ext4_mb_init() was hoisted above the code
> > >> performing journal recovery in ext4_fill_super().  The regression occurs only
> > >> after journal recovery on the root filesystem.
> > >
> > > Thanks for finding the culprit! :)
> > >
> > > Can you apply this patch, build with CONFIG_EXT4FS_DEBUG=y, and see if an
> > > FS will mount without crashing?  This was the cruddy patch I sent in (and later
> > > killed) that fixed the crash on mount with EXT4FS_DEBUG in a somewhat silly
> > > way.  Maybe it's appropriate now.
> > > http://www.spinics.net/lists/linux-ext4/msg43287.html
> > >
> > > --D
> > >
> > >>
> > >> Secondly:
> > >>
> > >> Thanks for that git tree!  However, I discovered that the same "RCU bug" I
> > >> thought I was seeing on the Panda was also visible on the x86_64 KVM, and
> > >> it was actually just RCU noticing stalls.  These also occurred when using
> > >> your git tree as well as on mainline 3.15-rc1 and 3.15-rc2 and during
> > >> bisection attempts on 3.15-rc3 within the ext4 patches, and had the effect of
> > >> masking the regression on the root filesystem.  The test system would lock up
> > >> completely - no console response - and made it impossible to force the reboot
> > >> which was required to set up the failure.  Hence the reversion approach, since
> > >> RCU does not report stalls in 3.15-rc3 (final).
> > >>
> > >> Eric
> > >>
> > >>
> > >>
> > >> >
> > >> > Thanks!!
> > >> >
> > >> >                                             - Ted
> > >> --
> > >> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > >> the body of a message to majordomo@vger.kernel.org
> > >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> > 
> > -- 
> > Matteo Croce
> > OpenWrt Developer
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
