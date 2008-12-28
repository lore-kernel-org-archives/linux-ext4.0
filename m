From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Free blocks count wrong following shrink with resize2fs
Date: Sun, 28 Dec 2008 17:14:21 -0500
Message-ID: <20081228221421.GB15434@mit.edu>
References: <alpine.DEB.2.00.0812281047450.24239@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:43771 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756616AbYL1WRR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Dec 2008 17:17:17 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0812281047450.24239@bogon.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 28, 2008 at 11:00:11AM +0100, Christian Kujau wrote:
> Since I'm not *entirely* sure if this is related to the the extent header 
> issue[0], I thought I just report it:
>
> When shrinking a filesystem with resize2fs, fsck.ext4 (1.41.3,  
> 12-Oct-2008) reports:
>
> ------------
> Pass 5: Checking group summary information
> Block bitmap differences:  -(2488--2493) -(149959--151395)
> Fix<y>? yes
> Free blocks count wrong for group #0 (3188, counted=3194).
> Fix<y>? yes
> Free blocks count wrong for group #4 (10182, counted=11619).
> Fix<y>? yes
> Free blocks count wrong (26225, counted=27668).
> Fix<y>? yes
> -----------

It's a separate problem, but thanks, I know about it.  This one is
relatively harmless; it's caused by resize2fs assuming that the
metadata blocks for block group N are in block group N, which is not
true if flex_bg is enabled.  It's very much related to the bug which
causes resize2fs -M to not function correctly.

The net result is the blocks that should be released as being free
aren't, which is what causes the e2fsck errors, which can be easily
corrected.  It doesn't cause any other problems, though.

> PS: As my rootfs is also on ext4, I noticed another, completely unrelated oddity:
>
> [    1.604198] Using IPI Shortcut mode
> [    1.608394] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
> [    1.737198] EXT3-fs: hda1: couldn't mount because of unsupported optional features (240).
> [    1.754302] EXT4-fs: barriers enabled
> [    1.773267] kjournald2 starting.  Commit interval 5 seconds
>
> ...this is befor INIT starts, so who's trying to mount "/" as ext3 first?

This is normal; the kernel simply tries to mount the filesystem using
ext3 first, so that the ext4 code only gets used for filesystems that
enable the new ext4 features.  The kernel isn't particularly smart
about doing filesystem type detection; it simply tries to mount the
root filesystem using a ordered list of filesystem until one of them
works.

					- Ted
