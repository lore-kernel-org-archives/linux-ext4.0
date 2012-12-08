From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51431] ext4_mb_generate_buddy self ext4 errors
Date: Sat,  8 Dec 2012 16:44:37 +0000 (UTC)
Message-ID: <20121208164437.6916111FC70@bugzilla.kernel.org>
References: <bug-51431-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50432 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964908Ab2LHQol (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Dec 2012 11:44:41 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 94763201AE
	for <linux-ext4@vger.kernel.org>; Sat,  8 Dec 2012 16:44:40 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 736A2201AA
	for <linux-ext4@vger.kernel.org>; Sat,  8 Dec 2012 16:44:37 +0000 (UTC)
In-Reply-To: <bug-51431-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51431





--- Comment #5 from zakrzewskim@wp.pl  2012-12-08 16:44:37 ---
On the old kernel errors were like this:

EXT4-fs error (device md2): ext4_ext_find_extent: bad header/extent in inode
#97911179: invalid magic - magic 5f69, entries 28769, max 26988(0), depth
24939(0)
EXT4-fs error (device md2): ext4_ext_remove_space: bad header/extent in inode
#97911179: invalid magic - magic 5f69, entries 28769, max 26988(0), depth
24939(0)
EXT4-fs error (device md2): ext4_mb_generate_buddy: EXT4-fs: group 20974: 8267
blocks in bitmap, 54574 in gd
JBD: Spotted dirty metadata buffer (dev = md2, blocknr = 0). There's a risk of
filesystem corruption in case of system crash.

then after a few hours kernel panic occured:

EXT4-fs error (device md2): ext4_ext_find_extent: bad header/extent in inode
#97911179: invalid magic - magic 5f69, entries 28769, max 26988(0), depth
24939(0)
----------- [cut here ] --------- [please bite here ] ---------
Kernel BUG at fs/ext4/extents.c:1973
invalid opcode: 0000 [1] SMP
last sysfs file: /devices/pci0000:00/0000:00:00.0/irq
CPU 6
Modules linked in: iptable_filter ipt_REDIRECT ip_nat_ftp ip_conntrack_ftp
iptable_nat ip_nat ip_tables xt_state ip_conntrack_netbios_ns ip_conntrack
nfnetlink netconsole ipt_iprange xt_tcpudp autofs4 hwmon_vid coretemp
cpufreq_ondemand acpi_cpufreq freq_table mperf x_tables be2iscsi ib_iser
rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp bnx2i cnic ipv6
xfrm_nalgo crypto_api uio cxgb3i libcxgbi cxgb3 8021q libiscsi_tcp libiscsi2
scsi_transport_iscsi2 scsi_transport_iscsi ext3 jbd dm_mirror dm_multipath
scsi_dh video backlight sbs power_meter hwmon i2c_ec dell_wmi wmi button
battery asus_acpi acpi_memhotplug ac lp joydev sg shpchp parport_pc parport
r8169 mii serio_raw tpm_tis tpm tpm_bios i2c_i801 i2c_core pcspkr dm_raid45
dm_message dm_region_hash dm_log dm_mod dm_mem_cache raid10 raid456 xor raid0
sata_nv aacraid 3w_9xxx 3w_xxxx sata_sil sata_via ahci libata sd_mod scsi_mod
raid1 ext4 jbd2 crc16 uhci_hcd ohci_hcd ehci_hcd
Pid: 9374, comm: httpd Not tainted 2.6.18-308.20.1.el5debug #1
RIP: 0010:[<ffffffff8806ccda>]  [<ffffffff8806ccda>]
:ext4:ext4_ext_put_in_cache+0x21/0x6a
RSP: 0018:ffff8101c2df7678  EFLAGS: 00010246
RAX: 00000000fffffbf1 RBX: ffff810758115dc8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff810758115958
RBP: ffff810758115958 R08: 0000000000000002 R09: 0000000000000000
R10: ffff8101c2df75a0 R11: 0000000000000100 R12: 0000000000000000
R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000000000
FS:  00002ab948d31f70(0000) GS:ffff81081f4ba4c8(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000001de9e4e0 CR3: 000000014ae88000 CR4: 00000000000006a0
Process httpd (pid: 9374, threadinfo ffff8101c2df6000, task ffff8101cdf74d80)
Stack:  000181070000040f ffff810758115dc8 ffff8103f15d7ff4 ffff8107581157f0
 ffff810758115958 000000000000040f 0000000000000000 ffffffff8806f621
 ffff8101c2df76d8 ffff8101c2df7738 0000000000000000 ffff81034900c310
Call Trace:
 [<ffffffff8806f621>] :ext4:ext4_ext_get_blocks+0x258/0x16f3
 [<ffffffff80013994>] poison_obj+0x26/0x2f
 [<ffffffff800331e2>] cache_free_debugcheck+0x20b/0x21a
 [<ffffffff8805b4ac>] :ext4:ext4_get_blocks+0x43/0x1d2
 [<ffffffff8805b4cf>] :ext4:ext4_get_blocks+0x66/0x1d2
 [<ffffffff8805c16a>] :ext4:ext4_get_block+0xa7/0xe6
 [<ffffffff8805c3be>] :ext4:ext4_block_truncate_page+0x215/0x4f1
 [<ffffffff8806e832>] :ext4:ext4_ext_truncate+0x65/0x909
 [<ffffffff8805b4f9>] :ext4:ext4_get_blocks+0x90/0x1d2
 [<ffffffff8805ccfc>] :ext4:ext4_truncate+0x91/0x53b
 [<ffffffff80041e5d>] pagevec_lookup+0x17/0x1e
 [<ffffffff8002d3cf>] truncate_inode_pages_range+0x1f3/0x2d5
 [<ffffffff8803b78b>] :jbd2:jbd2_journal_stop+0x1f1/0x201
 [<ffffffff8805f3c1>] :ext4:ext4_da_write_begin+0x1ea/0x25b
 [<ffffffff80010896>] generic_file_buffered_write+0x151/0x6c3
 [<ffffffff800174b1>] __generic_file_aio_write_nolock+0x36c/0x3b9
 [<ffffffff800482ab>] do_sock_read+0xcf/0x110
 [<ffffffff80022d49>] generic_file_aio_write+0x69/0xc5
 [<ffffffff88056c0a>] :ext4:ext4_file_write+0xcb/0x215
 [<ffffffff8001936b>] do_sync_write+0xc7/0x104
 [<ffffffff8000d418>] dnotify_parent+0x1f/0x7b
 [<ffffffff800efead>] do_readv_writev+0x26e/0x291
 [<ffffffff800a8192>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80035b9f>] do_setitimer+0x62a/0x692
 [<ffffffff8002e6a5>] mntput_no_expire+0x19/0x8d
 [<ffffffff80049aa0>] sys_chdir+0x55/0x62
 [<ffffffff800178c6>] vfs_write+0xce/0x174
 [<ffffffff800181ba>] sys_write+0x45/0x6e
 [<ffffffff80060116>] system_call+0x7e/0x83


Code: 0f 0b 68 3e 27 08 88 c2 b5 07 eb fe 48 8d 9f 08 05 00 00 48
RIP  [<ffffffff8806ccda>] :ext4:ext4_ext_put_in_cache+0x21/0x6a
 RSP <ffff8101c2df7678>
 <0>Kernel panic - not syncing: Fatal exception
 <0>Rebooting in 1 seconds..

-Marek

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
