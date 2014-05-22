From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76731] New: WARNING: CPU: 2 PID: 1620 at fs/sysfs/group.c:216
 when mounting an external disk
Date: Thu, 22 May 2014 14:18:26 +0000
Message-ID: <bug-76731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39682 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaEVOSa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 May 2014 10:18:30 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4029B20172
	for <linux-ext4@vger.kernel.org>; Thu, 22 May 2014 14:18:29 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 2993C20179
	for <linux-ext4@vger.kernel.org>; Thu, 22 May 2014 14:18:27 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=76731

            Bug ID: 76731
           Summary: WARNING: CPU: 2 PID: 1620 at fs/sysfs/group.c:216 when
                    mounting an external disk
           Product: File System
           Version: 2.5
    Kernel Version: 3.14
          Hardware: i386
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: m.s.tsirkin@gmail.com
        Regression: No

I have a disk that I attach through USB.
Whenever I attach and kde tries to mount it,
I get this warning in dmesg and mount seems to fail.

afterwards if I mount from command line,
it appears to work fine.

the error is probably down to device still spinning up
or something, but it does not seem to be
handled properly in kernel.

[1797303.008198] Buffer I/O error on device sdb6, logical block 360448
[1797303.008202] lost page write due to I/O error on sdb6
[1797303.008214] JBD2: Error -5 detected when updating journal superblock for
sdb6-8.
[1797303.008528] ------------[ cut here ]------------
[1797303.008534] WARNING: CPU: 2 PID: 1620 at fs/sysfs/group.c:216
sysfs_remove_group+0x93/0xa0()
[1797303.008535] sysfs group ffffffff81ca52a0 not found for kobject
'target31:0:0'
[1797303.008536] Modules linked in: cdc_acm xfs libcrc32c btrfs xor raid6_pq
vfat fat usb_storage ccm arc4 iwldvm mac80211 fuse ipt_MASQUERADE xt_CHECKSUM
ip6t_rpfilter ip6t_REJECT tun xt_conntrack ebtable_nat ebtable_broute bridge
stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6
nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter
ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
nf_conntrack iptable_mangle iptable_security iptable_raw rfcomm bnep
snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic iwlwifi
x86_pkg_temp_thermal coretemp kvm_intel cfg80211 kvm iTCO_wdt
iTCO_vendor_support snd_hda_intel snd_hda_codec btusb snd_hwdep snd_seq
uvcvideo bluetooth sdhci_pci crc32c_intel e1000e snd_seq_device sdhci
ghash_clmulni_intel
[1797303.008566]  mmc_core snd_pcm videobuf2_vmalloc videobuf2_memops microcode
videobuf2_core videodev thinkpad_acpi serio_raw i2c_i801 pcspkr snd_timer snd
6lowpan_iphc lpc_ich ptp mfd_core shpchp pps_core soundcore wmi tpm_tis rfkill
tpm binfmt_misc uinput i915 i2c_algo_bit drm_kms_helper drm i2c_core
firewire_ohci firewire_core crc_itu_t video
[1797303.008582] CPU: 2 PID: 1620 Comm: kio_http Tainted: G        W   
3.14.0-mst #298
[1797303.008583] Hardware name: LENOVO 4243BQ9/4243BQ9, BIOS 8AET57WW (1.37 )
04/05/2012
[1797303.008584]  0000000000000009 ffff880062d91a68 ffffffff8168b085
ffff880062d91ab0
[1797303.008586]  ffff880062d91aa0 ffffffff8107038d 0000000000000000
ffffffff81ca52a0
[1797303.008587]  ffff88000ca6bc38 ffff88012116b190 ffff8800d0b16000
ffff880062d91b00
[1797303.008589] Call Trace:
[1797303.008593]  [<ffffffff8168b085>] dump_stack+0x45/0x56
[1797303.008597]  [<ffffffff8107038d>] warn_slowpath_common+0x7d/0xa0
[1797303.008599]  [<ffffffff810703fc>] warn_slowpath_fmt+0x4c/0x50
[1797303.008601]  [<ffffffff8122cce8>] ? kernfs_find_and_get_ns+0x48/0x60
[1797303.008603]  [<ffffffff8122b953>] sysfs_remove_group+0x93/0xa0
[1797303.008606]  [<ffffffff8141d523>] dpm_sysfs_remove+0x43/0x50
[1797303.008609]  [<ffffffff81413115>] device_del+0x45/0x1c0
[1797303.008612]  [<ffffffff814430a7>] scsi_target_reap_usercontext+0x27/0x40
[1797303.008614]  [<ffffffff810899b7>] execute_in_process_context+0x67/0x70
[1797303.008616]  [<ffffffff81444504>] scsi_target_reap+0xc4/0xf0
[1797303.008619]  [<ffffffff81446578>]
scsi_device_dev_release_usercontext+0x188/0x1c0
[1797303.008621]  [<ffffffff810899b7>] execute_in_process_context+0x67/0x70
[1797303.008622]  [<ffffffff814463ec>] scsi_device_dev_release+0x1c/0x20
[1797303.008624]  [<ffffffff814127b2>] device_release+0x32/0xa0
[1797303.008627]  [<ffffffff81312cc7>] kobject_cleanup+0x77/0x1b0
[1797303.008629]  [<ffffffff81312b80>] kobject_put+0x30/0x60
[1797303.008631]  [<ffffffff81412aa7>] put_device+0x17/0x20
[1797303.008633]  [<ffffffff81437a7b>] scsi_device_put+0x3b/0x50
[1797303.008635]  [<ffffffff8144af20>] scsi_disk_put+0x30/0x50
[1797303.008637]  [<ffffffff8144b262>] sd_release+0x42/0xd0
[1797303.008639]  [<ffffffff811ee7dc>] __blkdev_put+0x17c/0x1b0
[1797303.008641]  [<ffffffff811ee772>] __blkdev_put+0x112/0x1b0
[1797303.008643]  [<ffffffff811ef11c>] blkdev_put+0x4c/0x120
[1797303.008645]  [<ffffffff811b7c04>] kill_block_super+0x44/0x70
[1797303.008647]  [<ffffffff811b7ecd>] deactivate_locked_super+0x3d/0x60
[1797303.008648]  [<ffffffff811b8476>] deactivate_super+0x46/0x60
[1797303.008650]  [<ffffffff811d3fe1>] mntput_no_expire+0xd1/0x160
[1797303.008652]  [<ffffffff811d4096>] mntput+0x26/0x40
[1797303.008654]  [<ffffffff811b732a>] __fput+0x16a/0x230
[1797303.008655]  [<ffffffff811b743e>] ____fput+0xe/0x10
[1797303.008657]  [<ffffffff8108f5ac>] task_work_run+0xbc/0xe0
[1797303.008659]  [<ffffffff810717b6>] do_exit+0x2a6/0xa40
[1797303.008661]  [<ffffffff81072d5f>] do_group_exit+0x3f/0xa0
[1797303.008663]  [<ffffffff81072dd4>] SyS_exit_group+0x14/0x20
[1797303.008665]  [<ffffffff8169c65c>] sysenter_dispatch+0x7/0x21
[1797303.008666] ---[ end trace 1c50160f2659195a ]---
[1797306.280983] SELinux: initialized (dev sdc2, type fuseblk), uses
genfs_contexts

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
