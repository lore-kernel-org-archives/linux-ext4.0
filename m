From: Will Drewry <redpig@dataspill.org>
Subject: Re: [PATCH][RFC] resize2fs and uninit_bg questions
Date: Wed, 16 Sep 2009 18:11:31 -0500
Message-ID: <20090916231131.GC84213@freezingfog.local>
References: <20090916162457.GA84213@freezingfog.local> <20090916190831.GH2537@webber.adilger.int> <20090916204225.GB84213@freezingfog.local> <20090916212250.GL2537@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f186.google.com ([209.85.211.186]:64927 "EHLO
	mail-yw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313AbZIPXLb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Sep 2009 19:11:31 -0400
Received: by ywh16 with SMTP id 16so8330075ywh.13
        for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2009 16:11:35 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20090916212250.GL2537@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 16, 2009 at 03:22:50PM -0600, Andreas Dilger wrote:
> On Sep 16, 2009  15:42 -0500, Will Drewry wrote:
> > I'm interested in it for a few reasons:
> > 1. it undermines the use of uninit_bg on large filesystems as
> >    e2fsck -f will go back to normal speed, even without those block
> >    groups being 'used'.  In my local example, it goes from 14s to 2m24s.
> 
> Ah, my bad...  It definitely makes sense to mark new groups added
> during online resize as {BLOCK,INODE}_UNINIT if that feature is
> enabled for the filesystem.  The e2fsck slowdown after a resize is
> only a one-time event (that e2fsck would mark the unused groups as
> UNINIT again) but it makes sense to do it correctly the first time.

Cool - didn't realize e2fsck would swap them back.  That only makes
it seem like an even heavier burden if I know the backing store is
zero-filled! :)

> > 2. it will spread the I/O cost out over time.  Online resizing often
> >    means that you don't want to/can't unmount the fs.  However, a
> >    large filesystem increase might result in gigabytes of 0s being
> >    written to the backing store which could result in I/O throttling
> >    that makes doing it online less useful.  It'd be nice to be able to
> >    optionally amortize that cost as is done if the fs had been mke2fs -O
> >    lazy_itable_init=1 at full size initially.
> 
> While this is true, there is a non-zero risk of problems if the inode
> table isn't zeroed, which is why lazy_itable_init isn't the default.
> The risk is that if the group descriptor is invalid for some reason
> (found by bad checksum, or some inode in use beyond itable_unused)
> then the UNINIT and itable_unused fields will be ignored and a full
> inode table scan for that group is done.
> 
> If the itable isn't zeroed, then any old inodes (from a previous
> filesystem, or garbage) will be "reattached" to the filesystem in
> lost+found, and may cause a LOT of duplicate blocks processing (slow!).

That makes things a lot clearer - thanks! I wasn't sure what the default
action was, but it makes sense to assume that corruption would lead
you to crawl the inode table regardless.  In which case, your best bet
is to zero-fill it to minimize the weirdness.

> If you had the time to work on the solution, it would be very useful,
> and we could make lazy_itable_init the default.  What needs to be done
> is have a thread that is created at filesystem mount that walks all the
> groups and validates the GDT checksum, and zeroes inode tables and
> bitmaps that are marked UNINIT w/o ZEROED.  For bonus points it could
> check bitmap validity (later that might validate a bitmap checksum),
> compute buddy bitmaps for groups that have free space, etc.
> 
> The thread would exit once all of the groups have had the inode tables
> zeroed, or if the filesystem is unmounted.  In the common case (i.e.
> once all inode tables are zeroed), it would just walk the already-loaded
> group descriptor table looking for the ZEROED flag and no IO is done,
> assuming we don't check the on-disk bitmaps on each mount (that could
> be done only periodically, with a timestamp in the superblock).

I'd love to have this functionality so it's definitely going on my TODO
list, but probably not for a while yet.  This is a great description of
the needed code which will make it that much easier.

> > Would it seriously raise the risk of corruption if uninit_bg is already
> > in use? Alternately, would a patch to that effect stand a chance of ever
> > making it upstream?
> 
> If the filesystem is already formatted with lazy_itable_init, then
> doing further resizing w/o inode table zeroing is fine.

Cool -- I'll start in on a patch to setup to add that support as a
precursor to having a mount triggered itable zero'ing thread.  At least,
then test filesystems and known zero-filled ones will benefit (as you
pointed out!).

> 
> > I've attached a version with it being flagged by a "-l" for lazy.
> 
> It might make sense to avoid requiring the user to specify this,
> rather remembering the option supplied at mke2fs time?  There is
> the COMPAT_LAZY_BG superblock flag that might be usable for this,
> though Ted might have some comments about any potential compatibility
> issues.

Cool - yeah I'd love to make use of the COMPAT_LAZY_BG flag since it
seems that all (but e2p/features.c) references to it seem to be gone
from the e2fsprogs source and the kernel.  I'm happy to rewrite it to do
so and update mke2fs to set LAZY_BG when lazy_itable_init=1 is set.

> Other than that, the patch looks reasonable at first glance.

Thanks!  If Ted has any feedback on the use of COMPAT_LAZY_BG, I'll
rewrite it using that (or not).  Using COMPAT_LAZY_BG would also be nice
because it would make it easier to decide when it's okay to online resize
without initializing itables too (and would fit its initial purpose
of being useful for sparse files)!

cheers -
will
