From: Dave Chinner <david@fromorbit.com>
Subject: Re: Ideas on unified real-ro mount option across all filesystems
Date: Sun, 27 Dec 2015 09:53:55 +1100
Message-ID: <20151226225355.GV19802@dastard>
References: <567212DA.8050808@cn.fujitsu.com>
 <567228EF.80007@redhat.com>
 <87twn8vjgo.fsf@flamingspork.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Qu Wenruo <quwenruo@cn.fujitsu.com>,
	fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, btrfs <linux-btrfs@vger.kernel.org>,
	xfs@oss.sgi.com
To: Stewart Smith <stewart@flamingspork.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:44244 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277AbbLZWx7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Dec 2015 17:53:59 -0500
Content-Disposition: inline
In-Reply-To: <87twn8vjgo.fsf@flamingspork.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 24, 2015 at 10:22:31AM +1100, Stewart Smith wrote:
> Eric Sandeen <sandeen@redhat.com> writes:
> >> 3) A lot of user even don't now mount ro can still modify device
> >>    Yes, I didn't know this point until I checked the log replay code of
> >>    btrfs.
> >>    Adding such mount option alias may raise some attention of users.
> >
> > Given that nothing in the documentation implies that the block device itself
> > must remain unchanged on a read-only mount, I don't see any problem which
> > needs fixing.  MS_RDONLY rejects user IO; that's all.
> >
> > If you want to be sure your block device rejects all IO for forensics or
> > what have you, I'd suggest # blockdev --setro /dev/whatever prior to mount,
> > and take it out of the filesystem's control.  Or better yet, making an
> > image and not touching the original.
> 
> What we do for the petitboot bootloader in POWER and OpenPower firmware
> (a linux+initramfs that does kexec to boot) is that we use device mapper
> to make a snapshot in memory where we run recovery (for some
> filesystems, notably XFS is different due to journal not being endian
> safe). We also have to have an option *not* to do that, just in case
> there's a bug in journal replay... and we're lucky in the fact that we
> probably do have enough memory to complete replay, this solution could
> be completely impossible on lower memory machines.

Which means the boot loader is going to break horribly when we
change the on-disk format and feature flags the boot loader doesn't
understand get set in the root filesystem. Then the bootloader will
refuse to mount the filesystem and the system won't boot anymore...

IOWs, developers and users can't make a root XFS filesystem with a
new/experimental feature on POWER/OpenPower machines because the
bootloader will refuse to mount it regardless of the clean/dirty
state of the journal....

> As such, I believe we're the only bit of firmware/bootloader ever that
> has correctly parsed a journalling filesystem.

Nope.  The Irix bootloader (sash) could do this 20 years ago - there
are even feature mask bits reserved specifically for SASH in the XFS
superblock. However, seeing as the bootloader was always upgraded
during the install of each new Irix release, the bootloader was
always up-to-date with the on-disk features the kernel supported and
so there was never a problem with mismatched feature support.

However, Linux users can upgrade or change the kernel at any time
independently of the bootloader, so it's pretty much guaranteed that
mismatched bootloader/kernel filesystem capabilities will cause
users problems at some point in the not-too-distant future.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
