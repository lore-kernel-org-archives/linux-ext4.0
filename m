From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15655] New: corrupt ext3 fs and partial freeze
Date: Tue, 30 Mar 2010 08:26:14 GMT
Message-ID: <bug-15655-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48091 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab0C3I0Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Mar 2010 04:26:16 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2U8QFKu007775
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 30 Mar 2010 08:26:15 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15655

           Summary: corrupt ext3 fs and partial freeze
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.34-rc2
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: prahal@yahoo.com
        Regression: Yes


Created an attachment (id=25762)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=25762)
kernel log (full)

Sorry it is against wireless-testing. I am not eager to test again or bisect :
the filesystem gets corrupted after a little while (it get the boot ok ... but
then later on I get this issue). And I already did 2 runs and it was close to
big lose on the second before switching back to 2.6.33 wireless-testing (I had
to use a live usb key and fsck with it ... a hundred of the groups were broken
already). I am developping/testing ralink wireless thus the tree.

It is really close to https://bugzilla.kernel.org/show_bug.cgi?id=15610 .
As far as I can tell the Tainted comes from the previous lockdep warning. As it
seems the dkms build of external modules did not happened.


[  575.960512] BUG: unable to handle kernel NULL pointer dereference at (null)
[  575.960536] IP: [<c0128d3f>] __wake_up_common+0x1f/0x70
[  575.960560] *pde = 00000000 
[  575.960571] Oops: 0000 [#2] SMP 
[  575.960585] last sysfs file:
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/PNP0C0A:00/power_supply/BAT0/charge_full
[  575.960599] Modules linked in: nfsd lockd nfs_acl auth_rpcgss sunrpc
exportfs ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
ppdev parport af_packet sco bridge stp bnep l2cap crc16 bluetooth ipx p8022
psnap llc p8023 ipv6 ipmi_devintf ipmi_si(+) ibmpex ipmi_msghandler
acpi_cpufreq cpufreq_conservative cpufreq_powersave cpufreq_userspace
cpufreq_ondemand cpufreq_stats freq_table binfmt_misc fuse tun uinput dm_crypt
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss
snd_pcm snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq
snd_timer eeepc_laptop snd_seq_device sparse_keymap uvcvideo snd rtc_cmos
tpm_tis rfkill psmouse rtc_core videodev soundcore tpm v4l1_compat joydev
led_class rng_core snd_page_alloc rtc_lib tpm_bios serio_raw ac evdev battery
processor pci_hotplug ext3 jbd mbcache dm_mod md_mod hid_logitech usbhid hid
usb_storage usb_libusual s
_mod ata_generic pata_acpi ata_piix libata uhci_hcd ehci_hcd atl1e scsi_mod
usbcore thermal fan i915 drm_kms_helper drm i2c_algo_bit button i2c_core
intel_agp agpgart video thermal_sys output fbcon tileblit font bitblit
softcursor [last unloaded: pciehp]
[  575.961030] 
[  575.961042] Pid: 7382, comm: dwww-build Tainted: G      D W 
2.6.34-rc2-wleeepc #25 1000H/1000H
[  575.961054] EIP: 0060:[<c0128d3f>] EFLAGS: 00010082 CPU: 0
[  575.961066] EIP is at __wake_up_common+0x1f/0x70
[  575.961075] EAX: c3ea0ec8 EBX: fffffff4 ECX: 00000001 EDX: 00000000
[  575.961084] ESI: 00000003 EDI: 00000292 EBP: e25d9d50 ESP: e25d9d34
[  575.961094]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  575.961106] Process dwww-build (pid: 7382, ti=e25d8000 task=e891e700
task.ti=e25d8000)
[  575.961115] Stack:
[  575.961122]  00000000 00000001 00000003 c012cb90 c3ea0ea4 00000003 00000292
e25d9d70
[  575.961152] <0> c012cbac 00000000 e25d9d7c 00000001 c05ac378 c0591780
00000084 e25d9d84
[  575.961186] <0> c0157a3e e25d9d7c c05ac378 00000003 e25d9d94 c0157a9c
c05ac10c c05ac10c
[  575.961222] Call Trace:
[  575.961238]  [<c012cb90>] ? __wake_up+0x20/0x60
[  575.961252]  [<c012cbac>] ? __wake_up+0x3c/0x60
[  575.961269]  [<c05ac378>] ? code_bytes_setup+0xb/0x26
[  575.961284]  [<c0157a3e>] ? __wake_up_bit+0x2e/0x30
[  575.961299]  [<c05ac378>] ? code_bytes_setup+0xb/0x26
[  575.961313]  [<c0157a9c>] ? wake_up_bit+0x5c/0x60
[  575.961327]  [<c05ac10c>] ? trap_init+0x27d/0x44c
[  575.961341]  [<c05ac10c>] ? trap_init+0x27d/0x44c
[  575.961356]  [<c020c265>] ? unlock_new_inode+0x95/0xc0
[  575.961370]  [<c05ac10c>] ? trap_init+0x27d/0x44c
[  575.961383]  [<c05ac10c>] ? trap_init+0x27d/0x44c
[  575.961432]  [<fa6fc9f3>] ? ext3_iget+0x273/0x440 [ext3]
[  575.961447]  [<c020a65c>] ? d_alloc+0xfc/0x180
[  575.961494]  [<fa702e87>] ? ext3_lookup+0x87/0x100 [ext3]
[  575.961510]  [<c03e9ea2>] ? _raw_spin_unlock+0x22/0x30
[  575.961524]  [<c020a682>] ? d_alloc+0x122/0x180
[  575.961553]  [<c0200e13>] ? do_lookup+0x163/0x1c0
[  575.961567]  [<c020305d>] ? link_path_walk+0x42d/0x9b0
[  575.961582]  [<c0203711>] ? path_walk+0x51/0xc0
[  575.961596]  [<c02037d9>] ? do_path_lookup+0x59/0x90
[  575.961611]  [<c02042e1>] ? user_path_at+0x41/0x80
[  575.961625]  [<c02a7c5b>] ? copy_to_user+0x3b/0x120
[  575.961642]  [<c01fc1ca>] ? vfs_fstatat+0x3a/0x70
[  575.961656]  [<c01fc260>] ? vfs_lstat+0x20/0x30
[  575.961671]  [<c01fc289>] ? sys_lstat64+0x19/0x30
[  575.961686]  [<c0192ad2>] ? audit_syscall_entry+0x1e2/0x210
[  575.961700]  [<c0102d8d>] ? sysenter_exit+0xf/0x1a
[  575.961714]  [<c0102d58>] ? sysenter_do_call+0x12/0x38
[  575.961724] Code: 1f 44 00 00 e8 53 ff ff ff 5d c3 90 55 89 e5 57 56 53 83
ec 10 0f 1f 44 00 00 89 55 ec 89 4d e8 8b 50 24 83 c0 24 8d 5a f4 39 d0 <8b> 73
0c 89 45 f0 74 3b 83 ee 0c eb 09 8d 74 26 00 89 f3 8d 70 
[  575.961911] EIP: [<c0128d3f>] __wake_up_common+0x1f/0x70 SS:ESP
0068:e25d9d34
[  575.961930] CR2: 0000000000000000
[  575.961942] ---[ end trace 28287be16bbcea07 ]---


