From: Nikolay Borisov <kernel@kyup.com>
Subject: ext4 crash in 4.4.10
Date: Fri, 3 Jun 2016 11:28:31 +0300
Message-ID: <57513FAF.5030800@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
	SiteGround Operations <operations@siteground.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38730 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbcFCI2f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Jun 2016 04:28:35 -0400
Received: by mail-wm0-f46.google.com with SMTP id a20so96468017wma.1
        for <linux-ext4@vger.kernel.org>; Fri, 03 Jun 2016 01:28:33 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello, 

Recently the following crash was brought to my attention:

[1153408.088002] BUG: unable to handle kernel paging request at ffffffffd9c01fb1
[1153408.088364] IP: [<ffffffff81204b62>] dquot_free_inode+0xa2/0x230
[1153408.088662] PGD 1c0b067 PUD 1c0d067 PMD 0 
[1153408.089073] Oops: 0000 [#1] SMP 
[1153408.089420] Modules linked in: xt_pkttype ip6t_REJECT nf_reject_ipv6 tcp_diag inet_diag act_police cls_basic sch_ingress veth dm_snapshot netconsole loadavg_cont(O) openvswitch xt_owner xt_conntrack iptable_mangle xt_nat iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_CT iptable_raw nf_conntrack_ipv6 nf_defrag_ipv6 xt_state ip6table_filter ip6_tables rdma_ucm ib_ucm ib_uverbs rdma_cm iw_cm ext2 dm_thin_pool dm_bio_prison dm_persistent_data dm_bufio dm_mirror dm_region_hash dm_log nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack ipip ip_tunnel tunnel4 ip6_tunnel tunnel6 ib_umad ib_ipoib ib_cm ib_sa sb_edac edac_core i2c_i801 lpc_ich mfd_core shpchp ioatdma igb i2c_algo_bit ses enclosure ipmi_devintf ipmi_si ipmi_msghandler tcp_scalable ib_qib dca ib_mad ib_core ib_addr ipv6
[1153408.096047] CPU: 4 PID: 7124 Comm: rm Tainted: G           O    4.4.10-clouder1 #73
[1153408.096425] Hardware name: Supermicro X10DRi/X10DRi, BIOS 2.0 12/28/2015
[1153408.096654] task: ffff881ff00ce040 ti: ffff881823ac4000 task.ti: ffff881823ac4000
[1153408.097048] RIP: 0010:[<ffffffff81204b62>]  [<ffffffff81204b62>] dquot_free_inode+0xa2/0x230
[1153408.097490] RSP: 0018:ffff881823ac7c48  EFLAGS: 00010286
[1153408.097713] RAX: ffffffffd9c01f11 RBX: ffff881823ac7c48 RCX: 000000000000fb20
[1153408.098090] RDX: ffff881823ac7c58 RSI: ffff883a824dc258 RDI: ffffffff81c09540
[1153408.098468] RBP: ffff881823ac7cc8 R08: 0000000000000001 R09: ffff881823ac7c58
[1153408.098843] R10: ffff881823ac7ca0 R11: 0000000100000000 R12: ffff883a824dc258
[1153408.099218] R13: 0000000000000000 R14: 0000000000000008 R15: ffff881823ac7e68
[1153408.099594] FS:  00007f3cfff7a700(0000) GS:ffff881fffa80000(0000) knlGS:0000000000000000
[1153408.099973] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1153408.100197] CR2: ffffffffd9c01fb1 CR3: 00000018233d7000 CR4: 00000000001406e0
[1153408.100572] Stack:
[1153408.100789]  ffff881f96ebec00 ffff883a824dbf40 0000000000000000 0000000000000000
[1153408.101414]  0000000000000000 ffffffff8123949c ffff881823ac7d28 ffffffff812351c8
[1153408.102043]  ffff881823ac7cb8 ffff883aa1cd0000 ffff881fed3438d0 ffff883aa1cd0000
[1153408.102666] Call Trace:
[1153408.102888]  [<ffffffff8123949c>] ? ext4_evict_inode+0x26c/0x4c0
[1153408.103113]  [<ffffffff812351c8>] ? ext4_mark_iloc_dirty+0x518/0x770
[1153408.103341]  [<ffffffff812312e3>] ext4_free_inode+0x83/0x5a0
[1153408.103565]  [<ffffffff8123949c>] ? ext4_evict_inode+0x26c/0x4c0
[1153408.103791]  [<ffffffff8123673b>] ? ext4_mark_inode_dirty+0x7b/0x260
[1153408.104017]  [<ffffffff812396e5>] ext4_evict_inode+0x4b5/0x4c0
[1153408.104245]  [<ffffffff811ba616>] evict+0xc6/0x1c0
[1153408.104467]  [<ffffffff811ba9dc>] iput+0x1ec/0x260
[1153408.104694]  [<ffffffff811ab128>] ? vfs_unlink+0x128/0x130
[1153408.104918]  [<ffffffff811ae766>] do_unlinkat+0x186/0x2c0
[1153408.105143]  [<ffffffff811ae8e2>] SyS_unlinkat+0x22/0x40
[1153408.105371]  [<ffffffff81635c57>] entry_SYSCALL_64_fastpath+0x12/0x6a
[1153408.105596] Code: 80 41 be 08 00 00 00 65 ff 0d cf 60 e0 7e e8 f6 0d 43 00 48 8d 53 10 4c 89 e6 4c 8d 55 d8 66 c7 02 00 00 48 8b 06 48 85 c0 74 61 <48> 8b 88 a0 00 00 00 4c 8d 80 a0 00 00 00 83 e1 08 0f 84 a5 00 
[1153408.110201] RIP  [<ffffffff81204b62>] dquot_free_inode+0xa2/0x230
[1153408.110488]  RSP <ffff881823ac7c48>
[1153408.110707] CR2: ffffffffd9c01fb1


This happened while rm -rf was run on the contents of lost+found dir, 
so the file system was corrupted and removing the contents of the 
lost+found dir triggers the crash. The crash actually happens in 
info_idq_free, when it touches the dquot. Rax in this case holds the 
current dquot[cnt] - ffffffffd9c01f11. Inspecting further it become
clear that what i_dquot returned was garbage. So the pointer to the 
USRQUOTA is clearly corrupted. 

crash> rd -64 ffff883a824dc258 3
ffff883a824dc258:  ffffffffd9c01f11 0000000000000000   ................
ffff883a824dc268:  0000000000000000                  


Now, I'm in the process of acquiring an image dump of the FS in question 
and I'd like to ask what further too look at to try and pinpoint how 
the corruption possibly occurred? 

Regards, 
Nikolay 
