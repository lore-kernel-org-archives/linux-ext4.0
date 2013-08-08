From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60721] New: Rsync crashes due to ext4_ext_find_extent bug
Date: Thu, 08 Aug 2013 13:35:56 +0000
Message-ID: <bug-60721-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60119 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757833Ab3HHNgI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Aug 2013 09:36:08 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A619620364
	for <linux-ext4@vger.kernel.org>; Thu,  8 Aug 2013 13:36:03 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 524502034F
	for <linux-ext4@vger.kernel.org>; Thu,  8 Aug 2013 13:35:57 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=60721

            Bug ID: 60721
           Summary: Rsync crashes due to ext4_ext_find_extent bug
           Product: File System
           Version: 2.5
    Kernel Version: 3.0.65
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: zakrzewskim@wp.pl
        Regression: No

I was moving files with latest rsync like this:

rsync -a -v -z --progress -e 'ssh' --ignore-errors /home/ root@IP:/home

rsync --version
rsync  version 3.1.0pre1  protocol version 31.PR14
Copyright (C) 1996-2013 by Andrew Tridgell, Wayne Davison, and others.
Web site: http://rsync.samba.org/
Capabilities:
    64-bit files, 64-bit inums, 64-bit timestamps, 64-bit long ints,
    socketpairs, hardlinks, symlinks, IPv6, batchfiles, inplace,
    append, no ACLs, xattrs, iconv, no symtimes, prealloc

rsync comes with ABSOLUTELY NO WARRANTY.  This is free software, and you
are welcome to redistribute it under certain conditions.  See the GNU
General Public Licence for details.

Then after about 3 days rsync failed with this:

