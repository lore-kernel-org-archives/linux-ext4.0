From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 116471] New: Core in ext4 filesystem on a Dell Server
Date: Fri, 15 Apr 2016 21:00:58 +0000
Message-ID: <bug-116471-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59781 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbcDOVBD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Apr 2016 17:01:03 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 181E52026F
	for <linux-ext4@vger.kernel.org>; Fri, 15 Apr 2016 21:01:01 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id F14032034A
	for <linux-ext4@vger.kernel.org>; Fri, 15 Apr 2016 21:00:58 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=116471

            Bug ID: 116471
           Summary: Core in ext4 filesystem on a Dell Server
           Product: File System
           Version: 2.5
    Kernel Version: 3.10.0-123.20.1.el7.x86_64
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: kparamasivam@hpe.com
        Regression: No

Two different Dell servers hit the same core and similar backtrace. Is this a
known issue?

[    1.207468] NET: Registered protocol family 15
[    2.105655] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.158633] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    2.222895] xt_CT: netfilter: NOTRACK target is deprecated, use CT instead
or upgrade iptables
[    3.004820] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    3.567836] perf samples too long (2507 > 2500), lowering
kernel.perf_event_max_sample_rate to 50000
[    2.290512] perf samples too long (5002 > 5000), lowering
kernel.perf_event_max_sample_rate to 25000
[    1.757605] ------------[ cut here ]------------
[    1.813895] kernel BUG at fs/buffer.c:1270!
[    1.864984] invalid opcode: 0000 [#1] SMP
[    1.915252] Modules linked in: ip6table_filter ip6_tables xt_CT iptable_raw
xt_REDIRECT iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
xt_state nf_conntrack xt_limit iptable_filter ip_tables xfrm4_tunnel tunnel4
ipcomp xfrm_ipcomp esp4 ah4 af_key binfmt_misc iTCO_wdt iTCO_vendor_support
pcspkr ipmi_si ipmi_msghandler acpi_power_meter acpi_cpufreq mperf sb_edac
edac_core lpc_ich mfd_core shpchp sg mei_me mei tg3 ptp pps_core aesni_intel
ablk_helper cryptd lrw gf128mul glue_helper ecryptfs ext4 jbd2 mbcache sr_mod
cdrom sd_mod crc_t10dif crct10dif_common ahci libahci libata megaraid_sas wmi
ttm drm_kms_helper drm i2c_algo_bit sysimgblt sysfillrect i2c_core syscopyarea
dm_mirror dm_region_hash dm_log dm_mod
[    2.689126] CPU: 2 PID: 14941 Comm: policy_server Not tainted
3.10.0-123.20.1.aruba.x86_64 #1
[    2.792217] Hardware name:    /0H47HH, BIOS 2.0.19 08/29/2013
[    2.862017] task: ffff880f750271c0 ti: ffff880f768e6000 task.ti:
ffff880f768e6000
[    2.952814] RIP: 0010:[<ffffffff811ed1cb>]  [<ffffffff811ed1cb>]
__find_get_block+0x23b/0x250
[    3.058149] RSP: 0018:ffff880f768e75d8  EFLAGS: 00010046
[    3.122843] RAX: 0000000000000086 RBX: ffff880800980000 RCX:
0000000008c00020
[    3.209485] RDX: 0000000000001000 RSI: 0000000008c000a5 RDI:
ffff880800980000
[    3.296120] RBP: ffff880f768e7638 R08: ffff881000eca800 R09:
ffff881000316800
[    3.382756] R10: ffff88100050d0d0 R11: 0000000000000000 R12:
0000000008c000a5
[    3.469392] R13: 0000000000001000 R14: ffff880f768e7768 R15:
ffff88102fd54000
[    3.556027] FS:  00007f2506fb7700(0000) GS:ffff88080fa20000(0000)
knlGS:0000000000000000
[    3.654097] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.723996] CR2: 00007f2837d525e4 CR3: 0000001002195000 CR4:
00000000000407e0
[    3.810630] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[    3.897274] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[    3.983995] Stack:
[    4.009168]  ffff880f768e75e8 ffff880b52491200 ffff8810001a6b40
ffff880b52491200
[    4.099351]  ffff880fec3eaf80 ffff880f768e7678 ffff880f768e7648
ffff880b52491200
[    4.189549]  ffff880800980000 0000000008c000a5 0000000000001000
ffff880f768e7768
[    4.279734] Call Trace:
[    0.015139]  [<ffffffff811ed32e>] __getblk+0x2e/0x70
[    0.075694]  [<ffffffffa01947fb>] __ext4_get_inode_loc+0x12b/0x3c0 [ext4]
[    0.158080]  [<ffffffffa0194bbc>] ext4_get_inode_loc+0x1c/0x20 [ext4]
[    0.236305]  [<ffffffffa0194bed>] ext4_reserve_inode_write+0x2d/0xa0 [ext4]
[    0.320785]  [<ffffffffa01667bc>] ? jbd2__journal_start+0xcc/0x1b0 [jbd2]
[    0.403173]  [<ffffffffa0194cb2>] ext4_mark_inode_dirty+0x52/0x230 [ext4]
[    0.485567]  [<ffffffffa0194ec1>] ? ext4_dirty_inode+0x31/0x70 [ext4]
[    0.563790]  [<ffffffffa0194ed7>] ext4_dirty_inode+0x47/0x70 [ext4]
[    0.639938]  [<ffffffff811e32fa>] __mark_inode_dirty+0x3a/0x250
[    0.711917]  [<ffffffff811d3a41>] update_time+0x81/0xc0
[    0.775572]  [<ffffffff811d3b18>] file_update_time+0x98/0xe0
[    0.844435]  [<ffffffff8114a318>] __generic_file_aio_write+0x188/0x3b0
[    0.923697]  [<ffffffff8114a5a5>] generic_file_aio_write+0x65/0xd0
[    0.998803]  [<ffffffffa018d675>] ext4_file_write+0x45/0xe0 [ext4]
[    1.073901]  [<ffffffff811b91cf>] do_sync_write+0x7f/0xb0
[    1.139643]  [<ffffffff812168f6>] dump_write+0x56/0x70
[    1.202266]  [<ffffffff81211b8d>] elf_core_dump+0x73d/0x790
[    1.270093]  [<ffffffff811bbe86>] ? __sb_start_write+0x76/0x120
[    1.342071]  [<ffffffff812179f4>] do_coredump+0x504/0x690
[    1.407811]  [<ffffffff810734fd>] ? __sigqueue_free+0x3d/0x50
[    1.477709]  [<ffffffff81077c74>] get_signal_to_deliver+0x234/0x570
[    1.553859]  [<ffffffff8107539e>] ? send_signal+0x3e/0x90
[    1.619595]  [<ffffffff8101291b>] do_signal+0x4b/0x140
[    1.682211]  [<ffffffff81012ab2>] do_notify_resume+0xa2/0xd0
[    1.751070]  [<ffffffff815eb192>] int_signal+0x12/0x17
[    1.813688] Code: 82 80 f8 00 00 85 c0 75 de 65 48 89 1c 25 80 f8 00 00 e9
43 fe ff ff 48 89 df e8 31 ef ff ff 4c 89 f7 e9 02 ff ff ff 0f 0b eb fe <0f> 0b
0f 1f 00 eb fb 0f 0b eb fe 66 2e 0f 1f 84 00 00 00 00 00
[    2.048024] RIP  [<ffffffff811ed1cb>] __find_get_block+0x23b/0x250
[    2.123227]  RSP <ffff880f768e75d8>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
