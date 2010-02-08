From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.33-rc6 crashes on resume
Date: Tue, 9 Feb 2010 00:16:17 +0100
Message-ID: <201002090016.18027.rjw@sisk.pl>
References: <4B70982F.8090208@roadwarrior3.tmr.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	pm list <linux-pm@lists.linux-foundation.org>,
	Tejun Heo <htejun@gmail.com>, linux-ext4@vger.kernel.org
To: davidsen@tmr.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:60522 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab0BHXPh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Feb 2010 18:15:37 -0500
In-Reply-To: <4B70982F.8090208@roadwarrior3.tmr.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday 09 February 2010, Bill Davidsen wrote:
> Pretty simple to reproduce, boot, suspend, press shift
> 
> Acer Aspire 1681, Celeron, 2.6.33-rc6. Trace and config attached.

This looks suspicious:

Feb  8 17:32:47 roadwarrior3 kernel: ata2.00: ACPI cmd 03/42:00:00:00:a0:ef (CFA REQUEST EXTENDED ERROR) rejected by device (Stat=0x51 Err=0x04)
Feb  8 17:32:47 roadwarrior3 kernel: sd 0:0:0:0: [sda] Starting disk
Feb  8 17:32:47 roadwarrior3 kernel: ata2.00: ACPI cmd 00/0c:00:00:00:a0:ef (NOP) rejected by device (Stat=0x51 Err=0x04)
Feb  8 17:32:47 roadwarrior3 kernel: ata2.00: configured for UDMA/33
Feb  8 17:32:47 roadwarrior3 kernel: firewire_core: rediscovered device fw0
Feb  8 17:32:47 roadwarrior3 kernel: ata1.00: ACPI cmd 03/45:00:00:00:a0:ef (CFA REQUEST EXTENDED ERROR) rejected by device (Stat=0x51 Err=0x04)
Feb  8 17:32:47 roadwarrior3 kernel: ata1.00: ACPI cmd 00/0c:00:00:00:a0:ef (NOP) rejected by device (Stat=0x51 Err=0x04)
Feb  8 17:32:47 roadwarrior3 kernel: ata1.00: configured for UDMA/100

And the crash actually happens _after_ resume:

