From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15074] New: Problem with quota on ext4
Date: Sat, 16 Jan 2010 21:49:46 GMT
Message-ID: <bug-15074-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38575 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab0APVtr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Jan 2010 16:49:47 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0GLnkNC020358
	for <linux-ext4@vger.kernel.org>; Sat, 16 Jan 2010 21:49:46 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15074

           Summary: Problem with quota on ext4
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.33-rc4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: fantonifabio@tiscali.it
        Regression: No


I have very big syslog with always this error:
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292650] WARNING: at
fs/quota/dquot.c:984 dquot_claim_space+0x98/0x109()
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292651] Hardware name: X8SIL
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292652] Modules linked in:
xt_multiport iptable_filter ip_tables x_tables quota_v1 snd_pcm snd_timer
tpm_tis snd tpm tpm_bios evdev soundcore snd_page_alloc psmouse i2c_i801
serio_raw pcspkr i2c_core processor ext4 mbcache jbd2 crc16 sd_mod crc_t10dif
ata_generic ata_piix libata scsi_mod ide_pci_generic e1000e ide_core ehci_hcd
button thermal fan thermal_sys [last unloaded: scsi_wait_scan]
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292668] Pid: 1912, comm: flush-8:0
Tainted: G        W  2.6.33-rc4 #1
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292669] Call Trace:
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292672]  [<ffffffff8111d4cd>] ?
dquot_claim_space+0x98/0x109
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292674]  [<ffffffff8111d4cd>] ?
dquot_claim_space+0x98/0x109
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292676]  [<ffffffff81045791>] ?
warn_slowpath_common+0x77/0xa3
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292678]  [<ffffffff8111d4cd>] ?
dquot_claim_space+0x98/0x109
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292684]  [<ffffffffa00ff063>] ?
ext4_get_blocks+0x2d9/0x3a4 [ext4]
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292689]  [<ffffffffa00ff5ac>] ?
mpage_da_map_blocks+0xa4/0x579 [ext4]
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292692]  [<ffffffff810b3eb6>] ?
pagevec_lookup_tag+0x1a/0x21
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292695]  [<ffffffff810b2ab5>] ?
write_cache_pages+0x118/0x29f
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292700]  [<ffffffffa01001ea>] ?
__mpage_da_writepage+0x0/0x146 [ext4]
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292705]  [<ffffffffa00fff5d>] ?
ext4_da_writepages+0x4dc/0x6c8 [ext4]
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292708]  [<ffffffff810ffa5f>] ?
end_buffer_async_write+0x0/0x11d
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292711]  [<ffffffff810f97ca>] ?
writeback_single_inode+0xe3/0x2d6
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292713]  [<ffffffff810fa40e>] ?
writeback_inodes_wb+0x362/0x439
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292716]  [<ffffffff810fa618>] ?
wb_writeback+0x133/0x1b2
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292719]  [<ffffffff810fa884>] ?
wb_do_writeback+0x145/0x15b
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292721]  [<ffffffff810fa8cb>] ?
bdi_writeback_task+0x31/0x9d
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292724]  [<ffffffff810bfd7e>] ?
bdi_start_fn+0x0/0xd2
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292726]  [<ffffffff810bfdee>] ?
bdi_start_fn+0x70/0xd2
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292728]  [<ffffffff810bfd7e>] ?
bdi_start_fn+0x0/0xd2
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292731]  [<ffffffff8105d4cd>] ?
kthread+0x79/0x81
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292733]  [<ffffffff81009824>] ?
kernel_thread_helper+0x4/0x10
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292735]  [<ffffffff8105d454>] ?
kthread+0x0/0x81
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292737]  [<ffffffff81009820>] ?
kernel_thread_helper+0x0/0x10
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292739] ---[ end trace
4eaa2a86a8e2da7c ]---
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292751] ------------[ cut here
]------------
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292753] WARNING: at
fs/quota/dquot.c:984 dquot_claim_space+0x98/0x109()
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292755] Hardware name: X8SIL
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292755] Modules linked in:
xt_multiport iptable_filter ip_tables x_tables quota_v1 snd_pcm snd_timer
tpm_tis snd tpm tpm_bios evdev soundcore snd_page_alloc psmouse i2c_i801
serio_raw pcspkr i2c_core processor ext4 mbcache jbd2 crc16 sd_mod crc_t10dif
ata_generic ata_piix libata scsi_mod ide_pci_generic e1000e ide_core ehci_hcd
button thermal fan thermal_sys [last unloaded: scsi_wait_scan]
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292772] Pid: 1912, comm: flush-8:0
Tainted: G        W  2.6.33-rc4 #1
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292773] Call Trace:
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292775]  [<ffffffff8111d4cd>] ?
dquot_claim_space+0x98/0x109
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292777]  [<ffffffff8111d4cd>] ?
dquot_claim_space+0x98/0x109
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292780]  [<ffffffff81045791>] ?
warn_slowpath_common+0x77/0xa3
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292782]  [<ffffffff8111d4cd>] ?
dquot_claim_space+0x98/0x109
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292787]  [<ffffffffa00ff063>] ?
ext4_get_blocks+0x2d9/0x3a4 [ext4]
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292793]  [<ffffffffa00ff5ac>] ?
mpage_da_map_blocks+0xa4/0x579 [ext4]
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292795]  [<ffffffff810b3eb6>] ?
pagevec_lookup_tag+0x1a/0x21
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292798]  [<ffffffff810b2ab5>] ?
write_cache_pages+0x118/0x29f
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292803]  [<ffffffffa01001ea>] ?
__mpage_da_writepage+0x0/0x146 [ext4]
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292809]  [<ffffffffa00fff5d>] ?
ext4_da_writepages+0x4dc/0x6c8 [ext4]
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292811]  [<ffffffff810ffa5f>] ?
end_buffer_async_write+0x0/0x11d
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292814]  [<ffffffff810f97ca>] ?
writeback_single_inode+0xe3/0x2d6
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292817]  [<ffffffff810fa40e>] ?
writeback_inodes_wb+0x362/0x439
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292819]  [<ffffffff810fa618>] ?
wb_writeback+0x133/0x1b2
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292822]  [<ffffffff810fa884>] ?
wb_do_writeback+0x145/0x15b
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292824]  [<ffffffff810fa8cb>] ?
bdi_writeback_task+0x31/0x9d
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292827]  [<ffffffff810bfd7e>] ?
bdi_start_fn+0x0/0xd2
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292829]  [<ffffffff810bfdee>] ?
bdi_start_fn+0x70/0xd2
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292832]  [<ffffffff810bfd7e>] ?
bdi_start_fn+0x0/0xd2
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292834]  [<ffffffff8105d4cd>] ?
kthread+0x79/0x81
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292836]  [<ffffffff81009824>] ?
kernel_thread_helper+0x4/0x10
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292838]  [<ffffffff8105d454>] ?
kthread+0x0/0x81
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292840]  [<ffffffff81009820>] ?
kernel_thread_helper+0x0/0x10
Jan 16 22:38:35 ns3093701 kernel: [ 1247.292842] ---[ end trace
4eaa2a86a8e2da7d ]---

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
