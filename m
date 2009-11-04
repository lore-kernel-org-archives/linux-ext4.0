From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Corrupt superblocks
Date: Wed, 04 Nov 2009 13:21:14 -0600
Message-ID: <4AF1D42A.6000304@redhat.com>
References: <200911041939.57795.fabian-buettner@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: fabian-buettner@gmx.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295AbZKDTVL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Nov 2009 14:21:11 -0500
In-Reply-To: <200911041939.57795.fabian-buettner@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

fabian-buettner@gmx.de wrote:
> Hello,
> 
> After updating my gentoo machine (new udev, lvm2) and rebooting, my initrd was 
> broken (i had CONFIG_SYSFS_DEPRECATED and CONFIG_SYSFS_DEPRECATEDV2 activated) 
> and the new udev didn't like these settings.
> So I received a warning regarding this issue. Unfortunately I had set the init 
> bootparameter to init=/sbin/bootchartd. And when i was returning from getting 
> a cup of coffee. Bootchartd was spamming my console telling me: No space left 
> on the device (or similar). When i was seeing this i had instantly a VERY bad 
> feeling about what was going on there.
> 
> So i put in the rescuecd, chrooted into my old system, built a new kernel 
> without these deprecated options, rebooted again.
> 
> This time fsck.ext4 was telling me: No such file or directory while trying to 
> open /dev/vg/root, the superblock could not be read.

This looks more like a storage problem tnan an ext4 problem.

> That's the story how I managed to corrupt my superblock and probably also it's 
> backups.

Why do you say you have a corrupted superblock?

I suppose I'd try booting a live/rescue cd, and just manually run e2fsck
against your root device, as a starter - and capture any interesting output.

Any sort of kernel or fsck logs indicating more of what actually went
wrong would be Very helpful here.

-Eric

