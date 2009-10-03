From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14315] New: kernel BUG at fs/ext4/inode.c
Date: Sat, 3 Oct 2009 17:01:36 GMT
Message-ID: <bug-14315-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34648 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbZJCRCN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Oct 2009 13:02:13 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n93H1a7T024698
	for <linux-ext4@vger.kernel.org>; Sat, 3 Oct 2009 17:01:36 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14315

           Summary: kernel BUG at fs/ext4/inode.c
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.32-rc1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: neo_22004-temp1@yahoo.it
        Regression: No


After upgrading to latest git (2.6.32-git3) from 2.6.32-rc0, I hit this bug:

[  166.398579] kernel BUG at fs/ext4/inode.c:1184!
[  166.398586] invalid opcode: 0000 [#1] SMP 
[  166.398594] last sysfs file:
/sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
[  166.398600] CPU 0 
[  166.398604] Modules linked in: ipv6 snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss af_packet
cn k8temp loop i2o_scsi i2o_proc i2o_config i2o_bus i2o_core hwmon_vid
hangcheck_timer video backlight output fan powernow_k8 freq_table cpuid msr
fbcon font bitblit fbcon_rotate fbcon_cw fbcon_ud fbcon_ccw softcursor
snd_hda_codec_analog arc4 ecb b43 radeon rng_core ttm snd_hda_intel mac80211
drm_kms_helper snd_hda_codec drm cfg80211 snd_hwdep snd_pcm rfkill snd_timer fb
snd led_class mousedev firmware_class usblp hid_logitech soundcore
firewire_ohci i2c_algo_bit psmouse snd_page_alloc ssb cfbcopyarea firewire_core
thermal processor sky2 rtc_cmos asus_atk0110 i2c_piix4 amd64_edac_mod rtc_core
thermal_sys crc_itu_t cfbimgblt edac_core mmc_core i2c_core cfbfillrect atkbd
pcspkr evdev rtc_lib button hwmon unix fuse xfs exportfs reiserfs ext3 jbd
scsi_wait_scan usb_storage sr_mod cdrom sg pata_atiixp
[  166.398763] Pid: 3159, comm: flush-8:0 Not tainted 2.6.32-rc2 #1 System
Product Name
[  166.398770] RIP: 0010:[<ffffffff8112e3b3>]  [<ffffffff8112e3b3>]
ext4_num_dirty_pages+0x10f/0x22d
[  166.398791] RSP: 0018:ffff88022ce8fa10  EFLAGS: 00010246
[  166.398797] RAX: 000000000000000e RBX: 0000000000000000 RCX:
008000000002007d
[  166.398803] RDX: ffffea00076c2180 RSI: 0000000000000000 RDI:
ffffea00076c2180
[  166.398809] RBP: ffff88022ce8fb20 R08: ffff880229bbc0b0 R09:
0000000000000000
[  166.398815] R10: 00000000538a08bb R11: 00000000538a08bb R12:
0000000000000000
[  166.398822] R13: ffff88022ce8fa60 R14: ffff880229b601b8 R15:
ffff88022ce8fa58
[  166.398829] FS:  00007fe70c9026f0(0000) GS:ffff880028200000(0000)
knlGS:0000000000000000
[  166.398836] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  166.398841] CR2: 0000000001abbfe0 CR3: 000000020bdab000 CR4:
00000000000006f0
[  166.398848] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  166.398854] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  166.398861] Process flush-8:0 (pid: 3159, threadinfo ffff88022ce8e000, task
ffff88022af18620)
[  166.398866] Stack:
[  166.398870]  0000000000000246 0000000000000246 ffffea00076c2180
ffffffff0000000e
[  166.398879] <0> 0000000000008000 ffff88022ce8fa70 ffff88022ce8fa70
0000000000000000
[  166.398889] <0> ffff880200000001 0000000000000014 000000000000000e
0000000000000000
[  166.398900] Call Trace:
[  166.398913]  [<ffffffff8112fe3a>] ext4_da_writepages+0x144/0x4b0
[  166.398926]  [<ffffffff8109405b>] do_writepages+0x2d/0x4a
[  166.398937]  [<ffffffff810e2b49>] writeback_single_inode+0xf9/0x306
[  166.398947]  [<ffffffff810e37bf>] writeback_inodes_wb+0x452/0x543
[  166.398957]  [<ffffffff810e39e9>] wb_writeback+0x139/0x1ce
[  166.398968]  [<ffffffff810525e7>] ? del_timer_sync+0x23/0x48
[  166.398978]  [<ffffffff810e3cb6>] wb_do_writeback+0x146/0x170
[  166.398989]  [<ffffffff810e3d29>] bdi_writeback_task+0x49/0xd0
[  166.398998]  [<ffffffff810a0e86>] ? bdi_start_fn+0x0/0xf2
[  166.399006]  [<ffffffff810a0f01>] bdi_start_fn+0x7b/0xf2
[  166.399015]  [<ffffffff8104b436>] ? do_exit+0x640/0x64f
[  166.399023]  [<ffffffff810a0e86>] ? bdi_start_fn+0x0/0xf2
[  166.399033]  [<ffffffff8105eb90>] kthread+0x89/0x91
[  166.399041]  [<ffffffff8100c1da>] child_rip+0xa/0x20
[  166.399051]  [<ffffffff8105eb07>] ? kthread+0x0/0x91
[  166.399058]  [<ffffffff8100c1d0>] ? child_rip+0x0/0x20
[  166.399062] Code: c1 10 74 0e f6 c5 20 75 09 48 8b 72 20 4c 39 e6 74 14 48
89 d7 e8 f7 e2 f5 ff 48 8b 9d 28 ff ff ff 4c 89 e6 eb 70 80 e5 08 75 04 <0f> 0b
eb fe 48 8b 7a 10 48 89 f9 4c 8b 01 41 f7 c0 00 02 00 00 
[  166.399128] RIP  [<ffffffff8112e3b3>] ext4_num_dirty_pages+0x10f/0x22d
[  166.399139]  RSP <ffff88022ce8fa10>

The function referenced by the BUG was introduced with commit
55138e0bc29c0751e2152df9ad35deea542f29b3 (ext4: Adjust ext4_da_writepages() to
write out larger contiguous chunks).
When booting in text-only mode the BUG doesn't show up. The only way I found
for reproducing it was starting KDE. Right after the bug shows up KDE apps
become unusable, and issuing "reboot" has no effect, I can only hard-reset.
This also led to data corruption on both my root and home partitions (had to
reinstall some packages and will probably reinstall whole system); e2fsck
truncated a lot of files to zero lenght (I was actually lucky to have a copy of
the BUG written to disk).
I can bisect (tomorrow) or provide more info if needed.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
