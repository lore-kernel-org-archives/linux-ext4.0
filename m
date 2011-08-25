From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 41712] New: kernel BUG at fs/jbd/transaction.c:1155!
Date: Thu, 25 Aug 2011 11:00:08 GMT
Message-ID: <bug-41712-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:56734 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab1HYLAJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Aug 2011 07:00:09 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p7PB080V025793
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 25 Aug 2011 11:00:08 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=41712

           Summary: kernel BUG at fs/jbd/transaction.c:1155!
           Product: File System
           Version: 2.5
    Kernel Version: 3.0.1-gentoo
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: sur3@gmx.de
                CC: sur3@gmx.de
        Regression: No


I had mounted a 3TB USB HDD with 4k-Blocksize GPT-Partitioning-Sheme and luks.
I then mv'ed from one luks partition to another, when i watched a day later
only one folder was moved and it hang with the other:

7.706985] EXT3-fs error (device dm-0): ext3_new_block: Allocating block in
system zone - blocks from 718668189, length 1
[10187.707609] EXT3-fs error (device dm-0): ext3_new_block: Allocating block in
system zone - blocks from 718668190, length 1
[10187.708234] EXT3-fs error (device dm-0): ext3_new_block: Allocating block in
system zone - blocks from 718668191, length 1
[10187.708859] EXT3-fs error (device dm-0): ext3_new_block: Allocating block in
system zone - blocks from 718668192, length 1
[10187.709611] EXT3-fs error (device dm-0): ext3_new_block: Allocating block in
system zone - blocks from 718668193, length 1
[10187.710234] EXT3-fs error (device dm-0): ext3_new_block: Allocating block in
system zone - blocks from 718668194, length 1
[10187.710859] EXT3-fs error (device dm-0): ext3_new_block: Allocating block in
system zone - blocks from 718668197, length 1
...
[10367.366198] EXT3-fs error (device dm-0): ext3_new_block: Allocating block in
system zone - blocks from 719673291, length 1
[10367.706486] EXT3-fs error (device dm-0): ext3_valid_block_bitmap: Invalid
block bitmap - block_group = 21963, block = 719706059
[10367.707449] EXT3-fs error (device dm-0): ext3_new_block: Allocating block in
system zone - blocks from 719683584, length 1
[10367.717603] EXT3-fs error (device dm-0): ext3_valid_block_bitmap: Invalid
block bitmap - block_group = 21964, block = 719738828
[10367.718322] EXT3-fs error (device dm-0): ext3_new_block: Allocating block in
system zone - blocks from 719716352, length 1
[10367.727604] EXT3-fs error (device dm-0): ext3_valid_block_bitmap: Invalid
block bitmap - block_group = 21965, block = 719771597
[10367.728322] EXT3-fs error (device dm-0): ext3_new_block: Allocating block in
system zone - blocks from 719749120, length 1
[10367.729073] EXT3-fs error (device dm-0): ext3_new_block: Allocating block in
system zone - blocks from 719749128, length 1
[10367.729695] EXT3-fs error (device dm-0): ext3_new_block: Allocating block in
system zone - blocks from 719749232, length 1
...
[10369.453073] EXT3-fs error (device dm-0): ext3_new_block: Allocating block in
system zone - blocks from 717586544, length 1
[10369.453699] EXT3-fs error (device dm-0): ext3_new_block: Allocating block in
system zone - blocks from 717619312, length 1
[10369.454324] EXT3-fs error (device dm-0): ext3_new_block: Allocating block in
system zone - blocks from 717651970, length 1
[10369.454957] ------------[ cut here ]------------
[10369.454960] kernel BUG at fs/jbd/transaction.c:1155!
[10369.454962] invalid opcode: 0000 [#1] SMP 
[10369.454964] CPU 0 
[10369.454965] Modules linked in: fglrx(P) xts gf128mul dm_crypt snd_seq
snd_seq_device snd_pcm_oss dm_mod snd_hda_codec_hdmi snd_hda_intel
snd_hda_codec snd_pcm intel_agp intel_gtt snd_timer agpgart snd pcspkr
snd_page_alloc
[10369.454976] 
[10369.454978] Pid: 2804, comm: mv Tainted: P            3.0.1-gentoo #1 System
manufacturer System Product Name/P5Q
[10369.454982] RIP: 0010:[<ffffffff811433c2>]  [<ffffffff811433c2>]
journal_dirty_metadata+0x112/0x120
[10369.454989] RSP: 0018:ffff88011ad136d8  EFLAGS: 00010246
[10369.454990] RAX: ffff880041a5e0c0 RBX: ffff880020d9c930 RCX:
ffff88011ad13880
[10369.454992] RDX: 0000000000000000 RSI: ffff88009ee86c98 RDI:
ffff88012890d420
[10369.454993] RBP: ffff88012890d420 R08: 00000000ffffffff R09:
ffff88011ad137b0
[10369.454995] R10: ffff8801213b7e00 R11: 0000000000000000 R12:
ffff8801240bf400
[10369.454996] R13: 0000000000000078 R14: ffff8801213b7f48 R15:
000000002ac70000
[10369.454998] FS:  00007f07eb0d3700(0000) GS:ffff88012fc00000(0000)
knlGS:0000000000000000
[10369.455000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[10369.455002] CR2: 00007fe97fe0c000 CR3: 000000012b3b0000 CR4:
00000000000406f0
[10369.455003] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[10369.455005] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[10369.455007] Process mv (pid: 2804, threadinfo ffff88011ad12000, task
ffff8801213e7a60)
[10369.455008] Stack:
[10369.455009]  ffffffff00000078 ffffffff8144e070 ffff88009ee86c98
ffff88012890d420
[10369.455012]  0000000000000078 ffffffff81134ee7 ffff880121365c00
ffff88009ee86c98
[10369.455014]  ffff880121337c40 ffff880121365c00 ffff88009ee86c98
ffffffff81123962
[10369.455017] Call Trace:
[10369.455021]  [<ffffffff81134ee7>] ? __ext3_journal_dirty_metadata+0x27/0x60
[10369.455024]  [<ffffffff81123962>] ?
ext3_try_to_allocate_with_rsv+0x622/0x690
[10369.455026]  [<ffffffff81123e31>] ? ext3_new_blocks+0x461/0x6e0
[10369.455028]  [<ffffffff811280d5>] ? ext3_get_blocks_handle+0x305/0xb60
[10369.455032]  [<ffffffff81054ff4>] ? bit_waitqueue+0x14/0xb0
[10369.455034]  [<ffffffff811289df>] ? ext3_get_block+0xaf/0x120
[10369.455037]  [<ffffffff810ecda6>] ? __block_write_begin+0x216/0x5a0
[10369.455040]  [<ffffffff81128930>] ? ext3_get_blocks_handle+0xb60/0xb60
[10369.455042]  [<ffffffff8112a24e>] ? ext3_write_begin+0xbe/0x220
[10369.455046]  [<ffffffff81089878>] ? generic_file_buffered_write+0x108/0x260
[10369.455048]  [<ffffffff8108b9ef>] ? __generic_file_aio_write+0x22f/0x440
[10369.455052]  [<ffffffff811b24eb>] ? blk_finish_plug+0xb/0x30
[10369.455054]  [<ffffffff8108bc76>] ? generic_file_aio_write+0x76/0xf0
[10369.455057]  [<ffffffff810c28bf>] ? do_sync_write+0xbf/0x100
[10369.455060]  [<ffffffff810c33d8>] ? vfs_write+0xc8/0x170
[10369.455062]  [<ffffffff810c357e>] ? sys_write+0x4e/0x90
[10369.455065]  [<ffffffff8142f1fb>] ? system_call_fastpath+0x16/0x1b
[10369.455067] Code: ff ff ff 49 3b 44 24 50 90 75 24 4c 8d 6e 02 eb 94 f3 90
48 8b 16 f7 c2 00 00 10 00 75 f3 e9 28 ff ff ff 0f 0b eb fe 0f 0b eb fe <0f> 0b
eb fe 0f 0b eb fe 0f 0b eb fe 66 90 41 57 41 56 41 55 41 
[10369.455086] RIP  [<ffffffff811433c2>] journal_dirty_metadata+0x112/0x120
[10369.455089]  RSP <ffff88011ad136d8>
[10369.455091] ---[ end trace b66f4b8a9b4b30a4 ]---

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
