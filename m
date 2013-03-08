From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] mke2fs: restore verbose message for BLKDISCARD
Date: Fri, 8 Mar 2013 08:23:41 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1303080818510.24359@localhost>
References: <1362515118-30344-1-git-send-email-swarren@wwwdotorg.org> <alpine.LFD.2.00.1303060753500.24359@localhost> <5138EEBD.5000705@wwwdotorg.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-870823479-1362727424=:24359"
Cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>, Chris Ball <cjb@laptop.org>,
	linux-ext4@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932414Ab3CHHXt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Mar 2013 02:23:49 -0500
In-Reply-To: <5138EEBD.5000705@wwwdotorg.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-870823479-1362727424=:24359
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT

On Thu, 7 Mar 2013, Stephen Warren wrote:

> Date: Thu, 07 Mar 2013 12:47:09 -0700
> From: Stephen Warren <swarren@wwwdotorg.org>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Theodore Ts'o <tytso@mit.edu>, Chris Ball <cjb@laptop.org>,
>     linux-ext4@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
> Subject: Re: [PATCH] mke2fs: restore verbose message for BLKDISCARD
> 
> On 03/06/2013 12:13 AM, Lukáš Czerner wrote:
> > On Tue, 5 Mar 2013, Stephen Warren wrote:
> > 
> >> Date: Tue,  5 Mar 2013 13:25:18 -0700
> >> From: Stephen Warren <swarren@wwwdotorg.org>
> >> To: Theodore Ts'o <tytso@mit.edu>
> >> Cc: Chris Ball <cjb@laptop.org>, linux-ext4@vger.kernel.org,
> >>     Stephen Warren <swarren@nvidia.com>
> >> Subject: [PATCH] mke2fs: restore verbose message for BLKDISCARD
> >>
> >> From: Stephen Warren <swarren@nvidia.com>
> >>
> >> mke2fs on a large slow eMMC device may appear to hang while executing
> >> ioctl(BLKDISCARD). CTRL-C and CTRL-\ don't appear to respond, or respond
> >> extremely slowly. -v doesn't give any hints what's happening. Only strace
> >> is a clue. Make -v print some clues to make it easier to track down the
> >> apparent hang.
> >>
> >> This change re-uses the original messages that were implemented as part
> >> of 5827d24 "mke2fs support for BLKDISCARD" in order to easily re-use the
> >> translations of that message. Note that this patch prints the first
> >> message before executing the IOCTL, so the user is told what's going on
> >> before the long wait.
> >>
> >> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > 
> > Note that you've added the message only around the first 4k discard
> > which is only used to test whether the device actually support the
> > discard... which is not very useful and it can not even know whether
> > the whole device discard will succeed/fail so it is misleading.
> 
> Oops. I certainly should looked at the code better.
> 
> > Moreover there actually is a message saying that we're "Discarding
> > device blocks" and it even shows the progress. The step in which
> > we're doing the discard (and update the progress) is given by
> > DISCARD_STEP_MB = 2048MB. And all that in non verbose mode as well.
> 
> That said, it's that very first call to io_channel_discard() that is
> hanging then; I don't see the existing message at all. With my change, I
> do see the new message that I added. (So, no stdio flushing issue here).

It's just one fs block discard, are you sure about that ?

> 
> I will go investigate why this API is hanging. Sorry for the noise.
> 
> ...
> > As mentioned we're doing 2GB discard steps so the problem really
> > should not be on mkfs side. It is very much possible that the
> > discard implementation on the eMMC is terribly slow (which does not
> > surprise me). What is says about itself ?
> > 
> > grep . /sys/block/sda/queue/discard_*
> 
> /sys/block/mmcblk1/queue/discard_granularity
> 0
> /sys/block/mmcblk1/queue/discard_max_bytes
> 512

Here is your problem. Doing discard of 16GB (or even one step of
2GB) on the slow device such the eMMC certainly is just 512B at a
time is expected to be *really* slow!

If you want to check out how fast/slow it actually is you can issue
discard directly on the device using blkdiscard toos which should be
part of the very recent util linux (not sure if it has been released
yet, but you can try git repository).

-Lukas

> /sys/block/mmcblk1/queue/discard_zeroes_data
> 1
> 
> 
--8323328-870823479-1362727424=:24359--
