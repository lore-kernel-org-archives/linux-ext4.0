From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Wed, 30 Sep 2015 09:49:21 +0000
Message-ID: <bug-102731-13602-ThvJJxnjtl@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35241 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606AbbI3JtZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Sep 2015 05:49:25 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4DB362069D
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2015 09:49:24 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 31B1E20660
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2015 09:49:22 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #14 from John Hughes <john@calva.com> ---
On 28/09/15 19:06, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=102731
>
> --- Comment #13 from Theodore Tso <tytso@mit.edu> ---
> So it's been 12 days, and previously when you were using the Debian 3.16
> kernel, it was triggering once every four days, right?  Can I assume that your
> silence indicates that you haven't seen a problem to date?

I haven't seen the problem, but unfortunately I'm running 3.18.19 at the 
moment (I screwed up on the last boot and let it boot the default 
kernel).  I haven't had time to reboot.  So I'd like to give it a bit 
more time.
>
> If so, then it really does seen that it might be an interaction between LVM/MD
> and KVM.
>
> So if that's the case, then the next thing to ask is to try to figure out what
> might be the triggering cause.   A couple of things come to mind:
>
> 1) Some failure to properly handle a flush cache command being sent to the MD
> device.  This combined to either a power failure or a crash of the guest OS
> (depending on how KVM is configured), might explain a block update getting
> lost.   The fact that the block bitmap is out of sync with the block group
> descriptor is consistent with this failure.  However, if you were seeing
> failures once every four days, that would imply that the guest OS and/or host
> OS would be crashing at that or about that level of frequency, and you haven't
> reported that.

I haven't had any host or guest crashes.

>
> 2) Some kind a race between a 4k write and a RAID1 resync leading to a block
> write getting lost.  Again, this reported data corruption is consistent with
> this theory --- but this also requires the guest OS crashing due to some kind
> of kernel crash or KVM/qemu shutdown and/or host OS crash / power failure, as
> in (1) above.  If you weren't seeing these failures once every four days or so,
> then this isn't a likely explanation.

No crashes.

>
> 3)  Some kind of corruption caused by the TRIM command being sent to the
> RAID/MD device, possibly racing with a block bitmap update.  This could be
> caused either by the file system being mounted with the -o discard mount
> option, or by fstrim getting run out of cron, or by e2fsck explicitly being
> asked to discard unused blocks (with the "-E discard" option).

I'm not using "-o discard", or fstrim, I've never used the "-E discard" 
option to fsck.
>
> 4)  Some kind of bug which happens rarely either in qemu, the host kernel or
> the guest kernel depending on how it communicates with the virtual disk.
> (i.e., virtio, scsi, ide, etc.)   Virtio is the most likely use case, and so
> trying to change to use scsi emulation might be interesting.  (OTOH, if the
> problem is specific to the MD layer, then this possibility is less likely.)
>
> So as far as #3 is concerned, can you check to see if you had fstrim enabled,
> or are mounting the file system with -o discard?
>

I'm a bit overwhelmed with work at the moment so I haven't had time to 
read this message with the care it deserves, I'll get back to you with 
more detail next week.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
