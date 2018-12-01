Return-Path: <SRS0=IALa=OK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47818 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726717AbeLBCwB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2018 21:52:01 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 018D32DBB4
        for <linux-ext4@vger.kernel.org>; Sat,  1 Dec 2018 15:39:13 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sat, 01 Dec 2018 15:39:13 +0000
Message-ID: <bug-201685-13602-IJqUwtL7sa@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #111 from Marc Koschewski (marc@osknowledge.org) ---
(In reply to Bart Van Assche from comment #110)
> (In reply to Marc Koschewski from comment #109)
> > Could it be hardware related like ie. blacklisted "trim" for ie. Samsung
> 850
> > Pro? Are the 4 machines absoutely equal hardware-wise (at least on the
> block
> > layer)? Maybe such a quirk is needed for just another device...
> 
> Marc, are you using an I/O scheduler? I'm not using an I/O scheduler:
> 
> $ cat /sys/block/sda/queue/scheduler 
> [none]

I do:

root@marc:~ # cat /sys/block/sda/queue/scheduler 
[mq-deadline] kyber bfq none

might be relevant as well:

root@marc:~ # cat /proc/cmdline 
BOOT_IMAGE=/vmlinuz-4.19.5loc64 root=/dev/sda7 ro init=/sbin/openrc-init
root=PARTUUID=6d19e60a-72a8-ee44-89f4-cc6f85a9436c real_root=/dev/sda7 ro
resume=PARTUUID=fbc25a25-2d09-634d-9e8b-67308f2feddf real_resume=/dev/sda8
acpi_osi=Linux libata.dma=3 libata.noacpi=0 threadirqs rootfstype=ext4
acpi_sleep=s3_bios,s3_beep devtmpfs.mount=0 net.ifnames=0 vmalloc=512M
noautogroup elevator=deadline libata.force=noncq nouveau.noaccel=0
nouveau.nofbaccel=1 nouveau.modeset=1 nouveau.runpm=0 nmi_watchdog=0
i915.modeset=0 cgroup_disable=memory scsi_mod.use_blk_mq=y dm_mod.use_blk_mq=y
vgacon.scrollback_persistent=1 processor.ignore_ppc=1 intel_iommu=off
crashkernel=128M apparmor=1 security=apparmor

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
