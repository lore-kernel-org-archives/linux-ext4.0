From: Amir Goldstein <amir73il@gmail.com>
Subject: testing ext4 master branch
Date: Thu, 12 May 2011 19:27:41 +0300
Message-ID: <BANLkTinZVZVRkAggcLyQ4dS960dZYQUqsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63882 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757426Ab1ELQ1n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 May 2011 12:27:43 -0400
Received: by ewy4 with SMTP id 4so477131ewy.19
        for <linux-ext4@vger.kernel.org>; Thu, 12 May 2011 09:27:42 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

During testing of Ted's master branch merged with 2.6.39-rc7, I
encountered 2 errors,
before the system was hung.

One error is consistent in xfstest 005 (Test symlinks & ELOOP):
QA output created by 005
*** touch deep symlinks

No ELOOP?  Unexpected!

*** touch recusive symlinks

ELOOP returned.  Good.


The other error is critical and you may be able to provide some input:
while running xfstest 232 (Run fsstress with quotas enabled and verify
accounted quotas in the end):


[18339.351033] EXT4-fs (sda8): mounted filesystem with ordered data
mode. Opts: acl,user_xattr,usrquota,grpquota
[18339.386612] EXT4-fs (sda8): re-mounted. Opts: (null)
[18339.397322] EXT4-fs (sda8): re-mounted. Opts: (null)
[18406.012595] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000018
[18406.012664] IP: [<ffffffff8122e202>] ext4_quota_off+0x42/0xd0
[18406.012711] PGD 0
[18406.012730] Oops: 0000 [#1] SMP
[18406.012810] CPU 2
[18406.012826] Modules linked in: next4 binfmt_misc parport_pc ppdev
snd_hda_codec_realtek snd_hda_intel snd_hda_codec i915 snd_hwdep
drm_kms_helper snd_pcm snd_seq_midi drm firewire_ohci firewire_core
usbhid snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device
snd e1000e psmouse tpm_tis serio_raw lp i2c_algo_bit hid tpm intel_agp
pata_marvell parport soundcore crc_itu_t tpm_bios intel_gtt video
snd_page_alloc
[18406.013187]
[18406.013201] Pid: 26309, comm: quotaon Tainted: G   M
2.6.39-rc7+ #6                  /DQ35JO
[18406.013269] RIP: 0010:[<ffffffff8122e202>]  [<ffffffff8122e202>]
ext4_quota_off+0x42/0xd0
[18406.013325] RSP: 0018:ffff88011cd57e28  EFLAGS: 00010292
[18406.013361] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000018
[18406.013406] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000246
[18406.013451] RBP: ffff88011cd57e48 R08: 0000000000000001 R09: 0000000000000000
[18406.013497] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800ca9b8800
[18406.013541] R13: ffff8800ca9b8800 R14: 0000000000000001 R15: 0000000000000000
[18406.013587] FS:  00007f602698b720(0000) GS:ffff88012bd00000(0000)
knlGS:0000000000000000
[18406.013639] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[18406.013676] CR2: 0000000000000018 CR3: 000000011332b000 CR4: 00000000000006e0
[18406.013721] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[18406.013766] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[18406.013812] Process quotaon (pid: 26309, threadinfo
ffff88011cd56000, task ffff880111bddee0)
[18406.013864] Stack:
[18406.013880]  0000000000800003 0000000000000001 ffff8800ca9b8800
00000000ffffffda
[18406.013939]  ffff88011cd57ef8 ffffffff811c9e05 0000000000000000
0000000000000000
[18406.013998]  ffff88011cd57e78 ffff8800ca9b8868 ffff880124621e00
ffff8800ca9b8868
[18406.014057] Call Trace:
[18406.014079]  [<ffffffff811c9e05>] do_quotactl+0x4e5/0x560
[18406.014118]  [<ffffffff815d2b1c>] ? down_read+0x4c/0x70
[18406.014155]  [<ffffffff811711cf>] ? get_super+0x9f/0xd0
[18406.014190]  [<ffffffff81189f78>] ? iput+0x48/0x200
[18406.014224]  [<ffffffff811c9f4c>] sys_quotactl+0xcc/0x1a0
[18406.014260]  [<ffffffff8116be26>] ? filp_close+0x66/0x90
[18406.014298]  [<ffffffff812fcb1e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[18406.014343]  [<ffffffff815dc642>] system_call_fastpath+0x16/0x1b
[18406.014382] Code: 89 74 24 18 0f 1f 44 00 00 48 63 c6 49 89 fc 41
89 f6 48 8b 9c c7 60 03 00 00 48 8b 87 90 04 00 00 f6 40 73 08 0f 85
7e 00 00 00
[18406.014601]  8b 7b 18 be 01 00 00 00 e8 c0 fb ff ff 48 3d 00 f0 ff ff 49
[18406.014712] RIP  [<ffffffff8122e202>] ext4_quota_off+0x42/0xd0
[18406.014756]  RSP <ffff88011cd57e28>
[18406.014780] CR2: 0000000000000018
[18406.079351] ---[ end trace 2924f13a8b419b9a ]---


The test was hung at quotacheck -u -g for a long time, so I dumped
waiting tasks and got:


[21278.671419] SysRq : Show Blocked State
[21278.671427]   task                        PC stack   pid father
[21278.671457] quotacheck      D 00000001001ba0b0     0 26321  26123 0x00000000
[21278.671464]  ffff8801123f7da8 0000000000000046 ffff8801123f7df8
0000000017059fa0
[21278.671472]  ffff880100000000 ffff8801123f7fd8 ffff8801123f6000
ffff8801123f7fd8
[21278.671480]  ffff880124f43f40 ffff880117059fa0 ffff8800ca9b8870
00000001ca9b8868
[21278.671487] Call Trace:
[21278.671498]  [<ffffffff815d3775>] rwsem_down_failed_common+0xc5/0x160
[21278.671504]  [<ffffffff815d3823>] rwsem_down_write_failed+0x13/0x20
[21278.671511]  [<ffffffff812fca83>] call_rwsem_down_write_failed+0x13/0x20
[21278.671517]  [<ffffffff811904ce>] ? do_mount+0x21e/0x7e0
[21278.671523]  [<ffffffff815d2ac5>] ? down_write+0x65/0x70
[21278.671527]  [<ffffffff811904ce>] ? do_mount+0x21e/0x7e0
[21278.671532]  [<ffffffff811904ce>] do_mount+0x21e/0x7e0
[21278.671537]  [<ffffffff812fce81>] ? strncpy_from_user+0x31/0x40
[21278.671543]  [<ffffffff81179dd4>] ? getname_flags+0x74/0x240
[21278.671548]  [<ffffffff81190e50>] sys_mount+0x90/0xe0
[21278.671554]  [<ffffffff815dc642>] system_call_fastpath+0x16/0x1b


I have had problems running xfstests on my machine (now Ubuntu 11.4).
umount keep failing on some specific tests (sometimes) and reporting:
+umount: /mnt/test/scratch: device is busy.
+        (In some cases useful info about processes that use
+         the device is found by lsof(8) or fuser(1))

Naturally, those partitions are dedicated for xfstests.
I was never able to solve this problem so I set USE_REMOUNT=1 to avoid umount
at least on the TEST partition.

Any ideas?

Amir.
