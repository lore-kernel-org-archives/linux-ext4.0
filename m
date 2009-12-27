From: Vikram Noel Ambrose <noel.ambrose@gmail.com>
Subject: PROBLEM: Random deadlock - 2.6.33-rc2
Date: Sun, 27 Dec 2009 12:26:33 -0500
Message-ID: <4B3798C9.50704@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:43448 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbZL0R0h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Dec 2009 12:26:37 -0500
Received: by qyk30 with SMTP id 30so4548082qyk.33
        for <linux-ext4@vger.kernel.org>; Sun, 27 Dec 2009 09:26:37 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

My system freezes randomly within a few minutes after boot. I use EXT4, 
LVM and RAID.

Problem only started happening after moving to 2.6.33-rc2. The problem 
does not exist in 2.6.32.

Using Ubuntu-9.10 x86_64 userspace.

Various system information and error log below ->

Linux vikbox 2.6.33-rc2 #11 SMP Sat Dec 26 04:23:36 EST 2009 x86_64 
GNU/Linux
 
Gnu C                  4.4.1
Gnu make               3.81
binutils               2.20
util-linux             2.16
mount                  support
module-init-tools      3.10
e2fsprogs              1.41.9
reiserfsprogs          3.6.21
pcmciautils            014
Linux C Library        2.10.1
Dynamic linker (ldd)   2.10.1
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15
Sh-utils               7.4
Modules Loaded         xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 
nf_conntrack nf_defrag_ipv4 binfmt_misc ppdev snd_hda_codec_atihdmi 
snd_hda_codec_nvhdmi snd_hda_codec_via snd_hda_intel snd_hda_codec 
snd_pcm_oss snd_hwdep snd_mixer_oss snd_seq_dummy snd_pcm snd_seq_oss 
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer 
snd_seq_device iptable_filter snd soundcore lp ip_tables snd_page_alloc 
video i2c_nforce2 edac_core x_tables output parport joydev asus_atk0110 
raid10 raid1 raid0 multipath linear raid456 async_raid6_recov async_pq 
raid6_pq async_xor xor async_memcpy async_tx hid_logitech ff_memless 
usbhid radeon ttm 8139too drm_kms_helper mii floppy forcedeth drm

