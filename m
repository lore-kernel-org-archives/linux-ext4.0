From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: ext4: journal has aborted
Date: Thu, 3 Jul 2014 13:14:34 -0400
Message-ID: <20140703171434.GA15790@wallace>
References: <CAFnufp3TepsxxX8=WCJ0V=3TELP0rWR-NxFukSL8X=qS1q6Eew@mail.gmail.com>
 <20140701082619.1ac77f1d@archvile>
 <20140701084206.GG9743@birch.djwong.org>
 <53B2A47F.90903@samsung.com>
 <20140701155812.GD2775@thunk.org>
 <20140701163646.GA3126@wallace>
 <20140702121752.37e1f181@archvile>
 <CAFnufp0Fm8F=qu87R5LiOAunc_2axk4+g9J4euOjaCcNak0MnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Jander <david@protonic.nl>,
	Eric Whitney <enwlinux@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Jaehoon Chung <jh80.chung@samsung.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: Matteo Croce <technoboy85@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:49032 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbaGCROi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Jul 2014 13:14:38 -0400
Received: by mail-qa0-f50.google.com with SMTP id m5so435744qaj.23
        for <linux-ext4@vger.kernel.org>; Thu, 03 Jul 2014 10:14:37 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAFnufp0Fm8F=qu87R5LiOAunc_2axk4+g9J4euOjaCcNak0MnQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Matteo Croce <technoboy85@gmail.com>:
> 2014-07-02 12:17 GMT+02:00 David Jander <david@protonic.nl>:
> >
> > Hi Eric,
> >
> > On Tue, 1 Jul 2014 12:36:46 -0400
> > Eric Whitney <enwlinux@gmail.com> wrote:
> >
> >> * Theodore Ts'o <tytso@mit.edu>:
> >> > On Tue, Jul 01, 2014 at 09:07:27PM +0900, Jaehoon Chung wrote:
> >> > > Hi,
> >> > >
> >> > > i have interesting for this problem..Because i also found the same problem..
> >> > > Is it Journal problem?
> >> > >
> >> > > I used the Linux version 3.16.0-rc3.
> >> > >
> >> > > [    3.866449] EXT4-fs error (device mmcblk0p13): ext4_mb_generate_buddy:756: group 0, 20490 clusters in bitmap, 20488 in gd; block bitmap corrupt.
> >> > > [    3.877937] Aborting journal on device mmcblk0p13-8.
> >> > > [    3.885025] Kernel panic - not syncing: EXT4-fs (device mmcblk0p13): panic forced after error
> >> >
> >> > This message means that the file system has detected an inconsistency
> >> > --- specifically, that the number of blocks marked as in use in the
> >> > allocation bbitmap is different from what is in the block group
> >> > descriptors.
> >> >
> >> > The file system has been marked to force a panic after an error, at
> >> > which point e2fsck will be able to repair the inconsistency.
> >> >
> >> > What's not clear is *how* the why this happened.  It can happen simply
> >> > because of a hardware problem.  (In particular, not all mmc flash
> >> > devices handle power failures gracefully.)  Or it could be a cosmic,
> >> > ray, or it might be a kernel bug.
> >> >
> >> > Normally I would chalk this up to a hardware bug, bug it's possible
> >> > that it is a kernel bug.  If people can reliably reproduce the problem
> >> > where no power failures or other unclean shutdowns were involved
> >> > (since the last time file system has been checked using e2fsck) then
> >> > that would be realy interesting.
> >>
> >> Hi Ted:
> >>
> >> I saw a similar failure during 3.16-rc3 (plus ext4 stable fixes plus msync
> >> patch) regression on the Pandaboard this morning.  A generic/068 hang
> >> on data_journal required a reboot for recovery (old bug, though rarer lately).
> >> On reboot, the root filesystem - default 4K, and on an SD card - went ro
> >> after the same sort of bad block bitmap / journal abort sequence.  Rebooting
> >> forced a fsck that cleared up the problem.  The target test filesystem was on
> >> a USB-attached disk, and it did not exhibit the same problems on recovery.
> >
> > Please be careful about conclusions from regular SD cards and USB sticks for
> > mass-storage. Unlike hardened eMMC (4.41+), these COTS mass-storage devices
> > are not meant for intensive use and can perfectly easily corrupt data out of
> > themselves. I've seen it happening many times already.
> >
> >> So, it looks like there might be more than just hardware involved here,
> >> although eMMC/flash might be a common denominator.  I'll see if I can come up
> >> with a reliable reproducer once the regression pass is finished if someone
> >> doesn't beat me to it.

I've not found a reproducer that doesn't involve an unclean shutdown, which
is what Ted's looking for.

However, I've noted a behavioral change that might be of interest with
the failure scenario described above using xfstests generic/068 that
occurred between 3.14 and 3.15-rc3.  It's possible that this change would
make filesystem damage caused by an unclean shutdown more likely or more
noticable, and perhaps it's in play for the power fail/cycle cases
described in this thread.

FWIW, I've also been able to reproduce that failure scenario on an x86_64 KVM
with raw virtio disks alone.  It's just a lot harder to get there with that
configuration - many more trials required.

The change is that the root filesystem sustains damage reported as -

EXT4-fs error (device mmcblk0p3): ext4_mb_generate_buddy:757: group 65, 1243 clusters in bitmap, 1244 in gd; block bitmap corrupt.
Aborting journal on device mmcblk0p3-8.
EXT4-fs error (device mmcblk0p3): ext4_journal_check_start:56: Detected aborted journal
EXT4-fs (mmcblk0p3): Remounting filesystem read-only

- when generic/068 is run on a separate test filesystem that forces an ext4
failure requiring a power cycle / reset to recover from a hung reboot attempt.
This doesn't happen in 3.14 on either my x86_64 or ARM test systems.
Generally, the root filesystem doesn't appear to be affected at all or is
minimally affected (does not require fsck to fully recover) in 3.14, whereas
a fsck is usually required to recover the root in 3.15-rc3.

My attempts to bisect further into 3.15-rc1 to 3.15-rc3 haven't gone well as
yet - other kernel problems are making it difficult to work in there.

Eric


> >
> > I agree that there is a strong correlation towards flash-based storage, but I
> > cannot explain why this factor would make a difference. How are flash-based
> > block-devices different to ext4 than spinning-disk media (besides trim
> > support)?
> 
> maybe the zero access time can trigger some race condition?
> 
> > Best regards,
> >
> > --
> > David Jander
> > Protonic Holland.
> 
> 
> 
> -- 
> Matteo Croce
> OpenWrt Developer
