From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60788] xfstest generic/068 failure - kernel BUG at
 fs/buffer.c:3005!
Date: Sun, 23 Mar 2014 11:39:47 +0000
Message-ID: <bug-60788-13602-qXz9HbPb4d@https.bugzilla.kernel.org/>
References: <bug-60788-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55168 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbaCWLjv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Mar 2014 07:39:51 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7B1CD20303
	for <linux-ext4@vger.kernel.org>; Sun, 23 Mar 2014 11:39:50 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id BF8E9202F0
	for <linux-ext4@vger.kernel.org>; Sun, 23 Mar 2014 11:39:47 +0000 (UTC)
In-Reply-To: <bug-60788-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=60788

Ognian Tenchev <drJeckyll@Jeckyll.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |drJeckyll@Jeckyll.net

--- Comment #1 from Ognian Tenchev <drJeckyll@Jeckyll.net> ---
uname -a
Linux storage 3.13.6-gentoo-dr #3 SMP Thu Mar 13 19:19:40 EET 2014 x86_64 AMD
Phenom(tm) II X6 1090T Processor AuthenticAMD GNU/Linux

[Wed Mar 19 01:50:22 2014] ------------[ cut here ]------------
[Wed Mar 19 01:50:22 2014] kernel BUG at fs/buffer.c:3350!
[Wed Mar 19 01:50:22 2014] invalid opcode: 0000 [#1] SMP 
[Wed Mar 19 01:50:22 2014] Modules linked in: nfsd auth_rpcgss oid_registry
exportfs nfs_acl lockd sunrpc fuse bridge stp llc iptable_filter xt_mark
iptable_mangle ipt_MASQUERADE xt_nat xt_tcpudp ipv6 iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables
x_tables snd_pcm_oss snd_mixer_oss saa7134_alsa tda827x tda8290 tuner saa7134
tveeprom videobuf_dma_sg videobuf_core v4l2_common videodev igb ptp pps_core
i2c_algo_bit virtio_balloon virtio_pci virtio_ring vhost_net vhost virtio
thermal fan cpufreq_userspace cpufreq_powersave cpufreq_ondemand
cpufreq_conservative cpufreq_stats it87 hwmon_vid hwmon tun usbhid kvm_amd kvm
sr_mod cdrom snd_hda_intel snd_ctxfi snd_hda_codec snd_pcm e100 microcode
snd_page_alloc snd_timer ohci_pci ehci_pci ohci_hcd ehci_hcd acpi_cpufreq snd
usbcore r8169
[Wed Mar 19 01:50:22 2014]  soundcore processor mii usb_common
[Wed Mar 19 01:50:22 2014] CPU: 0 PID: 443 Comm: kswapd0 Not tainted
3.13.6-gentoo-dr #3
[Wed Mar 19 01:50:22 2014] Hardware name: Gigabyte Technology Co., Ltd.
GA-880GA-UD3H/GA-880GA-UD3H, BIOS F7 11/24/2010
[Wed Mar 19 01:50:22 2014] task: ffff88031194b700 ti: ffff8803117e0000 task.ti:
ffff8803117e0000
[Wed Mar 19 01:50:22 2014] RIP: 0010:[<ffffffff8110e3dc>]  [<ffffffff8110e3dc>]
free_buffer_head+0xd/0x29
[Wed Mar 19 01:50:22 2014] RSP: 0018:ffff8803117e1aa8  EFLAGS: 00010287
[Wed Mar 19 01:50:22 2014] RAX: ffff880168843800 RBX: ffff8801688437b8 RCX:
0000000000000000
[Wed Mar 19 01:50:22 2014] RDX: 0000000000000000 RSI: ffff8801688437b8 RDI:
ffff8801688437b8
[Wed Mar 19 01:50:22 2014] RBP: ffff8803132788b8 R08: 0000000000000030 R09:
000000020bb750c0
[Wed Mar 19 01:50:22 2014] R10: ffffea000bb750c0 R11: ffff88031fffb078 R12:
0000000000000001
[Wed Mar 19 01:50:22 2014] R13: ffffea000b1f1c60 R14: 0000000000000001 R15:
0000000000000001
[Wed Mar 19 01:50:22 2014] FS:  00007f0a03c61700(0000)
GS:ffff88031fc00000(0000) knlGS:0000000000000000
[Wed Mar 19 01:50:22 2014] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[Wed Mar 19 01:50:22 2014] CR2: 0000000000442d40 CR3: 000000031130a000 CR4:
00000000000007b0
[Wed Mar 19 01:50:22 2014] Stack:
[Wed Mar 19 01:50:22 2014]  ffffffff8110e695 ffff8801688437b8 ffffea000b1f1c40
ffff8803132788b8
[Wed Mar 19 01:50:22 2014]  ffff8803117e1dd0 ffffffff810b8204 ffff8803117e1c50
000000000000000e
[Wed Mar 19 01:50:22 2014]  0000000000000000 0000000000000000 0000000000000000
0000000000000000
[Wed Mar 19 01:50:22 2014] Call Trace:
[Wed Mar 19 01:50:22 2014]  [<ffffffff8110e695>] ?
try_to_free_buffers+0x7e/0x92
[Wed Mar 19 01:50:22 2014]  [<ffffffff810b8204>] ? shrink_page_list+0x646/0x879
[Wed Mar 19 01:50:22 2014]  [<ffffffff810b8985>] ?
shrink_inactive_list+0x24d/0x3e1
[Wed Mar 19 01:50:22 2014]  [<ffffffff810b9115>] ? shrink_lruvec+0x34a/0x4b2
[Wed Mar 19 01:50:22 2014]  [<ffffffff810eb8c1>] ? super_cache_count+0xa2/0xae
[Wed Mar 19 01:50:22 2014]  [<ffffffff810b764d>] ? shrink_slab+0x2d2/0x2e6
[Wed Mar 19 01:50:22 2014]  [<ffffffff810b764d>] ? shrink_slab+0x2d2/0x2e6
[Wed Mar 19 01:50:22 2014]  [<ffffffff810b9b70>] ? balance_pgdat+0x28e/0x3cd
[Wed Mar 19 01:50:22 2014]  [<ffffffff810b9f41>] ? kswapd+0x292/0x316
[Wed Mar 19 01:50:22 2014]  [<ffffffff810598bf>] ? __wake_up_sync+0x7/0x7
[Wed Mar 19 01:50:22 2014]  [<ffffffff810b9caf>] ? balance_pgdat+0x3cd/0x3cd
[Wed Mar 19 01:50:22 2014]  [<ffffffff81046d51>] ? kthread+0xca/0xd2
[Wed Mar 19 01:50:22 2014]  [<ffffffff81046c87>] ?
kthread_create_on_node+0x160/0x160
[Wed Mar 19 01:50:22 2014]  [<ffffffff8138e17c>] ? ret_from_fork+0x7c/0xb0
[Wed Mar 19 01:50:22 2014]  [<ffffffff81046c87>] ?
kthread_create_on_node+0x160/0x160
[Wed Mar 19 01:50:22 2014] Code: 31 ff 48 89 da 48 89 ee 48 89 04 24 e8 ec c4
f9 ff 85 c0 7e 02 0f 0b 48 83 c4 18 5b 5d c3 48 8d 47 48 48 39 47 48 48 89 fe
74 02 <0f> 0b 48 8b 3d 3b 50 57 00 e8 e3 50 fd ff 65 ff 0c 25 50 ed 00 
[Wed Mar 19 01:50:22 2014] RIP  [<ffffffff8110e3dc>] free_buffer_head+0xd/0x29
[Wed Mar 19 01:50:22 2014]  RSP <ffff8803117e1aa8>
[Wed Mar 19 01:50:22 2014] ---[ end trace d6d840c2b7dcee1a ]---

Occurred when making backup with rsync

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
