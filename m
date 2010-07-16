From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [BUG] ext4 trace events cause NULL pointer dereferences
Date: Fri, 16 Jul 2010 16:48:35 +0800
Message-ID: <4C401CE3.7010004@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65456 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935991Ab0GPIoX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Jul 2010 04:44:23 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

To reproduce this bug, enable ext4 trace events, and then keep creating
files in a nealy fullly ocupied partition:

# echo 1 > debugfs/tracing/events/ext4/eanble
# df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdb7             20158332  19072148     62184 100% /
...
# cat test.sh
#! /bin/sh

for ((i = 0; ; i++))
{
        echo "create file: file_${i}.dat"

        dd if=/dev/zero of=file_${i}.dat bs=1M count=10 > /dev/null 2>&1

        if [ $? -ne 0 ]; then
                break;
        fi
}
# ./test.sh
create file: file_0.dat
create file: file_1.dat
...
create file: file_108.dat
# sync
(panic)


Seems ac->ac_inode can be NULL:

DECLARE_EVENT_CLASS(ext4__mballoc,
	...
        TP_fast_assign(
                __entry->dev            = ac->ac_inode->i_sb->s_dev;
                __entry->ino            = ac->ac_inode->i_ino;
		...
        ),
	...
);



BUG: unable to handle kernel NULL pointer dereference at 0000000000000100            
IP: [<ffffffffa00e2e2c>] ftrace_raw_event_ext4__mballoc+0x6c/0xe0 [ext4]             
PGD 37ab6067 PUD a78a4067 PMD 0                                                      
Oops: 0000 [#1] SMP                                                                  
last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map            
CPU 0                                                                                
Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat bridge stp llc autofs4 be2iscsi bnx2i cnic uio cxgb3i iw_cxgb3 cxgb3 mdio ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ext3 jbd dm_mirror dm_region_hash dm_log dm_mod e1000e i5k_amb hwmon i5000_edac iTCO_wdt sg edac_core i2c_i801 i2c_core shpchp iTCO_vendor_support ext4 mbcache jbd2 sd_mod crc_t10dif sr_mod cdrom pata_acpi ata_generic mptsas mptscsih mptbase ata_piix scsi_transport_sas [last unloaded: scsi_wait_scan]    

Pid: 902, comm: flush-8:16 Not tainted 2.6.35-rc5 #1 D2671/PRIMERGY                                                                                                       
RIP: 0010:[<ffffffffa00e2e2c>]  [<ffffffffa00e2e2c>] ftrace_raw_event_ext4__mballoc+0x6c/0xe0 [ext4]                                                                      
RSP: 0018:ffff880137fab6e0  EFLAGS: 00010206                                         
RAX: ffff880137cee738 RBX: ffff880068e40910 RCX: ffff880137cee734                    
RDX: 0000000000000000 RSI: ffffffffa010ed38 RDI: ffff880137cee73c                    
RBP: ffff880137fab720 R08: 000000a2b2177ca4 R09: 000000a2b217565f                    
R10: 0000000000000755 R11: 0000000000000001 R12: ffffffffa010ed38                    
R13: 0000000000000000 R14: ffff880137cee734 R15: 0000000000000282                    
FS:  0000000000000000(0000) GS:ffff880002400000(0000) knlGS:0000000000000000         
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b                                    
CR2: 0000000000000100 CR3: 0000000037aba000 CR4: 00000000000006f0                    
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000                    
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400                    
Process flush-8:16 (pid: 902, threadinfo ffff880137faa000, task ffff8801395a8040)    
Stack:                                                                               
 ffff880137fab770 ffff88013b2978c0 ffff880137fab710 ffff880068e40910                 
<0> ffff880138462460 ffff880137fab7d0 0000000000000001 0000000000000001              
<0> ffff880137fab770 ffffffffa00f6781 ffff880137fab770 00000022000046ce              
Call Trace:                                                                          
 [<ffffffffa00f6781>] ext4_mb_release_group_pa+0x131/0x160 [ext4]                    
 [<ffffffffa00f92a8>] ext4_mb_discard_group_preallocations+0x418/0x4d0 [ext4]        
 [<ffffffffa00fc21c>] ext4_mb_new_blocks+0x37c/0x4f0 [ext4]                          
 [<ffffffffa00f3059>] ext4_ext_map_blocks+0x1449/0x1af0 [ext4]                       
 [<ffffffff810d03d2>] ? ring_buffer_lock_reserve+0xa2/0x160                          
 [<ffffffff810ff4c6>] ? __pagevec_release+0x26/0x40                                  
 [<ffffffffa00d2b10>] ext4_map_blocks+0xe0/0x200 [ext4]                              
 [<ffffffffa00d3efd>] mpage_da_map_blocks+0xcd/0x420 [ext4]                          
 [<ffffffffa00d4a6b>] ext4_da_writepages+0x2db/0x630 [ext4]                          
 [<ffffffff8100ba2e>] ? apic_timer_interrupt+0xe/0x20                                
 [<ffffffff810fdae1>] do_writepages+0x21/0x40                                        
 [<ffffffff81163e76>] writeback_single_inode+0xc6/0x2d0                              
 [<ffffffff8116428e>] writeback_sb_inodes+0xce/0x180                                 
 [<ffffffff811643d9>] writeback_inodes_wb+0x99/0x180                                 
 [<ffffffff811646fb>] wb_writeback+0x23b/0x2a0                                       
 [<ffffffff811648cf>] wb_do_writeback+0x16f/0x180                                    
 [<ffffffff8106e1e0>] ? process_timeout+0x0/0x10                                     
 [<ffffffff81164937>] bdi_writeback_task+0x57/0x160                                  
 [<ffffffff8107d337>] ? bit_waitqueue+0x17/0xd0
 [<ffffffff8110cc60>] ? bdi_start_fn+0x0/0xe0
 [<ffffffff8110ccd1>] bdi_start_fn+0x71/0xe0
 [<ffffffff8110cc60>] ? bdi_start_fn+0x0/0xe0
 [<ffffffff8107cde6>] kthread+0x96/0xa0
 [<ffffffff8100be84>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107cd50>] ? kthread+0x0/0xa0
 [<ffffffff8100be80>] ? kernel_thread_helper+0x0/0x10
Code: ff ff 4c 89 f9 ba 28 00 00 00 45 89 e8 e8 9d f5 fe e0 48 85 c0 49 89 c6 74 51 48 89 c7 e8 1d a3 fe e0 48 8b 13 4c 89 f1 4c 89 e6 <48> 8b 92 00 01 00 00 8b 52 10 8950 0c 48 8b 13 48 8b 52 40 48
RIP  [<ffffffffa00e2e2c>] ftrace_raw_event_ext4__mballoc+0x6c/0xe0 [ext4]
 RSP <ffff880137fab6e0>
CR2: 0000000000000100
---[ end trace 28cc4a1689f1df47 ]---



BUG: unable to handle kernel NULL pointer dereference at 0000000000000040            
IP: [<ffffffffa00d73fc>] ftrace_raw_event_ext4_mb_release_group_pa+0x7c/0xe0 [ext4]  
PGD 1389fe067 PUD 1389b0067 PMD 0                                                    
Oops: 0000 [#1] SMP                                                                  
last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map            
CPU 3                                                                                
Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat bridge stp llc autofs4 be2iscsi bnx2i cnic uio cxgb3i iw_cxgb3 cxgb3 mdio ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ext3 jbd dm_mirror dm_region_hash dm_log dm_mod iTCO_wdt iTCO_vendor_support sg i5k_amb hwmon i2c_i801 i2c_core i5000_edac edac_core shpchp e1000e ext4 mbcache jbd2 sd_mod crc_t10dif sr_mod cdrom pata_acpi ata_generic mptsas mptscsih mptbase ata_piix scsi_transport_sas [last unloaded: scsi_wait_scan]    

Pid: 938, comm: flush-8:16 Not tainted 2.6.35-rc5-lizf #2 D2671/PRIMERGY                                                                                                  
RIP: 0010:[<ffffffffa00d73fc>]  [<ffffffffa00d73fc>] ftrace_raw_event_ext4_mb_release_group_pa+0x7c/0xe0 [ext4]                                                           
RSP: 0018:ffff880136ebb6d0  EFLAGS: 00010206                                         
RAX: ffff880137bdf21c RBX: ffffffffa0104470 RCX: ffff880137bdf218                    
RDX: 0000000000000000 RSI: ffffffffa0104470 RDI: ffff880137bdf220                    
RBP: ffff880136ebb720 R08: 0000003c4d0f4ef1 R09: 0000003c4d0f3c8b                    
R10: 0000000000000242 R11: 0000000000000000 R12: ffff88013904a748                    
R13: ffff8801392596d0 R14: ffff880137bdf218 R15: 0000000000000000                    
FS:  0000000000000000(0000) GS:ffff880002580000(0000) knlGS:0000000000000000         
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b                                    
CR2: 0000000000000040 CR3: 0000000138a16000 CR4: 00000000000006e0                    
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000                    
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400                    
Process flush-8:16 (pid: 938, threadinfo ffff880136eba000, task ffff880136ddd540)    
Stack:
 ffff880136e2f000 0000000000000282 ffff880136ebb770 ffff88013b2978c0
<0> ffff880136ebb710 ffff8801392596d0 ffff88013904a748 ffff880136ebb7d0
<0> ffff880136e2f000 ffff8801388054e0 ffff880136ebb770 ffffffffa00eb886
Call Trace:
 [<ffffffffa00eb886>] ext4_mb_release_group_pa+0x106/0x160 [ext4]
 [<ffffffffa00ee3d8>] ext4_mb_discard_group_preallocations+0x418/0x4d0 [ext4]
 [<ffffffffa00f134c>] ext4_mb_new_blocks+0x37c/0x4f0 [ext4]
 [<ffffffffa00e8189>] ext4_ext_map_blocks+0x1449/0x1af0 [ext4]
 [<ffffffff810d03d2>] ? ring_buffer_lock_reserve+0xa2/0x160
 [<ffffffff812155b6>] ? __prop_inc_single+0x46/0x60
 [<ffffffff810ff4c6>] ? __pagevec_release+0x26/0x40
 [<ffffffffa00c7b10>] ext4_map_blocks+0xe0/0x200 [ext4]
 [<ffffffffa00c8efd>] mpage_da_map_blocks+0xcd/0x420 [ext4]
 [<ffffffffa00c9a6b>] ext4_da_writepages+0x2db/0x630 [ext4]
 [<ffffffff810fdae1>] do_writepages+0x21/0x40
 [<ffffffff81163e76>] writeback_single_inode+0xc6/0x2d0
 [<ffffffff8116428e>] writeback_sb_inodes+0xce/0x180
 [<ffffffff811643d9>] writeback_inodes_wb+0x99/0x180
 [<ffffffff811646fb>] wb_writeback+0x23b/0x2a0
 [<ffffffff811648cf>] wb_do_writeback+0x16f/0x180
 [<ffffffff8106e1e0>] ? process_timeout+0x0/0x10
 [<ffffffff81164937>] bdi_writeback_task+0x57/0x160
 [<ffffffff8107d337>] ? bit_waitqueue+0x17/0xd0
 [<ffffffff8110cc60>] ? bdi_start_fn+0x0/0xe0
 [<ffffffff8110ccd1>] bdi_start_fn+0x71/0xe0
 [<ffffffff8110cc60>] ? bdi_start_fn+0x0/0xe0
 [<ffffffff8107cde6>] kthread+0x96/0xa0
 [<ffffffff8100be84>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107cd50>] ? kthread+0x0/0xa0
 [<ffffffff8100be80>] ? kernel_thread_helper+0x0/0x10
Code: 89 f8 e8 d8 af ff e0 48 85 c0 49 89 c6 74 45 48 89 c7 e8 58 5d ff e0 49 8b 55 08 4c 89 f1 48 89 de 8b 52 10 89 50 0c 49 8b 55 00 <48> 8b 52 40 48 89 50 10 49 8b 5424 40 48 89 50 18 41 8b 54 24
RIP  [<ffffffffa00d73fc>] ftrace_raw_event_ext4_mb_release_group_pa+0x7c/0xe0 [ext4]
 RSP <ffff880136ebb6d0>
CR2: 0000000000000040
---[ end trace 08bbe3845c7f3a09 ]---
