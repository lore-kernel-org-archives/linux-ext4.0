From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 31222] New: kernel BUG at fs/ext4/mballoc.c:3141
Date: Wed, 16 Mar 2011 19:32:25 GMT
Message-ID: <bug-31222-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:52231 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab1CPTc0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Mar 2011 15:32:26 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p2GJWP9x021002
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 16 Mar 2011 19:32:25 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=31222

           Summary: kernel BUG at fs/ext4/mballoc.c:3141
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.37
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: etele_@freemail.hu
        Regression: No


The Linux system that I'm running made a stack trace in the logs, and I was
unable to access the file system where the stack trace happened.
I could only reboot the system with "reboot -f -n" options.


[1357032.081397] ------------[ cut here ]------------
[1357032.081402] kernel BUG at fs/ext4/mballoc.c:3141!
[1357032.081404] invalid opcode: 0000 [#1] SMP
[1357032.081407] last sysfs file: /sys/block/sda/sda5/stat
[1357032.081408] Modules linked in: ipt_LOG ipt_MASQUERADE xt_state iptable_nat
nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 xt_tcpudp iptable_filter
ip_tables x_tables usb_storage tun fuse multipath coretemp w83627ehf hwmon_vid
loop raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq
async_tx md_mod usblp rtc_cmos rtc_core rtc_lib i2c_i801 shpchp pci_hotplug
intel_agp intel_gtt agpgart psmouse i2c_core serio_raw evdev pcspkr button
usbhid uhci_hcd r8169 ehci_hcd sd_mod usbcore [last unloaded: scsi_wait_scan]
[1357032.081436]
[1357032.081439] Pid: 1110, comm: flush-8:0 Not tainted 2.6.37-etele-v1.1 #2
G43Twins-FullHD/To Be Filled By O.E.M.
[1357032.081442] EIP: 0060:[<c10ef07b>] EFLAGS: 00010293 CPU: 1
[1357032.081447] EIP is at ext4_mb_use_inode_pa+0xe8/0xfd
[1357032.081449] EAX: 00000012 EBX: f275de00 ECX: 017d02de EDX: 00000000
[1357032.081451] ESI: 017d0000 EDI: 00000000 EBP: f48cfb4c ESP: f48cfb28
[1357032.081453]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[1357032.081456] Process flush-8:0 (pid: 1110, ti=f48ce000 task=f54c7830
task.ti=f48ce000)
[1357032.081457] Stack:
[1357032.081459]  017d02de 00000000 f275de00 017d02ca 00000000 00000014
f275de00 e2031794
[1357032.081463]  f48cfc38 f48cfb8c c10f1490 f101ba00 c79f8400 00000014
017d02ca ed554348
[1357032.081468]  226258e8 00000000 f13c9400 0c001000 000002ca f275de00
000072ca ed554348
[1357032.081472] Call Trace:
[1357032.081476]  [<c10f1490>] ? ext4_mb_use_preallocated+0x1dc/0x1f7
[1357032.081479]  [<c10f4dde>] ? ext4_mb_new_blocks+0x168/0x3a2
[1357032.081482]  [<c10ed1ce>] ? ext4_ext_map_blocks+0x89a/0xbd0
[1357032.081485]  [<c11362ae>] ? submit_bio+0x92/0x99
[1357032.081488]  [<c10d839c>] ? ext4_map_blocks+0xda/0x169
[1357032.081491]  [<c10d8521>] ? mpage_da_map_and_submit+0xf6/0x986
[1357032.081494]  [<c107ef6b>] ? cache_alloc_refill+0x56/0x441
[1357032.081498]  [<c1142e50>] ? radix_tree_gang_lookup_tag_slot+0x76/0x95
[1357032.081502]  [<c1060fe7>] ? find_get_pages_tag+0x2d/0xc2
[1357032.081505]  [<c1067797>] ? pagevec_lookup_tag+0x1c/0x25
[1357032.081508]  [<c10db9ef>] ? ext4_da_writepages+0x771/0x920
[1357032.081512]  [<c10db27e>] ? ext4_da_writepages+0x0/0x920
[1357032.081514]  [<c106657d>] ? do_writepages+0x1c/0x28
[1357032.081518]  [<c10980c2>] ? writeback_single_inode+0x8d/0x183
[1357032.081520]  [<c1098502>] ? writeback_sb_inodes+0x82/0xe5
[1357032.081522]  [<c1098792>] ? writeback_inodes_wb+0xcc/0xdc
[1357032.081525]  [<c10988f1>] ? wb_writeback+0x14f/0x1b4
[1357032.081527]  [<c1098a38>] ? wb_do_writeback+0xe2/0x10a
[1357032.081530]  [<c1098b0b>] ? bdi_writeback_thread+0x48/0x108
[1357032.081532]  [<c1098ac3>] ? bdi_writeback_thread+0x0/0x108
[1357032.081536]  [<c103a800>] ? kthread+0x64/0x69
[1357032.081538]  [<c103a79c>] ? kthread+0x0/0x69
[1357032.081541]  [<c1002db6>] ? kernel_thread_helper+0x6/0x1a
[1357032.081542] Code: d3 8b 55 e4 03 4d e8 13 5d ec 8b 42 30 99 01 f0 11 fa 39
d3 72 0a 77 04 39 c1 76 04 0f 0b eb fe 8b 5d e4 8b 43 34 3b 45 f0 7d 04 <0f> 0b
eb fe 8b 75 e4 2b 45 f0 89 46 34 8d 65 f4 5b 5e 5f 5d c3
[1357032.081564] EIP: [<c10ef07b>] ext4_mb_use_inode_pa+0xe8/0xfd SS:ESP
0068:f48cfb28
[1357032.081569] ---[ end trace da01771ce1681d32 ]---

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
