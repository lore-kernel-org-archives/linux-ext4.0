From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15074] Problem with quota on ext4
Date: Tue, 2 Feb 2010 17:49:17 GMT
Message-ID: <201002021749.o12HnHJq013395@demeter.kernel.org>
References: <bug-15074-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50982 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab0BBRtS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Feb 2010 12:49:18 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o12HnHwC013402
	for <linux-ext4@vger.kernel.org>; Tue, 2 Feb 2010 17:49:17 GMT
In-Reply-To: <bug-15074-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15074





--- Comment #2 from Fabio Fantoni <fantonifabio@tiscali.it>  2010-02-02 17:49:13 ---
also with rc6, if can help when i active quota give me warning about quota
journaling support on ext4 not active, this update calltrace:
Feb  2 18:36:26 ns3093701 kernel: [  155.133830] ------------[ cut here
]------------
Feb  2 18:36:26 ns3093701 kernel: [  155.133832] WARNING: at
fs/quota/dquot.c:984 dquot_claim_space+0x98/0x109()
Feb  2 18:36:26 ns3093701 kernel: [  155.133833] Hardware name: X8SIL
Feb  2 18:36:26 ns3093701 kernel: [  155.133834] Modules linked in:
xt_multiport iptable_filter ip_tables x_tables quota_v1 snd_pcm snd_timer
tpm_tis tpm tpm_bios i2c_i801 snd soundcore snd_page_alloc psmouse serio_raw
pcspkr i2c_core evdev processor ext4 mbcache jbd2 crc16 sd_mod crc_t10dif
ata_generic ata_piix libata scsi_mod ide_pci_generic ehci_hcd ide_core e1000e
button thermal fan thermal_sys [last unloaded: scsi_wait_scan]
Feb  2 18:36:26 ns3093701 kernel: [  155.133850] Pid: 1763, comm: flush-8:0
Tainted: G        W  2.6.33-rc6 #1
Feb  2 18:36:26 ns3093701 kernel: [  155.133852] Call Trace:
Feb  2 18:36:26 ns3093701 kernel: [  155.133854]  [<ffffffff8111d3b5>] ?
dquot_claim_space+0x98/0x109
Feb  2 18:36:26 ns3093701 kernel: [  155.133856]  [<ffffffff8111d3b5>] ?
dquot_claim_space+0x98/0x109
Feb  2 18:36:26 ns3093701 kernel: [  155.133858]  [<ffffffff810457ad>] ?
warn_slowpath_common+0x77/0xa3
Feb  2 18:36:26 ns3093701 kernel: [  155.133860]  [<ffffffff8111d3b5>] ?
dquot_claim_space+0x98/0x109
Feb  2 18:36:26 ns3093701 kernel: [  155.133866]  [<ffffffffa00fbdb0>] ?
vfs_dq_claim_block+0x32/0x5c [ext4]
Feb  2 18:36:26 ns3093701 kernel: [  155.133871]  [<ffffffffa00fbef9>] ?
ext4_da_update_reserve_space+0x11f/0x185 [ext4]
Feb  2 18:36:26 ns3093701 kernel: [  155.133877]  [<ffffffffa0117f3c>] ?
ext4_ext_get_blocks+0x15a5/0x1735 [ext4]
Feb  2 18:36:26 ns3093701 kernel: [  155.133880]  [<ffffffff81161a01>] ?
elv_rb_add+0x65/0x6c
Feb  2 18:36:26 ns3093701 kernel: [  155.133882]  [<ffffffff8116aac5>] ?
blk_recount_segments+0x17/0x27
Feb  2 18:36:26 ns3093701 kernel: [  155.133884]  [<ffffffff81160784>] ?
elv_merged_request+0x30/0x39
Feb  2 18:36:26 ns3093701 kernel: [  155.133887]  [<ffffffff81167e57>] ?
__make_request+0x2d0/0x428
Feb  2 18:36:26 ns3093701 kernel: [  155.133889]  [<ffffffff811666a7>] ?
generic_make_request+0x285/0x2d0
Feb  2 18:36:26 ns3093701 kernel: [  155.133891]  [<ffffffff812f1f8e>] ?
__down_write_nested+0x15/0xd1
Feb  2 18:36:26 ns3093701 kernel: [  155.133897]  [<ffffffffa00fc0b9>] ?
ext4_get_blocks+0x15a/0x23a [ext4]
Feb  2 18:36:26 ns3093701 kernel: [  155.133902]  [<ffffffffa00fc5d2>] ?
mpage_da_map_blocks+0xa4/0x579 [ext4]
Feb  2 18:36:26 ns3093701 kernel: [  155.133905]  [<ffffffff810b3fe2>] ?
pagevec_lookup_tag+0x1a/0x21
Feb  2 18:36:26 ns3093701 kernel: [  155.133907]  [<ffffffff810b2be1>] ?
write_cache_pages+0x118/0x29f
Feb  2 18:36:26 ns3093701 kernel: [  155.133912]  [<ffffffffa00fd210>] ?
__mpage_da_writepage+0x0/0x146 [ext4]
Feb  2 18:36:26 ns3093701 kernel: [  155.133918]  [<ffffffffa00fcf83>] ?
ext4_da_writepages+0x4dc/0x6c8 [ext4]
Feb  2 18:36:26 ns3093701 kernel: [  155.133920]  [<ffffffff810ac27e>] ?
find_get_pages_tag+0x46/0xeb
Feb  2 18:36:26 ns3093701 kernel: [  155.133922]  [<ffffffff810ff97b>] ?
end_buffer_async_write+0x0/0x11d
Feb  2 18:36:26 ns3093701 kernel: [  155.133926]  [<ffffffff810f96e6>] ?
writeback_single_inode+0xe3/0x2d6
Feb  2 18:36:26 ns3093701 kernel: [  155.133928]  [<ffffffff810fa32a>] ?
writeback_inodes_wb+0x362/0x439
Feb  2 18:36:26 ns3093701 kernel: [  155.133930]  [<ffffffff810fa534>] ?
wb_writeback+0x133/0x1b2
Feb  2 18:36:26 ns3093701 kernel: [  155.133933]  [<ffffffff810fa7a0>] ?
wb_do_writeback+0x145/0x15b
Feb  2 18:36:26 ns3093701 kernel: [  155.133935]  [<ffffffff810fa7e7>] ?
bdi_writeback_task+0x31/0x9d
Feb  2 18:36:26 ns3093701 kernel: [  155.133937]  [<ffffffff810bfeb6>] ?
bdi_start_fn+0x0/0xd2
Feb  2 18:36:26 ns3093701 kernel: [  155.133939]  [<ffffffff810bff26>] ?
bdi_start_fn+0x70/0xd2
Feb  2 18:36:26 ns3093701 kernel: [  155.133941]  [<ffffffff810bfeb6>] ?
bdi_start_fn+0x0/0xd2
Feb  2 18:36:26 ns3093701 kernel: [  155.133943]  [<ffffffff8105d4e9>] ?
kthread+0x79/0x81
Feb  2 18:36:26 ns3093701 kernel: [  155.133946]  [<ffffffff81009824>] ?
kernel_thread_helper+0x4/0x10
Feb  2 18:36:26 ns3093701 kernel: [  155.133948]  [<ffffffff8105d470>] ?
kthread+0x0/0x81
Feb  2 18:36:26 ns3093701 kernel: [  155.133950]  [<ffffffff81009820>] ?
kernel_thread_helper+0x0/0x10
Feb  2 18:36:26 ns3093701 kernel: [  155.133951] ---[ end trace
4eaa2a86a8e2da2e ]---

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