[  575.967255] BUG: unable to handle kernel NULL pointer dereference at (null)
[  575.967278] IP: [<c0128d3f>] __wake_up_common+0x1f/0x70
[  575.967302] *pde = 00000000 
[  575.967314] Oops: 0000 [#3] SMP 
[  575.967327] last sysfs file:
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/PNP0C0A:00/power_supply/BAT0/charge_full
[  575.967339] Modules linked in: nfsd lockd nfs_acl auth_rpcgss sunrpc
exportfs ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
ppdev parport af_packet sco bridge stp bnep l2cap crc16 bluetooth ipx p8022
psnap llc p8023 ipv6 ipmi_devintf ipmi_si(+) ibmpex ipmi_msghandler
acpi_cpufreq cpufreq_conservative cpufreq_powersave cpufreq_userspace
cpufreq_ondemand cpufreq_stats freq_table binfmt_misc fuse tun uinput dm_crypt
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss
snd_pcm snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq
snd_timer eeepc_laptop snd_seq_device sparse_keymap uvcvideo snd rtc_cmos
tpm_tis rfkill psmouse rtc_core videodev soundcore tpm v4l1_compat joydev
led_class rng_core snd_page_alloc rtc_lib tpm_bios serio_raw ac evdev battery
processor pci_hotplug ext3 jbd mbcache dm_mod md_mod hid_logitech usbhid hid
usb_storage usb_libusual s
_mod ata_generic pata_acpi ata_piix libata uhci_hcd ehci_hcd atl1e scsi_mod
usbcore thermal fan i915 drm_kms_helper drm i2c_algo_bit button i2c_core
intel_agp agpgart video thermal_sys output fbcon tileblit font bitblit
softcursor [last unloaded: pciehp]
[  575.967792] 
[  575.967808] Pid: 6884, comm: run-parts Tainted: G      D W 
2.6.34-rc2-wleeepc #25 1000H/1000H
[  575.967820] EIP: 0060:[<c0128d3f>] EFLAGS: 00010086 CPU: 0
[  575.967834] EIP is at __wake_up_common+0x1f/0x70
[  575.967845] EAX: c3ea0e9c EBX: fffffff4 ECX: 00000001 EDX: 00000000
[  575.967856] ESI: 00000003 EDI: 00000292 EBP: e8981d50 ESP: e8981d34
[  575.967866]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  575.967876] Process run-parts (pid: 6884, ti=e8980000 task=ecbc19c0
task.ti=e8980000)
[  575.967884] Stack:
[  575.967891]  00000000 00000001 00000003 c012cb90 c3ea0e78 00000003 00000292
e8981d70
[  575.967923] <0> c012cbac 00000000 e8981d7c 00000001 c05ac718 c0591780
00000084 e8981d84
[  575.967955] <0> c0157a3e e8981d7c c05ac718 00000003 e8981d94 c0157a9c
c05ac4ac c05ac4ac
[  575.967994] Call Trace:
[  575.968011]  [<c012cb90>] ? __wake_up+0x20/0x60
[  575.968023]  [<c012cbac>] ? __wake_up+0x3c/0x60
[  575.968023]  [<c05ac718>] ? setup_arch+0x2be/0xaa1
[  575.968023]  [<c0157a3e>] ? __wake_up_bit+0x2e/0x30
[  575.968023]  [<c05ac718>] ? setup_arch+0x2be/0xaa1
[  575.968023]  [<c0157a9c>] ? wake_up_bit+0x5c/0x60
[  575.968023]  [<c05ac4ac>] ? setup_arch+0x52/0xaa1
[  575.968023]  [<c05ac4ac>] ? setup_arch+0x52/0xaa1
[  575.968023]  [<c020c265>] ? unlock_new_inode+0x95/0xc0
[  575.968023]  [<c05ac4ac>] ? setup_arch+0x52/0xaa1
[  575.968023]  [<c05ac4ac>] ? setup_arch+0x52/0xaa1
[  575.968132]  [<fa6fc9f3>] ? ext3_iget+0x273/0x440 [ext3]
[  575.968132]  [<c020a65c>] ? d_alloc+0xfc/0x180
[  575.968132]  [<fa702e87>] ? ext3_lookup+0x87/0x100 [ext3]
[  575.968132]  [<c03e9ea2>] ? _raw_spin_unlock+0x22/0x30
[  575.968132]  [<c020a682>] ? d_alloc+0x122/0x180
[  575.968132]  [<c0200e13>] ? do_lookup+0x163/0x1c0
[  575.968132]  [<c020305d>] ? link_path_walk+0x42d/0x9b0
[  575.968132]  [<c0203711>] ? path_walk+0x51/0xc0
[  575.968132]  [<c02037d9>] ? do_path_lookup+0x59/0x90
[  575.968132]  [<c02042e1>] ? user_path_at+0x41/0x80
[  575.968132]  [<c01dedfe>] ? handle_mm_fault+0x37e/0x860
[  575.968132]  [<c01dedfe>] ? handle_mm_fault+0x37e/0x860
[  575.968132]  [<c03e9481>] ? _raw_spin_lock+0x61/0x70
[  575.968132]  [<c01fc1ca>] ? vfs_fstatat+0x3a/0x70
[  575.968132]  [<c01fc320>] ? vfs_stat+0x20/0x30
[  575.968132]  [<c01fc349>] ? sys_stat64+0x19/0x30
[  575.968132]  [<c015cabb>] ? up_read+0x1b/0x30
[  575.968132]  [<c0192ad2>] ? audit_syscall_entry+0x1e2/0x210
[  575.968132]  [<c03ea0d6>] ? restore_all_notrace+0x0/0x18
[  575.968132]  [<c03ed060>] ? do_page_fault+0x0/0x3c0
[  575.968132]  [<c0102d58>] ? sysenter_do_call+0x12/0x38
[  575.968132] Code: 1f 44 00 00 e8 53 ff ff ff 5d c3 90 55 89 e5 57 56 53 83
ec 10 0f 1f 44 00 00 89 55 ec 89 4d e8 8b 50 24 83 c0 24 8d 5a f4 39 d0 <8b> 73
0c 89 45 f0 74 3b 83 ee 0c eb 09 8d 74 26 00 89 f3 8d 70 
[  575.968132] EIP: [<c0128d3f>] __wake_up_common+0x1f/0x70 SS:ESP
0068:e8981d34
[  575.968132] CR2: 0000000000000000
[  575.968579] ---[ end trace 28287be16bbcea08 ]--



I will get a second station up to test (with no real data). So I will be able
to bisect on it in a few days.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
