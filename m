From: Matteo Croce <technoboy85@gmail.com>
Subject: Re: ext4: journal has aborted
Date: Wed, 2 Jul 2014 12:19:35 +0200
Message-ID: <CAFnufp0Fm8F=qu87R5LiOAunc_2axk4+g9J4euOjaCcNak0MnQ@mail.gmail.com>
References: <CAFnufp3TepsxxX8=WCJ0V=3TELP0rWR-NxFukSL8X=qS1q6Eew@mail.gmail.com>
 <20140701082619.1ac77f1d@archvile> <20140701084206.GG9743@birch.djwong.org>
 <53B2A47F.90903@samsung.com> <20140701155812.GD2775@thunk.org>
 <20140701163646.GA3126@wallace> <20140702121752.37e1f181@archvile>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Eric Whitney <enwlinux@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Jaehoon Chung <jh80.chung@samsung.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: David Jander <david@protonic.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:60560 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbaGBKUP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jul 2014 06:20:15 -0400
Received: by mail-ob0-f180.google.com with SMTP id vb8so11793490obc.25
        for <linux-ext4@vger.kernel.org>; Wed, 02 Jul 2014 03:20:15 -0700 (PDT)
In-Reply-To: <20140702121752.37e1f181@archvile>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2014-07-02 12:17 GMT+02:00 David Jander <david@protonic.nl>:
>
> Hi Eric,
>
> On Tue, 1 Jul 2014 12:36:46 -0400
> Eric Whitney <enwlinux@gmail.com> wrote:
>
>> * Theodore Ts'o <tytso@mit.edu>:
>> > On Tue, Jul 01, 2014 at 09:07:27PM +0900, Jaehoon Chung wrote:
>> > > Hi,
>> > >
>> > > i have interesting for this problem..Because i also found the same problem..
>> > > Is it Journal problem?
>> > >
>> > > I used the Linux version 3.16.0-rc3.
>> > >
>> > > [    3.866449] EXT4-fs error (device mmcblk0p13): ext4_mb_generate_buddy:756: group 0, 20490 clusters in bitmap, 20488 in gd; block bitmap corrupt.
>> > > [    3.877937] Aborting journal on device mmcblk0p13-8.
>> > > [    3.885025] Kernel panic - not syncing: EXT4-fs (device mmcblk0p13): panic forced after error
>> >
>> > This message means that the file system has detected an inconsistency
>> > --- specifically, that the number of blocks marked as in use in the
>> > allocation bbitmap is different from what is in the block group
>> > descriptors.
>> >
>> > The file system has been marked to force a panic after an error, at
>> > which point e2fsck will be able to repair the inconsistency.
>> >
>> > What's not clear is *how* the why this happened.  It can happen simply
>> > because of a hardware problem.  (In particular, not all mmc flash
>> > devices handle power failures gracefully.)  Or it could be a cosmic,
>> > ray, or it might be a kernel bug.
>> >
>> > Normally I would chalk this up to a hardware bug, bug it's possible
>> > that it is a kernel bug.  If people can reliably reproduce the problem
>> > where no power failures or other unclean shutdowns were involved
>> > (since the last time file system has been checked using e2fsck) then
>> > that would be realy interesting.
>>
>> Hi Ted:
>>
>> I saw a similar failure during 3.16-rc3 (plus ext4 stable fixes plus msync
>> patch) regression on the Pandaboard this morning.  A generic/068 hang
>> on data_journal required a reboot for recovery (old bug, though rarer lately).
>> On reboot, the root filesystem - default 4K, and on an SD card - went ro
>> after the same sort of bad block bitmap / journal abort sequence.  Rebooting
>> forced a fsck that cleared up the problem.  The target test filesystem was on
>> a USB-attached disk, and it did not exhibit the same problems on recovery.
>
> Please be careful about conclusions from regular SD cards and USB sticks for
> mass-storage. Unlike hardened eMMC (4.41+), these COTS mass-storage devices
> are not meant for intensive use and can perfectly easily corrupt data out of
> themselves. I've seen it happening many times already.
>
>> So, it looks like there might be more than just hardware involved here,
>> although eMMC/flash might be a common denominator.  I'll see if I can come up
>> with a reliable reproducer once the regression pass is finished if someone
>> doesn't beat me to it.
>
> I agree that there is a strong correlation towards flash-based storage, but I
> cannot explain why this factor would make a difference. How are flash-based
> block-devices different to ext4 than spinning-disk media (besides trim
> support)?

maybe the zero access time can trigger some race condition?

> Best regards,
>
> --
> David Jander
> Protonic Holland.



-- 
Matteo Croce
OpenWrt Developer
