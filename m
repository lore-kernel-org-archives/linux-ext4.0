From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 27652] 38-rc1: umount+rmmod cause ext4 error.
Date: Fri, 28 Jan 2011 06:01:11 GMT
Message-ID: <201101280601.p0S61Ben007804@demeter2.kernel.org>
References: <bug-27652-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:36597 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab1A1GBM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Jan 2011 01:01:12 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p0S61Bl6007819
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 28 Jan 2011 06:01:11 GMT
In-Reply-To: <bug-27652-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=27652


Tao Ma <tm@tao.ma> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tm@tao.ma




--- Comment #2 from Tao Ma <tm@tao.ma>  2011-01-28 06:01:10 ---
ok, so I have applied the 2 patches. And now I did hit another bug every time,
I have tried to revert these 2 patches. And it still show up every time. I use
38-rc2 now. So Maciej, is it necessary to open another bug for it?

BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
IP: [<ffffffff8233d343>] _raw_spin_lock_irqsave+0x11/0x22
PGD 12292c067 PUD 10fdb6067 PMD 0 
Oops: 0002 [#1] SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:19.0/irq
CPU 1 
Modules linked in: ext4(-) jbd2 ipv6 autofs4 hidp rfcomm l2cap crc16 bluetooth
rfkill ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue
configfs lockd sunrpc cpufreq_ondemand acpi_cpufreq dm_mirror video sbs sbshc
battery acpi_memhotplug ac lp sg snd_hda_codec_analog snd_hda_intel
snd_hda_codec snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm option usb_wwan usbserial
rtc_cmos tpm_tis snd_timer snd soundcore tpm pcspkr i2c_i801 parport_pc e1000e
serio_raw dcdbas shpchp rtc_core rtc_lib i2c_core parport snd_page_alloc button
tpm_bios dm_region_hash dm_log dm_mod usb_storage ahci libahci libata sd_mod
scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]

Pid: 4015, comm: rmmod Not tainted 2.6.38-rc2+ #30 0V4W66/OptiPlex 780          
RIP: 0010:[<ffffffff8233d343>]  [<ffffffff8233d343>]
_raw_spin_lock_irqsave+0x11/0x22
RSP: 0018:ffff88010fdbbe48  EFLAGS: 00010046
RAX: 0000000000000246 RBX: ffff88010fdbbe98 RCX: 00000000c0000100
RDX: 0000000000000100 RSI: ffff88010fdbbe98 RDI: 0000000000000020
RBP: ffff88010fdbbe48 R08: ffff88010fdba000 R09: ffff8800cfa0da70
R10: ffffffff82069498 R11: 0000000000000000 R12: 0000000000000020
R13: 0000000000000002 R14: 00007fffa52c5c60 R15: 0000000000000880
FS:  00007f7dd0d016e0(0000) GS:ffff8800cfa40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000020 CR3: 000000011dc48000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rmmod (pid: 4015, threadinfo ffff88010fdba000, task ffff88012271e180)
Stack:
 ffff88010fdbbe88 ffffffff82055ee2 ffffffff82069498 ffff88010fdbbe98
 ffff88010fdbbe98 ffffffffa04d8440 0000000000000880 00007fffa52c5c60
 ffff88010fdbbed8 ffffffffa04ca2cc 0000000000000000 ffff88012271e180
Call Trace:
 [<ffffffff82055ee2>] prepare_to_wait+0x25/0x7b
 [<ffffffff82069498>] ? __try_stop_module+0x0/0x3d
 [<ffffffffa04ca2cc>] ext4_exit_fs+0x94/0x112 [ext4]
 [<ffffffff82055cdf>] ? autoremove_wake_function+0x0/0x3d
 [<ffffffff82067bce>] sys_delete_module+0x1b5/0x218
 [<ffffffff8207506f>] ? audit_syscall_entry+0x187/0x1ba
 [<ffffffff82002a6b>] system_call_fastpath+0x16/0x1b
Code: 1f 44 00 00 b8 00 01 00 00 f0 66 0f c1 07 38 e0 74 06 f3 90 8a 07 eb f6
c9 c3 55 48 89 e5 0f 1f 44 00 00 9c 58 fa ba 00 01 00 00 <f0> 66 0f c1 17 38 f2
74 06 f3 90 8a 17 eb f6 c9 c3 55 48 89 e5 
RIP  [<ffffffff8233d343>] _raw_spin_lock_irqsave+0x11/0x22
 RSP <ffff88010fdbbe48>
CR2: 0000000000000020
---[ end trace ec9d834b678544aa ]---

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
