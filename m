From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 113041] mbcache NULL pointer dereference
Date: Wed, 27 Apr 2016 07:26:39 +0000
Message-ID: <bug-113041-13602-GkhVCH55Fx@https.bugzilla.kernel.org/>
References: <bug-113041-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37376 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbcD0H0o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Apr 2016 03:26:44 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 48F4B2022D
	for <linux-ext4@vger.kernel.org>; Wed, 27 Apr 2016 07:26:42 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 36FAC20222
	for <linux-ext4@vger.kernel.org>; Wed, 27 Apr 2016 07:26:40 +0000 (UTC)
In-Reply-To: <bug-113041-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=113041

--- Comment #5 from Johnny <johnny+bugzilla@appdata.biz> ---
And another with cassandra 2.1.13 and again kernel 4.3.6:

```
[121437.908906] general protection fault: 0000 [#1] SMP
[121437.912476] Modules linked in: veth xt_conntrack ipt_MASQUERADE
nf_nat_masquerade_ipv4 vxlan ip6_udp_tunnel udp_tunnel iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter nf_nat
nf_conntrack br_netfilter bridge stp llc overlay xfs libcrc32c crc32c_generic
nls_ascii nls_cp437 vfat fat xenfs xen_privcmd ext4 crc16 mbcache jbd2
crc32c_intel hmac drbg aesni_intel aes_x86_64 glue_helper lrw gf128mul
ablk_helper ata_piix cryptd mousedev libata xen_blkfront microcode
firmware_class psmouse evdev scsi_mod i2c_piix4 ixgbevf i2c_core acpi_cpufreq
tpm_tis tpm button sch_fq_codel ip_tables autofs4
[121437.936337] CPU: 2 PID: 66 Comm: kswapd0 Not tainted 4.3.6-coreos #2
[121437.936337] Hardware name: Xen HVM domU, BIOS 4.2.amazon 12/07/2015
[121437.936337] task: ffff8803bde79d00 ti: ffff8803b9ef0000 task.ti:
ffff8803b9ef0000
[121437.936337] RIP: 0010:[<ffffffffad1ac714>]  [<ffffffffad1ac714>]
kmem_cache_free+0x74/0x1e0
[121437.936337] RSP: 0018:ffff8803b9ef3bf8  EFLAGS: 00010246
[121437.936337] RAX: 017fff0000000080 RBX: ffff8803819614e0 RCX:
000000010027001b
[121437.936337] RDX: 000077ff80000000 RSI: ffff8803819614e0 RDI:
ffffea0006c579a0
[121437.936337] RBP: ffff8803b9ef3c10 R08: 0000000081961401 R09:
ffffffffc02a001a
[121437.936337] R10: ffffea000934e060 R11: ffffea000e065840 R12:
ffffea0006c579a0
[121437.936337] R13: 0000000000000059 R14: 0000000000000080 R15:
ffffffffc02a3000
[121437.936337] FS:  0000000000000000(0000) GS:ffff8803cfc40000(0000)
knlGS:0000000000000000
[121437.936337] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[121437.936337] CR2: 00007f3084000000 CR3: 000000002da0b000 CR4:
00000000001406e0
[121437.936337] Stack:
[121437.936337]  ffffea000934e040 ffff8803b9ef3c38 0000000000000059
ffff8803b9ef3c28
[121437.936337]  ffffffffc02a001a ffff880381961270 ffff8803b9ef3c68
ffffffffc02a103f
[121437.936337]  ffff880128c393a8 ffff8802663be680 00000000a184fd14
0000000000000088
[121437.936337] Call Trace:
[121437.936337]  [<ffffffffc02a001a>] 0xffffffffc02a001a
[121437.936337]  [<ffffffffc02a103f>] mb_cache_entry_find_next+0x17f/0x270
[mbcache]
[121437.936337]  [<ffffffffad1669ae>] shrink_slab.part.42+0x1de/0x370
[121437.936337]  [<ffffffffad16aa8d>] shrink_zone+0x28d/0x2d0
[121437.936337]  [<ffffffffad16ba91>] kswapd+0x551/0x9e0
[121437.936337]  [<ffffffffad16b540>] ? mem_cgroup_shrink_node_zone+0x190/0x190
[121437.936337]  [<ffffffffad08e178>] kthread+0xd8/0xf0
[121437.936337]  [<ffffffffad08e0a0>] ? kthread_park+0x60/0x60
[121437.936337]  [<ffffffffad54749f>] ret_from_fork+0x3f/0x70
[121437.936337]  [<ffffffffad08e0a0>] ? kthread_park+0x60/0x60
[121437.936337] Code: 01 d8 48 0f 42 15 1d 59 86 00 4c 8b 4d 08 48 01 d0 48 c1
e8 0c 48 c1 e0 06 49 01 c3 49 8b 03 f6 c4 80 0f 85 56 01 00 00 4c 8b 17 <65> 49
8b 52 08 65 4c 03 15 e7 d9 e5 52 4d 3b 5a 10 0f 85 29 01
[121437.936337] RIP  [<ffffffffad1ac714>] kmem_cache_free+0x74/0x1e0
[121437.936337]  RSP <ffff8803b9ef3bf8>
[121438.134600] ---[ end trace 199019257ae805c3 ]---
[121438.137849] Kernel panic - not syncing: Fatal exception
[121438.138841] Kernel Offset: 0x2c000000 from 0xffffffff81000000 (relocation
range: 0xffffffff80000000-0xffffffffbfffffff)
```

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