Dec 27 12:11:37 vikbox kernel: [ 1236.105816] CPU 1
Dec 27 12:11:37 vikbox kernel: [ 1236.105825] Pid: 1137, comm: 
flush-252:3 Not tainted 2.6.33-rc2 #11 M4N78 PRO/System Product Name
Dec 27 12:11:37 vikbox kernel: [ 1236.105833] RIP: 
0010:[<ffffffff811bd176>]  [<ffffffff811bd176>] ext4_get_blocks+0x416/0x420
Dec 27 12:11:37 vikbox kernel: [ 1236.105850] RSP: 
0018:ffff8800634df8c0  EFLAGS: 00010297
Dec 27 12:11:37 vikbox kernel: [ 1236.105855] RAX: 0000000000000002 RBX: 
ffff8800634df970 RCX: 0000000000000154
Dec 27 12:11:37 vikbox kernel: [ 1236.105860] RDX: 0000000000000000 RSI: 
0000000000000003 RDI: 0000000000000153
Dec 27 12:11:37 vikbox kernel: [ 1236.105866] RBP: ffff8800634df930 R08: 
0000000000000000 R09: 0000000000000000
Dec 27 12:11:37 vikbox kernel: [ 1236.105871] R10: 0000000000000004 R11: 
0000000000000064 R12: 0000000000000004
Dec 27 12:11:37 vikbox kernel: [ 1236.105876] R13: ffff8800169f3aa0 R14: 
ffff8800169f3a00 R15: 0000000000000003
Dec 27 12:11:37 vikbox kernel: [ 1236.105882] FS:  
00007ffa2fd7f910(0000) GS:ffff880001e80000(0000) knlGS:0000000000000000
Dec 27 12:11:37 vikbox kernel: [ 1236.105888] CS:  0010 DS: 0000 ES: 
0000 CR0: 000000008005003b
Dec 27 12:11:37 vikbox kernel: [ 1236.105893] CR2: 00007ffa32aabd87 CR3: 
0000000079ffd000 CR4: 00000000000006e0
Dec 27 12:11:37 vikbox kernel: [ 1236.105899] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Dec 27 12:11:37 vikbox kernel: [ 1236.105904] DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Dec 27 12:11:37 vikbox kernel: [ 1236.105911] Process flush-252:3 (pid: 
1137, threadinfo ffff8800634de000, task ffff88007c940000)
Dec 27 12:11:37 vikbox kernel: [ 1236.105918]  ffff8800634df8d0 
ffffffff8114ff10 ffff880076e73800 00000001634df960
Dec 27 12:11:37 vikbox kernel: [ 1236.105927] <0> 0000000000016d54 
000002a8634dfbe0 ffff8800169f3d68 ffff8800169f3a88
Dec 27 12:11:37 vikbox kernel: [ 1236.105936] <0> ffff8800634df920 
ffff8800634dfbe0 0000000000016d54 ffff8800634dfd70
Dec 27 12:11:37 vikbox kernel: [ 1236.105958]  [<ffffffff8114ff10>] ? 
block_write_full_page+0x10/0x20
Dec 27 12:11:37 vikbox kernel: [ 1236.105967]  [<ffffffff811be3c7>] 
mpage_da_map_blocks+0xa7/0x430
Dec 27 12:11:37 vikbox kernel: [ 1236.105976]  [<ffffffff81266415>] ? 
radix_tree_gang_lookup_tag_slot+0x95/0xe0
Dec 27 12:11:37 vikbox kernel: [ 1236.105985]  [<ffffffff810dfa8b>] ? 
find_get_pages_tag+0x3b/0x140
Dec 27 12:11:37 vikbox kernel: [ 1236.105994]  [<ffffffff811bee7b>] 
__mpage_da_writepage+0x3b/0x1a0
Dec 27 12:11:37 vikbox kernel: [ 1236.106003]  [<ffffffff810e7751>] 
write_cache_pages+0x1c1/0x400
Dec 27 12:11:37 vikbox kernel: [ 1236.106010]  [<ffffffff811bee40>] ? 
__mpage_da_writepage+0x0/0x1a0
Dec 27 12:11:37 vikbox kernel: [ 1236.106019]  [<ffffffff811be9f9>] 
ext4_da_writepages+0x2a9/0x620
Dec 27 12:11:37 vikbox kernel: [ 1236.106028]  [<ffffffff810458d8>] ? 
load_balance_fair+0x1e8/0x2b0
Dec 27 12:11:37 vikbox kernel: [ 1236.106036]  [<ffffffff810e79dc>] 
do_writepages+0x1c/0x40
Dec 27 12:11:37 vikbox kernel: [ 1236.106044]  [<ffffffff811477b9>] 
writeback_single_inode+0xe9/0x3c0
Dec 27 12:11:37 vikbox kernel: [ 1236.106051]  [<ffffffff81147eff>] 
writeback_inodes_wb+0x33f/0x500
Dec 27 12:11:37 vikbox kernel: [ 1236.106059]  [<ffffffff811481d2>] 
wb_writeback+0x112/0x1e0
Dec 27 12:11:37 vikbox kernel: [ 1236.106068]  [<ffffffff8106789e>] ? 
try_to_del_timer_sync+0x6e/0xd0
Dec 27 12:11:37 vikbox kernel: [ 1236.106078]  [<ffffffff81503636>] ? 
schedule_timeout+0x196/0x2f0
Dec 27 12:11:37 vikbox kernel: [ 1236.106085]  [<ffffffff811484fc>] 
wb_do_writeback+0x18c/0x1a0
Dec 27 12:11:37 vikbox kernel: [ 1236.106092]  [<ffffffff8114855b>] 
bdi_writeback_task+0x4b/0xd0
Dec 27 12:11:37 vikbox kernel: [ 1236.106100]  [<ffffffff810f7621>] 
bdi_start_fn+0x81/0xf0
Dec 27 12:11:37 vikbox kernel: [ 1236.106106]  [<ffffffff810f75a0>] ? 
bdi_start_fn+0x0/0xf0
Dec 27 12:11:37 vikbox kernel: [ 1236.106113]  [<ffffffff81075cae>] 
kthread+0x8e/0xa0
Dec 27 12:11:37 vikbox kernel: [ 1236.106120]  [<ffffffff8100ad24>] 
kernel_thread_helper+0x4/0x10
Dec 27 12:11:37 vikbox kernel: [ 1236.106127]  [<ffffffff81075c20>] ? 
kthread+0x0/0xa0
Dec 27 12:11:37 vikbox kernel: [ 1236.106134]  [<ffffffff8100ad20>] ? 
kernel_thread_helper+0x0/0x10
Dec 27 12:11:37 vikbox kernel: [ 1236.106209]  RSP <ffff8800634df8c0>
Dec 27 12:11:37 vikbox kernel: [ 1236.106215] ---[ end trace 
0bc3de8ec206cc35 ]---

