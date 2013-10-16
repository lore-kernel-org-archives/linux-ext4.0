From: Davidlohr Bueso <davidlohr@hp.com>
Subject: still running into WARNING: CPU: at fs/ext4/inode.c:230
 ext4_evict_inode+0x4a6/0x4e0
Date: Tue, 15 Oct 2013 19:02:04 -0700
Message-ID: <1381888924.2371.5.camel@buesod1.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello Jan,

Just wanted to let you know I hit this[1] again on Linus' latest. The
setup/workload is *identical* to the reported one a few months ago.

[1] https://lkml.org/lkml/2013/8/1/532

Here's the complete output, I hope it helps...

------------[ cut here ]------------
WARNING: CPU: 42 PID: 74607 at fs/ext4/inode.c:230 ext4_evict_inode+0x4a6/0x4e0 [ext4]()
Modules linked in: fuse autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand pcc_cpufreq ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 uinput iTCO_wdt iTCO_vendor_support ipmi_si ipmi_msghandler microcode pcspkr serio_raw lpc_ich mfd_core sg hpilo hpwdt i7core_edac edac_core netxen_nic freq_table ext4 jbd2 mbcache sr_mod cdrom sd_mod crc_t10dif crct10dif_common qla2xxx scsi_transport_fc scsi_tgt pata_acpi ata_generic ata_piix hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core dm_mirror dm_region_hash dm_log dm_mod
CPU: 42 PID: 74607 Comm: reaim Tainted: G        W    3.12.0-rc5 #40
Hardware name: HP ProLiant DL980 G7, BIOS P66 08/31/2222
 00000000000000e6 ffff8908c6c59d28 ffffffff81550dd8 00000000000000e6
 0000000000000000 ffff8908c6c59d68 ffffffff8104e29c ffff8908c6c59d78
 ffff880afae83500 ffff880afae83608 ffff880afae83450 ffff880afae83500
Call Trace:
 [<ffffffff81550dd8>] dump_stack+0x49/0x61
 [<ffffffff8104e29c>] warn_slowpath_common+0x8c/0xc0
 [<ffffffff8104e2ea>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa03afe16>] ext4_evict_inode+0x4a6/0x4e0 [ext4]
 [<ffffffff81197ab7>] evict+0xa7/0x1c0
 [<ffffffff81197cbf>] iput_final+0xef/0x190
 [<ffffffff81197d9e>] iput+0x3e/0x50
 [<ffffffff81195858>] d_kill+0xd8/0x110
 [<ffffffff81195a1b>] dput+0x18b/0x1c0
 [<ffffffff8117f588>] __fput+0x188/0x270
 [<ffffffff8117f73e>] ____fput+0xe/0x10
 [<ffffffff8106d0bf>] task_work_run+0x8f/0xf0
 [<ffffffff81003a84>] do_notify_resume+0x84/0x90
 [<ffffffff8155d9da>] int_signal+0x12/0x17
---[ end trace ea7184a5fb48e185 ]---


Thanks,
Davidlohr