EXT4-fs error (device md2): ext4_ext_find_extent:734: inode #155453645: comm
rsync: bad                                                       
header/extent: invalid magic - magic c80b, entries 30245, max 18669(0), depth
22055(0)
------------[ cut here ]------------
kernel BUG at fs/ext4/extents.c:1998!
invalid opcode: 0000 [#1] PREEMPT SMP
CPU 1
Modules linked in: iptable_filter iptable_nat ip_tables xt_conntrack
xt_multiport r8168                                                       
xt_iprange xt_tcpudp netconsole autofs4 hwmon_vid coretemp cpufreq_ondemand
acpi_cpufreq                                                        freq_table
mperf ipt_REDIRECT nf_nat_ftp nf_conntrack_ftp nf_nat nf_conntrack_ipv4 nf_d   
                                                   efrag_ipv4 xt_state x_tables
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack                    
                                   be2iscsi iscsi_boot_sysfs ib_iser rdma_cm
ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscs                                  
                    i_tcp bnx2i cnic uio ipv6 cxgb3i libcxgbi cxgb3 mdio
libiscsi_tcp libiscsi scsi_transpor                                            
          t_iscsi ext3 jbd dm_mirror dm_multipath scsi_dh sbs sbshc pci_slot
hed battery acpi_memh                                                      
otplug acpi_ipmi ipmi_msghandler ac lp sg video eeepc_wmi asus_wmi
sparse_keymap hwmon r                                                      
fkill xhci_hcd wmi mii button serio_raw parport_pc parport tpm_tis tpm tpm_bios
i2c_i801                                                        i2c_core
iTCO_wdt iTCO_vendor_support shpchp pcspkr dm_region_hash dm_log dm_mod raid10 
                                                      raid456 async_raid6_recov
async_pq raid6_pq async_xor xor async_memcpy async_tx raid0 s                  
                                    ata_nv aacraid 3w_9xxx 3w_xxxx sata_sil
sata_via ahci libahci libata sd_mod scsi_mod rai                               
                       d1 ext4 jbd2 crc16 uhci_hcd ohci_hcd ehci_hcd [last
unloaded: ip_tables]

Pid: 4381, comm: rsync Tainted: G        W   3.0.65-1.el5.elrepo #1 System
manufacturer                                                        System
Product Name/P8H67-M PRO
RIP: 0010:[<ffffffffa006e23d>]  [<ffffffffa006e23d>]
ext4_ext_put_in_cache+0x26/0x65 [ex                                            
          t4]
RSP: 0018:ffff88000a4bb6f8  EFLAGS: 00010246
RAX: 0000000000000106 RBX: 00000000003fb000 RCX: 0000000000000337
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8801124a9910
RBP: ffff88000a4bb728 R08: 0000000000000106 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000337 R12: ffff8801124a9910
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000337
FS:  00007fc25ede46e0(0000) GS:ffff88081f240000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000006b32a0 CR3: 000000011d6c7000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rsync (pid: 4381, threadinfo ffff88000a4ba000, task ffff8807edb02080)
Stack:
 0001880000000001 00000000003fb000 ffff88000a4bb888 00000000fffffefa
 000000000000043d ffff8801124a9910 ffff88000a4bb818 ffffffffa00716fd
 ffff88000a4bb748 ffffffffa003c141 0000000000000003 0000000000000000
Call Trace:
 [<ffffffffa00716fd>] ext4_ext_map_blocks+0x1e6/0x6b7 [ext4]
 [<ffffffffa003c141>] ? r1bio_pool_alloc+0x20/0x22 [raid1]
 [<ffffffff810d8b32>] ? mempool_alloc_slab+0x16/0x18
 [<ffffffff8111a50a>] ? kmem_cache_alloc+0xc4/0xd3
 [<ffffffffa0050da1>] ext4_map_blocks+0x5a/0x1b2 [ext4]
 [<ffffffffa0051749>] _ext4_get_block+0x9e/0x104 [ext4]
 [<ffffffff8112815a>] ? lookup_page_cgroup+0x32/0x4b
 [<ffffffffa00517fe>] ext4_get_block+0x16/0x18 [ext4]
 [<ffffffff8115bc9d>] do_mpage_readpage+0x1d5/0x504
 [<ffffffff813e877e>] ? _raw_spin_unlock_irq+0xe/0x10
 [<ffffffff810e22cc>] ? __lru_cache_add+0x76/0x88
 [<ffffffff810d70b9>] ? lru_cache_add_file+0xe/0x10
 [<ffffffffa00517e8>] ? noalloc_get_block_write+0x24/0x24 [ext4]
 [<ffffffff8115c105>] mpage_readpages+0xd7/0x124
 [<ffffffffa00517e8>] ? noalloc_get_block_write+0x24/0x24 [ext4]
 [<ffffffffa004f9e0>] ext4_readpages+0x1f/0x21 [ext4]
 [<ffffffff810e0ea2>] read_pages+0x50/0xe6
 [<ffffffff8103830e>] ? wakeup_gran+0x14/0x16
 [<ffffffff810e1026>] __do_page_cache_readahead+0xee/0x111
 [<ffffffff810e106a>] ra_submit+0x21/0x25
 [<ffffffff810e130d>] ondemand_readahead+0x164/0x177
 [<ffffffff810e138d>] page_cache_async_readahead+0x6d/0x7a
 [<ffffffff810d7618>] do_generic_file_read+0x112/0x392
 [<ffffffff810d6225>] ? iov_iter_copy_from_user_atomic+0x86/0x86
 [<ffffffff810d85b7>] generic_file_aio_read+0x1df/0x224
 [<ffffffff8128530d>] ? tty_wakeup+0x5c/0x61
 [<ffffffff8112c200>] do_sync_read+0xc7/0x10b
 [<ffffffff8115c8c2>] ? srcu_read_unlock+0x9/0xb
 [<ffffffff811b2f02>] ? fsnotify_perm+0x6b/0x77
 [<ffffffff811b2f6d>] ? security_file_permission+0x2c/0x31
 [<ffffffff8112c2f0>] ? rw_verify_area+0xac/0xdb
 [<ffffffff8112c926>] vfs_read+0xad/0x105
 [<ffffffff8112cbdd>] sys_read+0x4c/0x72
 [<ffffffff813ee442>] system_call_fastpath+0x16/0x1b
Code: 89 d0 5b c9 c3 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 08 66 66
66 66 90 8                                                       5 d2 49 89 fc
41 89 f6 41 89 d5 49 89 cf 75 04 <0f> 0b eb fe 48 8d 9f d4 02 00 00 48 89      
                                                 df e8 dc fe ff ff 49 8d
RIP  [<ffffffffa006e23d>] ext4_ext_put_in_cache+0x26/0x65 [ext4]
 RSP <ffff88000a4bb6f8>
---[ end trace 411963ec18d7493a ]---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
