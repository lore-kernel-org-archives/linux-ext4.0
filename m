From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29312] New: Unmounting fails even after the underlying device
 is long gone
Date: Thu, 17 Feb 2011 19:20:45 GMT
Message-ID: <bug-29312-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:45439 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab1BQTUp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Feb 2011 14:20:45 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p1HJKjSL020084
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 17 Feb 2011 19:20:45 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29312

           Summary: Unmounting fails even after the underlying device is
                    long gone
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.38-rc5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: bart.vanassche@gmail.com
        Regression: Yes


Unmounting a filesystem after the underlying (network) device is gone used to
work with previous kernel versions but apparently doesn't work anymore with
2.6.38. Additionally, CPU load goes up to 1.0 and stays at 1.0:

# umount /mnt
umount: /mnt: device is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
# echo 1 > /sys/block/sdc/device/delete
-bash: /sys/block/sdc/device/delete: No such file or directory
# cat /proc/loadavg
1.05 1.15 1.94 1/278 8426

The following call trace was logged several times:

sd 8:0:0:0: [sdc] Unhandled error code
sd 8:0:0:0: [sdc]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
sd 8:0:0:0: [sdc] CDB: Write(10): 2a 00 00 00 01 80 00 00 08 00
end_request: I/O error, dev sdc, sector 384
------------[ cut here ]------------
WARNING: at fs/ext4/extents.c:3765 ext4_convert_unwritten_extents+0xef/0x120
[ext4]()
Hardware name: P5Q DELUXE
Modules linked in: ib_srp ext4 jbd2 crc16 scsi_transport_srp fuse ip6t_LOG
ipt_MASQUERADE xt_pkttype xt_TCPMSS xt_tcpudp ipt_LOG xt_limit iptable_nat
nf_nat radeon ttm drm_kms_helper drm i2c_algo_bit snd_pcm_oss snd_mixer_oss
snd_seq snd_seq_device af_packet rdma_ucm ib_ipoib ib_uverbs ib_umad
cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf
mlx4_ib ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw xt_NOTRACK
ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle
nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables
ip6table_filter ip6_tables x_tables loop dm_mod coretemp snd_hda_codec_hdmi
snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer sg
i2c_i801 snd sr_mod soundcore snd_page_alloc pcspkr hid_belkin cdrom skge
mlx4_core button sky2 i2c_core raid456 async_raid6_recov async_pq usbhid hid
raid6_pq async_xor xor async_memcpy async_tx raid10 raid0 uhci_hcd rtc_cmos
rtc_core ehci_hcd rtc_
lib usbcore sd_mod edd raid1 ext3 mbcache jbd fan ata_generic ata_piix
pata_marvell ahci libahci libata thermal processor thermal_sys hwmon [last
unloaded: ib_srp]
Pid: 20, comm: kworker/1:1 Not tainted 2.6.38-rc5-tcm+ #3
Call Trace:
 [<ffffffff8103fe0a>] ? warn_slowpath_common+0x7a/0xb0
 [<ffffffff8103fe55>] ? warn_slowpath_null+0x15/0x20
 [<ffffffffa05addef>] ? ext4_convert_unwritten_extents+0xef/0x120 [ext4]
 [<ffffffffa0599948>] ? ext4_end_io_nolock+0x48/0x110 [ext4]
 [<ffffffffa0599a4a>] ? ext4_end_io_work+0x3a/0xb0 [ext4]
 [<ffffffffa0599a10>] ? ext4_end_io_work+0x0/0xb0 [ext4]
 [<ffffffff8105490f>] ? process_one_work+0xff/0x370
 [<ffffffff810560d1>] ? worker_thread+0x161/0x330
 [<ffffffff81055f70>] ? worker_thread+0x0/0x330
 [<ffffffff8105a6c6>] ? kthread+0x96/0xa0
 [<ffffffff81003a94>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff8105a630>] ? kthread+0x0/0xa0
 [<ffffffff81003a90>] ? kernel_thread_helper+0x0/0x10
---[ end trace 3e35244bb4bb9c94 ]---
ext4_convert_unwritten_extents: ext4_ext_map_blocks returned error inode#36,
block=2203, max_blocks=1
ext4_end_io_nolock: failed to convert unwritten extents to written extents,
error is -5 io is still on inode 36 aio dio list

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
