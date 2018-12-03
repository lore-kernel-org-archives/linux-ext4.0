Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54418 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725888AbeLCJYX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2018 04:24:23 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 63E462ADDF
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 09:24:10 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 09:24:09 +0000
Message-ID: <bug-201685-13602-ulJEXxOCuT@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #191 from Marc Burkhardt (marc@osknowledge.org) ---
(In reply to Eric Benoit from comment #185)
> (In reply to Guenter Roeck from comment #181)
> > #180: Eric, would you mind sharing the script used to create the files and
> > to read them back ?
> 
> Just a pair of trivial one-liners:
> 
> for i in {00000..13999}; do echo dd bs=1M count=64 if=/dev/urandom
> of=urand.$i; done
> 
> for i in urand.*; do echo dd bs=1M if=$i of=/dev/null; done | parallel -j8
> 
> I'm using /dev/urandom since I have lz4 compression enabled. I imagine
> /dev/zero would be just as effective if you don't.

Don't know if my comments are relevant as I got no reply as of now but here
some info regarding this test:

I ran it without errors on my /home partition wich is a dm-crypt ext4 setup
using the deadline mq-scheduler and the gcc 8 compiler branch. The partition is
mounted 

/dev/mapper/crypt-home    on  /home                                         
type  ext4       
(rw,nosuid,noatime,nodiratime,quota,usrquota,grpquota,errors=remount-ro)


[    0.000000] Linux version 4.19.6loc64 (marc@marc) (gcc version 8.2.0 (Gentoo
Hardened 8.2.0-r4 p1.5)) #1 SMP PREEMPT Sat Dec 1 16:00:21 CET 2018
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.19.6loc64 root=/dev/sda7 ro
init=/sbin/openrc-init root=PARTUUID=6d19e60a-72a8-ee44-89f4-cc6f85a9436c
real_root=/dev/sda7 ro resume=PARTUUID=fbc25a25-2d09-634d-9e8b-67308f2feddf
real_resume=/dev/sda8 acpi_osi=Linux libata.dma=3 libata.noacpi=0 threadirqs
rootfstype=ext4 acpi_sleep=s3_bios,s3_beep devtmpfs.mount=0 net.ifnames=0
vmalloc=512M noautogroup elevator=deadline libata.force=noncq nmi_watchdog=0
i915.modeset=0 cgroup_disable=memory scsi_mod.use_blk_mq=y dm_mod.use_blk_mq=y
vgacon.scrollback_persistent=1 processor.ignore_ppc=1 intel_iommu=igfx_off
crashkernel=128M apparmor=1 security=apparmor nouveau.noaccel=0
nouveau.nofbaccel=1 nouveau.modeset=1 nouveau.runpm=0
nouveau.debug=disp=trace,i2c=trace,bios=trace nouveau.config=NvPmShowAll=true
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel


Might be worth getting this guy aboard - got now reply though.

https://www.phoronix.com/forums/forum/software/general-linux-open-source/1063976-some-users-have-been-hitting-ext4-file-system-corruption-on-linux-4-19?p=1064826#post1064826

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
