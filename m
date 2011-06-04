From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 36632] New: CPU load one and repeating kernel warnings after
 underlying block device disappeared
Date: Sat, 4 Jun 2011 10:40:08 GMT
Message-ID: <bug-36632-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:56173 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab1FDKkK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 Jun 2011 06:40:10 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p54Ae8Vb019963
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 4 Jun 2011 10:40:09 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=36632

           Summary: CPU load one and repeating kernel warnings after
                    underlying block device disappeared
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.38.7
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: bvanassche@acm.org
        Regression: No


This occurred while testing a storage target implementation and after having
stopped the storage target. An ext4 filesystem had been created on top of the
initiator device. After the target had been stopped, CPU load went up to one
and stayed there. Killing the processes (via killall -9) that were using the
filesystem was not possible.
Also, the following complaints appeared periodically in the system log:

kernel: sd 9:0:0:0: [sdc] Unhandled error code
kernel: sd 9:0:0:0: [sdc]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
kernel: sd 9:0:0:0: [sdc] CDB: Write(10): 2a 00 00 08 a0 58 00 00 08 00
kernel: end_request: I/O error, dev sdc, sector 565336
kernel: ------------[ cut here ]------------
kernel: WARNING: at fs/ext4/extents.c:3765
ext4_convert_unwritten_extents+0xf7/0x120 [ext4]()
kernel: Hardware name: P5Q DELUXE
kernel: Modules linked in: ext4 jbd2 crc16 ib_srp scsi_transport_srp scsi_tgt
fuse ip6t_LOG ipt_MASQUERADE xt_pkttype xt_TCPMSS xt_tcpudp ipt_LOG xt_limit
iptable_nat nf_nat radeon ttm drm_kms_helper drm i2c_algo_bit snd_pcm_os
eq snd_seq_device vmnet vmblock vsock vmci vmmon af_packet rdma_ucm ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT iptable_raw
iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack
ip_tables xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables
ib_ipoib ib_uverbs ib_umad mlx4_ib cpufreq_conservative cpufreq_userspace
cpufreq_powersave microcode acpi_cpufreq mperf dm_mod coretemp
snd_hda_codec_hdmi
 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer joydev hid_belkin snd
i2c_i801 soundcore intel_agp sg snd_page_alloc mlx4_core i2c_core sr_mod
intel_gtt pcspkr serio_raw cdrom asus_atk0110 button raid456 async_raid6_re
id raid6_pq 
kernel: async_xor xor async_memcpy async_tx raid10 raid0 uhci_hcd ehci_hcd
rtc_cmos sd_mod rtc_core usbcore rtc_lib edd raid1 ext3 mbcache jbd fan
ide_pci_generic ide_core ata_generic ata_piix pata_marvell ahci libahci libata
t
mal_sys hwmon [last unloaded: ib_srp]
kernel: Pid: 9217, comm: kworker/0:1 Not tainted 2.6.38.7-scst #1
kernel: Call Trace:
kernel:  [<ffffffff8104c86f>] ? warn_slowpath_common+0x7f/0xc0
kernel:  [<ffffffff8104c8ca>] ? warn_slowpath_null+0x1a/0x20
kernel:  [<ffffffffa06640b7>] ? ext4_convert_unwritten_extents+0xf7/0x120
[ext4]
kernel:  [<ffffffff813c04e9>] ? trace_hardirqs_on_thunk+0x3a/0x3c
kernel:  [<ffffffffa064676a>] ? ext4_free_io_end+0xba/0xd0 [ext4]
kernel:  [<ffffffffa06467d0>] ? ext4_end_io_nolock+0x50/0x120 [ext4]
kernel:  [<ffffffffa06468df>] ? ext4_end_io_work+0x3f/0xb0 [ext4]
kernel:  [<ffffffffa06468a0>] ? ext4_end_io_work+0x0/0xb0 [ext4]
kernel:  [<ffffffff8106766b>] ? process_one_work+0x11b/0x490
kernel:  [<ffffffff8106914f>] ? worker_thread+0x16f/0x350
kernel:  [<ffffffff81068fe0>] ? worker_thread+0x0/0x350
kernel:  [<ffffffff8106d8d6>] ? kthread+0x96/0xa0
kernel:  [<ffffffff81003cd4>] ? kernel_thread_helper+0x4/0x10
kernel:  [<ffffffff8103d7b1>] ? finish_task_switch+0x51/0xb0
kernel:  [<ffffffff813c07ac>] ? _raw_spin_unlock_irq+0x1c/0x40
kernel:  [<ffffffff813c13f1>] ? restore_args+0x0/0x30
kernel:  [<ffffffff8106d840>] ? kthread+0x0/0xa0
kernel:  [<ffffffff81003cd0>] ? kernel_thread_helper+0x0/0x10
kernel: ---[ end trace f53df40954754bc1 ]---
kernel: ext4_convert_unwritten_extents: ext4_ext_map_blocks returned error
inode#27, block=329, max_blocks=1
kernel: EXT4-fs (sdc): previous I/O error to superblock detected
kernel: EXT4-fs error (device sdc): __ext4_get_inode_loc:4779: inode #27: block
97: comm kworker/0:1: unable to read itable block
kernel: EXT4-fs error (device sdc) in ext4_reserve_inode_write:5619: IO failure
kernel: EXT4-fs (sdc): previous I/O error to superblock detected
kernel: ext4_end_io_nolock: failed to convert unwritten extents to written
extents, error is -5 io is still on inode 27 aio dio list

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
