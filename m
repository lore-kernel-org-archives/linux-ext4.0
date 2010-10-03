From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16312] WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
Date: Sun, 3 Oct 2010 10:05:05 GMT
Message-ID: <201010031005.o93A55Jm020301@demeter1.kernel.org>
References: <bug-16312-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38688 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab0JCKFJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Oct 2010 06:05:09 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o93A565x020303
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 3 Oct 2010 10:05:07 GMT
In-Reply-To: <bug-16312-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16312


Bart Van Assche <bart.vanassche@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bart.vanassche@gmail.com




--- Comment #36 from Bart Van Assche <bart.vanassche@gmail.com>  2010-10-03 10:05:02 ---
What is the current status of this issue, and which of the attached patches
fixes this issue ? This still occurs with 2.6.35.7 when loading the kernel
module ib_srp:

------------[ cut here ]------------
WARNING: at fs/fs-writeback.c:951 __mark_inode_dirty+0x104/0x180()
Hardware name: P5Q DELUXE
Modules linked in: ib_srp scsi_transport_srp scsi_tgt netconsole configfs
snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device af_packet rdma_ucm rdma_cm
iw_cm ib_addr ib_ipoib ib_cm ib_sa ipv6 ib_uverbs ib_umad cpufreq_conservative
cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf mlx4_ib ib_mad ib_core
fuse loop dm_mod snd_hda_codec_atihdmi snd_hda_codec_analog snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm snd_timer snd mlx4_core sr_mod button i2c_i801
intel_agp soundcore snd_page_alloc serio_raw pcspkr i2c_core cdrom sg usbhid
hid uhci_hcd rtc_cmos rtc_core ehci_hcd rtc_lib sd_mod crc_t10dif usbcore edd
ext3 mbcache jbd fan ide_pci_generic ide_core ata_generic ata_piix pata_marvell
ahci libahci libata scsi_mod thermal processor thermal_sys hwmon [last
unloaded: ib_srp]
Pid: 3900, comm: blkid Not tainted 2.6.35.7 #1
Call Trace:
 [<ffffffff8104a81f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8104a87a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff8112f384>] __mark_inode_dirty+0x104/0x180
 [<ffffffff811232f5>] touch_atime+0x135/0x180
 [<ffffffff810c7f07>] generic_file_aio_read+0x2c7/0x6c0
 [<ffffffff8110ccfa>] do_sync_read+0xda/0x120
 [<ffffffff8103049a>] ? do_page_fault+0x18a/0x3d0
 [<ffffffff8111cb6d>] ? vfs_ioctl+0x3d/0xd0
 [<ffffffff8111cd28>] ? do_vfs_ioctl+0x88/0x540
 [<ffffffff8110d925>] vfs_read+0xb5/0x180
 [<ffffffff8110dae1>] sys_read+0x51/0x80
 [<ffffffff81002fdb>] system_call_fastpath+0x16/0x1b
---[ end trace d756b562ec21031e ]---
bdi-block not registered

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