Dec 27 12:12:42 vikbox kernel: [ 1301.381252] CPU 1
Dec 27 12:12:42 vikbox kernel: [ 1301.381252] Pid: 2514, comm: 
transmission Tainted: G      D    2.6.33-rc2 #11 M4N78 PRO/System 
Product Name
Dec 27 12:12:42 vikbox kernel: [ 1301.381252] RIP: 
0010:[<ffffffff8102f392>]  [<ffffffff8102f392>] __ticket_spin_lock+0x12/0x20
Dec 27 12:12:42 vikbox kernel: [ 1301.381252] RSP: 
0018:ffff88007c0cbe18  EFLAGS: 00000297
Dec 27 12:12:42 vikbox kernel: [ 1301.381252] RAX: 0000000000005453 RBX: 
ffff88007c0cbe18 RCX: 000000000000000c
Dec 27 12:12:42 vikbox kernel: [ 1301.381252] RDX: ffff88007c0cbef8 RSI: 
ffff88007c0cbef8 RDI: ffff8800169f3d68
Dec 27 12:12:42 vikbox kernel: [ 1301.381252] RBP: ffffffff8100a8ce R08: 
ffff88007c0cbdb8 R09: ffffffff81a49d90
Dec 27 12:12:42 vikbox kernel: [ 1301.381252] R10: 0000000000000000 R11: 
0000000000000246 R12: ffff88007994d0c0
Dec 27 12:12:42 vikbox kernel: [ 1301.381252] R13: ffff88007c0cbd98 R14: 
ffffffff81a49d90 R15: 00000000ffffff9c
Dec 27 12:12:42 vikbox kernel: [ 1301.381252] FS:  
00007f7fec2ab910(0000) GS:ffff880001e80000(0000) knlGS:0000000000000000
Dec 27 12:12:42 vikbox kernel: [ 1301.381252] CS:  0010 DS: 0000 ES: 
0000 CR0: 0000000080050033
Dec 27 12:12:42 vikbox kernel: [ 1301.381252] CR2: 00007ffa32aabd87 CR3: 
000000006feee000 CR4: 00000000000006e0
Dec 27 12:12:42 vikbox kernel: [ 1301.381252] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Dec 27 12:12:42 vikbox kernel: [ 1301.381252] DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Dec 27 12:12:42 vikbox kernel: [ 1301.381252] Process transmission (pid: 
2514, threadinfo ffff88007c0ca000, task ffff880074ea96e0)
Dec 27 12:12:42 vikbox kernel: [ 1301.381252]  ffff88007c0cbe28 
ffffffff81505259 ffff88007c0cbe58 ffffffff811ba025
Dec 27 12:12:42 vikbox kernel: [ 1301.381252] <0> ffff88007994d0c0 
ffff880036c80f00 ffff8800169f3aa0 ffff88007c0cbef8
Dec 27 12:12:42 vikbox kernel: [ 1301.381252] <0> ffff88007c0cbe98 
ffffffff8112ae4c ffff88005d8ce3d8 ffff880037575280
Dec 27 12:12:42 vikbox kernel: [ 1301.381252]  [<ffffffff81505259>] ? 
_raw_spin_lock+0x9/0x10
Dec 27 12:12:42 vikbox kernel: [ 1301.381252]  [<ffffffff811ba025>] ? 
ext4_getattr+0x45/0x90
Dec 27 12:12:42 vikbox kernel: [ 1301.381252]  [<ffffffff8112ae4c>] ? 
vfs_getattr+0x4c/0x80
Dec 27 12:12:42 vikbox kernel: [ 1301.381252]  [<ffffffff8112aed8>] ? 
vfs_fstatat+0x58/0x70
Dec 27 12:12:42 vikbox kernel: [ 1301.381252]  [<ffffffff81461b3e>] ? 
tcp_poll+0x2e/0x1b0
Dec 27 12:12:42 vikbox kernel: [ 1301.381252]  [<ffffffff8112b016>] ? 
vfs_stat+0x16/0x20
Dec 27 12:12:42 vikbox kernel: [ 1301.381252]  [<ffffffff8112b03f>] ? 
sys_newstat+0x1f/0x50
Dec 27 12:12:42 vikbox kernel: [ 1301.381252]  [<ffffffff81009f02>] ? 
system_call_fastpath+0x16/0x1b
Dec 27 12:12:42 vikbox kernel: [ 1301.381252] Call Trace:
Dec 27 12:12:42 vikbox kernel: [ 1301.381252]  [<ffffffff81505259>] ? 
_raw_spin_lock+0x9/0x10
Dec 27 12:12:42 vikbox kernel: [ 1301.381252]  [<ffffffff811ba025>] ? 
ext4_getattr+0x45/0x90
Dec 27 12:12:42 vikbox kernel: [ 1301.381252]  [<ffffffff8112ae4c>] ? 
vfs_getattr+0x4c/0x80
Dec 27 12:12:42 vikbox kernel: [ 1301.381252]  [<ffffffff8112aed8>] ? 
vfs_fstatat+0x58/0x70
Dec 27 12:12:42 vikbox kernel: [ 1301.381252]  [<ffffffff81461b3e>] ? 
tcp_poll+0x2e/0x1b0
Dec 27 12:12:42 vikbox kernel: [ 1301.381252]  [<ffffffff8112b016>] ? 
vfs_stat+0x16/0x20
Dec 27 12:12:42 vikbox kernel: [ 1301.381252]  [<ffffffff8112b03f>] ? 
sys_newstat+0x1f/0x50
Dec 27 12:12:42 vikbox kernel: [ 1301.381252]  [<ffffffff81009f02>] ? 
system_call_fastpath+0x16/0x1b