Feb  8 17:32:47 roadwarrior3 kernel: PM: resume of devices complete after 1977.587 msecs
Feb  8 17:32:47 roadwarrior3 kernel: Restarting tasks ... done.
Feb  8 17:32:47 roadwarrior3 kernel: hub 2-0:1.0: over-current change on port 1
Feb  8 17:32:47 roadwarrior3 kernel: hub 2-0:1.0: over-current change on port 2
Feb  8 17:32:47 roadwarrior3 kernel: BUG: unable to handle kernel paging request at f72fd5a0
Feb  8 17:32:47 roadwarrior3 kernel: IP: [<c0552c43>] ext4_xattr_get+0xa0/0x232
Feb  8 17:32:47 roadwarrior3 kernel: *pde = 00007067 *pte = 00000000 
Feb  8 17:32:47 roadwarrior3 kernel: Oops: 0000 [#1] SMP 
Feb  8 17:32:47 roadwarrior3 kernel: last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
Feb  8 17:32:47 roadwarrior3 kernel: Modules linked in: nfs lockd fscache nfs_acl auth_rpcgss aes_generic lib80211_crypt_ccmp fuse sunrpc cpufreq_ondemand acpi_cpufreq ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 ext2 uinput snd_intel8x0 snd_intel8x0m snd_ac97_codec ac97_bus snd_seq snd_seq_device ipw2200 snd_pcm libipw sbs cfg80211 b44 snd_timer ssb sbshc snd rfkill serio_raw tifm_7xx1 iTCO_wdt mii tifm_core lib80211 soundcore joydev iTCO_vendor_support i2c_i801 snd_page_alloc dm_multipath firewire_ohci firewire_core yenta_socket crc_itu_t rsrc_nonstatic video output radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
Feb  8 17:32:47 roadwarrior3 kernel:
Feb  8 17:32:47 roadwarrior3 kernel: Pid: 2396, comm: atd Not tainted 2.6.33-rc6 #1 Aspire 1680   /Aspire 1680   
Feb  8 17:32:47 roadwarrior3 kernel: EIP: 0060:[<c0552c43>] EFLAGS: 00010286 CPU: 0
Feb  8 17:32:47 roadwarrior3 kernel: EIP is at ext4_xattr_get+0xa0/0x232
Feb  8 17:32:47 roadwarrior3 kernel: EAX: c1d82400 EBX: f72fd5a0 ECX: f72fd5a0 EDX: f72fd600
Feb  8 17:32:47 roadwarrior3 kernel: ESI: 00000000 EDI: f6a6c2f8 EBP: f5c51e08 ESP: f5c51dc8
Feb  8 17:32:47 roadwarrior3 kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Feb  8 17:32:47 roadwarrior3 kernel: Process atd (pid: 2396, ti=f5c50000 task=f39a7230 task.ti=f5c50000)
Feb  8 17:32:47 roadwarrior3 kernel: Stack:
Feb  8 17:32:47 roadwarrior3 kernel: f6a6c2f8 c2be22a0 00000163 00000007 c08b2bc1 00000006 f6a6c2c8 f6a6c270
Feb  8 17:32:47 roadwarrior3 kernel: <0> f72fd59c f69ea900 00000500 00000008 f72fd5a0 c08b2bc1 c1838bb0 f5c51e5c
Feb  8 17:32:47 roadwarrior3 kernel: <0> f5c51e24 c0553bb0 f5c51e5c 00000014 c08b2bc1 c097807c c08b2bb8 f5c51e48
Feb  8 17:32:47 roadwarrior3 kernel: Call Trace:
Feb  8 17:32:47 roadwarrior3 kernel: [<c0553bb0>] ? ext4_xattr_security_get+0x39/0x47
Feb  8 17:32:47 roadwarrior3 kernel: [<c04e496e>] ? generic_getxattr+0x66/0x6a
Feb  8 17:32:47 roadwarrior3 kernel: [<c04e4908>] ? generic_getxattr+0x0/0x6a
Feb  8 17:32:47 roadwarrior3 kernel: [<c057376f>] ? get_vfs_caps_from_disk+0x45/0xcb
Feb  8 17:32:47 roadwarrior3 kernel: [<c057e984>] ? selinux_capable+0xb1/0xf6
Feb  8 17:32:47 roadwarrior3 kernel: [<c0573881>] ? cap_bprm_set_creds+0x8c/0x2f9
Feb  8 17:32:47 roadwarrior3 kernel: [<c057e673>] ? selinux_bprm_set_creds+0x31/0x20d
Feb  8 17:32:47 roadwarrior3 kernel: [<c04b795a>] ? __vma_link+0x5d/0x61
Feb  8 17:32:47 roadwarrior3 kernel: [<c04b79b6>] ? vma_link+0x58/0x77
Feb  8 17:32:47 roadwarrior3 kernel: [<c04b7a8c>] ? insert_vm_struct+0xb7/0xca
Feb  8 17:32:47 roadwarrior3 kernel: [<c0573ccb>] ? security_bprm_set_creds+0x11/0x13
Feb  8 17:32:47 roadwarrior3 kernel: [<c04d46d2>] ? prepare_binprm+0xbd/0xf4
Feb  8 17:32:47 roadwarrior3 kernel: [<c04d37b6>] ? count+0x34/0x6f
Feb  8 17:32:47 roadwarrior3 kernel: [<c04d4ca8>] ? do_execve+0x132/0x270
Feb  8 17:32:47 roadwarrior3 kernel: [<c04091f0>] ? sys_execve+0x30/0x58
Feb  8 17:32:47 roadwarrior3 kernel: [<c040346e>] ? ptregs_execve+0x12/0x18
Feb  8 17:32:47 roadwarrior3 kernel: [<c040339f>] ? sysenter_do_call+0x12/0x28
Feb  8 17:32:47 roadwarrior3 kernel: Code: d9 89 5d f0 8b 87 a4 00 00 00 8b 80 84 01 00 00 03 50 64 eb 16 0f b6 01 83 c0 13 83 e0 fc 01 c1 39 d1 72 07 be fb ff ff ff eb 34 <83> 39 00 75 e5 e9 26 01 00 00 8b 45 f0 83 7d 08 00 8b 58 08 74 
Feb  8 17:32:47 roadwarrior3 kernel: EIP: [<c0552c43>] ext4_xattr_get+0xa0/0x232 SS:ESP 0068:f5c51dc8
Feb  8 17:32:47 roadwarrior3 kernel: CR2: 00000000f72fd5a0
Feb  8 17:32:47 roadwarrior3 kernel: ---[ end trace b43953454f125bbd ]---

Any chance to use gdb for identifying the code at ext4_xattr_get+0xa0?

Rafael
