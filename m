From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 30872] New: Calling kfree() for uninitialized pointer in
 ext4_mb_init_backend()
Date: Thu, 10 Mar 2011 14:21:04 GMT
Message-ID: <bug-30872-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:50779 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab1CJOVF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Mar 2011 09:21:05 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p2AEL4OR006102
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 10 Mar 2011 14:21:04 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=30872

           Summary: Calling kfree() for uninitialized pointer in
                    ext4_mb_init_backend()
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.38-rc5 (ext4 subsystem tree)
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


Tested on ext4 module from git tree
git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git,
tip: b616844310a6c8a4ab405d3436bbb6e53cfd852f

Arch: x86

At fs/ext4/mballoc.c:2389, memory is allocated for sbi->s_group_info array. The
elements of this array (pointers themselves) seem to be initialized when
ext4_mb_add_groupinfo() is called (line 2408).

If ext4_mb_add_groupinfo() fails for some reason (e.g. if memory allocation at
line 2296 fails), ext4_mb_init_backend() tries to call kfree() for each 
element in sbi->s_group_info array, including the ones that have not been
initialized yet:

fs/ext4/mballoc.c:2414:
err_freebuddy:
    cachep = get_groupinfo_cache(sb->s_blocksize_bits);
    while (i-- > 0)
        kmem_cache_free(cachep, ext4_get_group_info(sb, i));
    i = num_meta_group_infos; 
    while (i-- > 0)
        kfree(sbi->s_group_info[i]); /* <= oops here */
    iput(sbi->s_buddy_cache);

'num_meta_group_infos' seems to be the total number of the elements that should
have been created. 

The problem showed up when I ran tests for ext4 from Linux Test Project
(ext4-alloc-test, test #7, to be exact).

'num_meta_group_infos' was 12 on my system. The first 2 calls to
ext4_mb_add_groupinfo() (ln 2408) succeeded but the 3rd one failed.
kfree(sbi->s_group_info[11]) resulted in a kernel oops:

--------------------------------------------------
[ 6349.953315] EXT4-fs: can't allocate buddy mem
[ 6349.953587] BUG: unable to handle kernel paging request at f7853a00
[ 6349.953591] IP: [<c02f1273>] kfree+0x43/0xf0
[ 6349.953613] *pde = 00000000 
[ 6349.953615] Oops: 0000 [#1] SMP 
[ 6349.953617] last sysfs file:
/sys/devices/virtual/block/loop1/queue/rotational
[ 6349.953623] Modules linked in: ext4 jbd2 crc16 kedr_controller
kedr_fsim_indicator_kmalloc kedr_fsim_indicator_common kedr_fsim_vmm
kedr_fsim_mem_util kedr_fsim_cmm kedr_fault_simulation kedr_trace kedr_base
fuse snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd af_packet mperf loop
dm_mod ppdev snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm parport_pc snd_timer
parport snd sr_mod cdrom ac e1000 sg i2c_piix4 soundcore snd_page_alloc button
pcspkr ohci_hcd ehci_hcd rtc_cmos rtc_core rtc_lib usbcore sd_mod fan processor
ata_generic ata_piix thermal thermal_sys hwmon ahci libahci libata scsi_mod
[last unloaded: kedr_base]
[ 6349.953655] 
[ 6349.953657] Pid: 8379, comm: mount Not tainted 2.6.38-rc5-testbox-ext4+ #1
innotek GmbH VirtualBox
[ 6349.953664] EIP: 0060:[<c02f1273>] EFLAGS: 00010086 CPU: 0
[ 6349.953666] EIP is at kfree+0x43/0xf0
[ 6349.953667] EAX: f7853a00 EBX: 02b50001 ECX: 00000000 EDX: 000000bb
[ 6349.953669] ESI: f8a15391 EDI: 00000202 EBP: e7e03d70 ESP: e7e03d60
[ 6349.953670]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 6349.953672] Process mount (pid: 8379, ti=e7e02000 task=f66bed30
task.ti=e7e02000)
[ 6349.953674] Stack:
[ 6349.953675]  eea9cae8 02b50001 f446f400 f446f400 e7e03d8c f8a15391 f8f01609
00000002
[ 6349.953679]  00032609 02b50001 0000000a e7e03dbc f8f01609 00020000 00000000
f47ce1c0
[ 6349.953683]  f446f400 f446f400 0000000c f446f400 f446f400 e4866bf0 f446f400
e7e03e98
[ 6349.953687] Call Trace:
[ 6349.953691]  [<f8a15391>] repl_kfree+0x51/0xa0 [kedr_fsim_cmm]
[ 6349.953709]  [<f8f01609>] ext4_mb_init+0x2a9/0x4b0 [ext4]
[ 6349.953716]  [<f8ef1b22>] ext4_fill_super+0x2602/0x2ae0 [ext4]
[ 6349.953726]  [<c02fd920>] mount_bdev+0x170/0x1b0
[ 6349.953732]  [<f8ee706a>] ext4_mount+0x1a/0x20 [ext4]
[ 6349.953741]  [<c02fd0f0>] vfs_kern_mount+0x70/0x230
[ 6349.953753]  [<c02fd309>] do_kern_mount+0x39/0xd0
[ 6349.953755]  [<c0314d72>] do_mount+0x432/0x6c0
[ 6349.953768]  [<c0315326>] sys_mount+0x66/0xa0
[ 6349.953771]  [<c0202ddc>] sysenter_do_call+0x12/0x28
[ 6349.953772] Code: 7d fc 85 c9 75 73 83 fb 10 76 61 9c 58 8d 74 26 00 89 c7
fa 90 8d 74 26 00 8d 83 00 00 00 40 c1 e8 0c c1 e0 05 03 05 64 ff 86 c0 <8b> 10
80 e6 80 0f 85 8b 00 00 00 8b 10 80 e6 80 75 7c 8b 10 81 
[ 6349.953796] EIP: [<c02f1273>] kfree+0x43/0xf0 SS:ESP 0068:e7e03d60
[ 6349.953799] CR2: 00000000f7853a00
[ 6349.953801] ---[ end trace 8e09ff66f4f48163 ]--- 
--------------------------------------------------

If I understand correctly what happens in ext4_mb_init_backend(), zeroing
sbi->s_group_info on allocation could fix the problem:
fs/ext4/mballoc.c:2389:
- sbi->s_group_info = kmalloc(array_size, GFP_KERNEL);
+ sbi->s_group_info = kzalloc(array_size, GFP_KERNEL);

This issue was detected with the help of KEDR framework
(http://kedr.berlios.de/). repl_kfree() that can be seen in the call stack
above is a thin wrapper around kfree() that simply output its argument to a
trace.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
