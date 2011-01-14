From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 26752] New: NPD when using sb->s_fs_info during clean-up after
 a failed mount
Date: Fri, 14 Jan 2011 22:31:59 GMT
Message-ID: <bug-26752-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:55219 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab1ANWcA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Jan 2011 17:32:00 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p0EMVx6C027546
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 14 Jan 2011 22:31:59 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=26752

           Summary: NPD when using sb->s_fs_info during clean-up after a
                    failed mount
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.37
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: dame_eugene@mail.ru
        Regression: No


When ext4_mb_init() fails during mount operation (for example, if one of the
calls to kmalloc returns NULL), s_fs_info field of the superblock structure is
set to NULL. However, this field is dereferenced later when cleaning up, which
results in an oops in ext4_sync_fs().

I have tested this for mainline kernel from git (commit e9688f6 of January 11,
2011, i.e. post-2.6.37). When attempting to mount a loop device attached to a
file with ext4 filesystem in it, the following call to kmalloc() returned NULL
(fs/ext4/mballoc.c:2437):

    i = (sb->s_blocksize_bits + 2) * sizeof(*sbi->s_mb_maxs);
    sbi->s_mb_maxs = kmalloc(i, GFP_KERNEL);

ext4_mb_init() returns -ENOMEM as it should, and at the end of
ext4_fill_super() s_fs_info field of the corresponding struct super_block
instance is set to NULL (fs/ext4/super.c:3686):

out_fail:
    sb->s_fs_info = NULL;

But after that, there is an attempt to dereference sb->s_fs_info in
ext4_sync_fs(), for example (fs/ext4/super.c:4123):

    struct ext4_sb_info *sbi = EXT4_SB(sb);
    ...
    flush_workqueue(sbi->dio_unwritten_wq);

'sbi' is NULL in the last statement in this case.

This is how the result looks in the system log:
---------------------
[  817.573625] EXT4-fs (loop0): failed to initialize mballoc (-12)
[  817.573627] EXT4-fs (loop0): mount failed
[  817.573985] BUG: unable to handle kernel NULL pointer dereference at
0000021c
[  817.573988] IP: [<f8a25db3>] ext4_sync_fs+0x23/0xb0 [ext4]
[  817.574006] *pde = 00000000 
[  817.574007] Oops: 0000 [#1] SMP 
[  817.574009] last sysfs file:
/sys/devices/virtual/block/loop0/queue/hw_sector_size
[  817.574012] Modules linked in: fuse ext4 jbd2 crc16 kedr_controller
kedr_indicator_caller kedr_fsim_capable kedr_fsim_user_space_access
kedr_fsim_custom kedr_fault_simulation kedr_base snd_pcm_oss snd_mixer_oss
snd_seq snd_seq_device edd af_packet mperf loop dm_mod ppdev snd_intel8x0
snd_ac97_codec ac97_bus snd_pcm parport_pc parport snd_timer e1000 snd ac
sr_mod sg cdrom soundcore i2c_piix4 button snd_page_alloc pcspkr ohci_hcd
ehci_hcd rtc_cmos rtc_core rtc_lib sd_mod usbcore fan processor ata_generic
ata_piix thermal thermal_sys hwmon ahci libahci libata scsi_mod [last unloaded:
speedstep_lib]
[  817.574043] 
[  817.574049] Pid: 6093, comm: mount Not tainted 2.6.37-testbox+ #1
/VirtualBox
[  817.574051] EIP: 0060:[<f8a25db3>] EFLAGS: 00010246 CPU: 1
[  817.574057] EIP is at ext4_sync_fs+0x23/0xb0 [ext4]
[  817.574059] EAX: f64f9600 EBX: 00000000 ECX: f8a25d90 EDX: 00000000
[  817.574060] ESI: f64f9600 EDI: 00000000 EBP: e5fbde3c ESP: e5fbde24
[  817.574062]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  817.574064] Process mount (pid: 6093, ti=e5fbc000 task=f64364f0
task.ti=e5fbc000)
[  817.574065] Stack:
[  817.574066]  f64f9600 00000000 c033a2e0 f64f9600 00000000 c033a2e0 e5fbde50
c031daad
[  817.574070]  f64f9600 00000003 f8a47460 e5fbde5c c031db21 f64f9600 e5fbde78
c02fc169
[  817.574074]  e5fbde90 c03490c7 f413d680 00000003 ffffffea e5fbde88 c02fc235
f64f9600
[  817.574078] Call Trace:
[  817.574083]  [<c033a2e0>] ? dquot_quota_sync+0x0/0x2c0
[  817.574086]  [<c033a2e0>] ? dquot_quota_sync+0x0/0x2c0
[  817.574088]  [<c031daad>] __sync_filesystem+0x5d/0x90
[  817.574090]  [<c031db21>] sync_filesystem+0x21/0x50
[  817.574093]  [<c02fc169>] generic_shutdown_super+0x29/0xd0
[  817.574096]  [<c03490c7>] ? disk_name+0xb7/0xd0
[  817.574098]  [<c02fc235>] kill_block_super+0x25/0x40
[  817.574101]  [<c02fc4a5>] deactivate_locked_super+0x35/0x50
[  817.574103]  [<c02fcf10>] mount_bdev+0x190/0x1b0
[  817.574109]  [<f8a24e9a>] ext4_mount+0x1a/0x20 [ext4]
[  817.574116]  [<f8a2d390>] ? ext4_fill_super+0x0/0x2af0 [ext4]
[  817.574118]  [<c02fc6c0>] vfs_kern_mount+0x70/0x230
[  817.574121]  [<c031160e>] ? get_fs_type+0x2e/0xb0
[  817.574127]  [<f8a24e80>] ? ext4_mount+0x0/0x20 [ext4]
[  817.574129]  [<c02fc8d9>] do_kern_mount+0x39/0xd0
[  817.574132]  [<c031410a>] do_mount+0x35a/0x6b0
[  817.574135]  [<c02d34a9>] ? strndup_user+0x49/0x70
[  817.574137]  [<c03146e6>] sys_mount+0x66/0xa0
[  817.574140]  [<c0202e5c>] sysenter_do_call+0x12/0x28
[  817.574141] Code: ff e9 ce fe ff ff 66 90 55 89 e5 83 ec 18 89 7d fc 89 d7
8b 15 84 14 a5 f8 89 75 f8 89 c6 89 5d f4 8b 98 7c 01 00 00 85 d2 75 52 <8b> 83
1c 02 00 00 e8 02 4f 83 c7 8b 83 34 01 00 00 8d 55 f0 e8 
[  817.574165] EIP: [<f8a25db3>] ext4_sync_fs+0x23/0xb0 [ext4] SS:ESP
0068:e5fbde24
[  817.574173] CR2: 000000000000021c
[  817.574175] ---[ end trace 026cbf7663053768 ]---
---------------------

The problem also shows up in 2.6.34.7. NPD is in a different place
(fs/ext4/super.c:828, invocation of EXT4_JOURNAL(inode) in ext4_clear_inode())
but it occurs for the same reason as described above.

The failures of that call to kmalloc() can be rare in practice, but still. For
testing purposes, the failure was "injected" into ext4 module by the dynamic
analysis system, KEDR (http://kedr.berlios.de/), we have developed at ISPRAS.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
