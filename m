From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: Re: ext4: journal has aborted
Date: Fri, 11 Jul 2014 03:29:09 +0400
Message-ID: <20140710232909.GJ4622@azat>
References: <20140704114031.2915161a@archvile>
 <87r421zavi.fsf@openvz.org>
 <20140704132802.0d43b1fc@archvile>
 <20140704122022.GC10514@thunk.org>
 <20140704154559.026331ec@archvile>
 <20140704184539.GA11103@thunk.org>
 <20140707141701.2f9529af@archvile>
 <20140707155310.GB8254@thunk.org>
 <20140707225619.GD8254@thunk.org>
 <20140710185748.GA26636@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, David Jander <david@protonic.nl>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Matteo Croce <technoboy85@gmail.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:58513 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaGJX3N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2014 19:29:13 -0400
Received: by mail-la0-f45.google.com with SMTP id ty20so160642lab.18
        for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2014 16:29:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140710185748.GA26636@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 10, 2014 at 02:57:48PM -0400, Eric Whitney wrote:
> * Theodore Ts'o <tytso@mit.edu>:
> > On Mon, Jul 07, 2014 at 11:53:10AM -0400, Theodore Ts'o wrote:
> > > An update from today's ext4 concall.  Eric Whitney can fairly reliably
> > > reproduce this on his Panda board with 3.15, and definitely not on
> > > 3.14.  So at this point there seems to be at least some kind of 3.15
> > > regression going on here, regardless of whether it's in the eMMC
> > > driver or the ext4 code.  (It also means that the bug fix I found is
> > > irrelevant for the purposes of working this issue, since that's a much
> > > harder to hit, and that bug has been around long before 3.14.)
> > > 
> > > The problem in terms of narrowing it down any further is that the
> > > Pandaboard is running into RCU bugs which makes it hard to test the
> > > early 3.15-rcX kernels.....
> > 
> > In the hopes of making it easy to bisect, I've created a kernel branch
> > which starts with 3.14, and then adds on all of the ext4-related
> > commits since then.   You can find it at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git test-mb_generate_buddy-failure
> > 
> > https://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/log/?h=test-mb_generate_buddy-failure
> > 
> > Eric, can you see if you can repro the failure on your Panda Board?
> > If you can, try doing a bisection search on these series:
> > 
> > git bisect start
> > git bisect good v3.14
> > git bisect bad test-mb_generate_buddy-failure
> > 
> > Hopefully if it is caused by one of the commits in this series, we'll
> > be able to pin point it this way.
> 
> First, the good news (with luck):
> 
> My testing currently suggests that the patch causing this regression was
> pulled into 3.15-rc3 -
> 
> 007649375f6af242d5b1df2c15996949714303ba
> ext4: initialize multi-block allocator before checking block descriptors
> 
> Bisection by selectively reverting ext4 commits in -rc3 identified this patch
> while running on the Pandaboard.  I'm still using generic/068 as my reproducer.
> It occasionally yields a false negative, but it has passed 10 consecutive
> trials on my revert/bisect kernel derived from 3.15-rc3.  Given the frequency
> of false negatives I've seen, I'm reasonably confident in that result.  I'm
> going to run another series with just that patch reverted on 3.16-rc3.
> 
> Looking at the patch, the call to ext4_mb_init() was hoisted above the code
> performing journal recovery in ext4_fill_super().  The regression occurs only
> after journal recovery on the root filesystem.

Oops, nice catch!

I'm very sorry for this. When this problems begun, I rechecked my patch,
but didn't found this. (I should test more next time!)
But I don't understand why this triggers only on the root fs?

It will be greate if ext4 will have an BUG_ON() for this case, to avoid
futher bugs, something like this:
$ git di fs/ext4/mballoc.c
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 59e3162..8dfc999 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -832,6 +832,8 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 
        inode = page->mapping->host;
        sb = inode->i_sb;
+       BUG_ON((EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER));
+
        ngroups = ext4_get_groups_count(sb);
        blocksize = 1 << inode->i_blkbits;
        blocks_per_page = PAGE_CACHE_SIZE / blocksize;

Thanks, and please accept my apologies those, who have got corrupted fs.

> 
> Secondly:
> 
> Thanks for that git tree!  However, I discovered that the same "RCU bug" I
> thought I was seeing on the Panda was also visible on the x86_64 KVM, and
> it was actually just RCU noticing stalls.  These also occurred when using
> your git tree as well as on mainline 3.15-rc1 and 3.15-rc2 and during
> bisection attempts on 3.15-rc3 within the ext4 patches, and had the effect of
> masking the regression on the root filesystem.  The test system would lock up
> completely - no console response - and made it impossible to force the reboot
> which was required to set up the failure.  Hence the reversion approach, since
> RCU does not report stalls in 3.15-rc3 (final).
> 
> Eric
> 
> 
> 
> > 
> > Thanks!!
> > 
> > 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
