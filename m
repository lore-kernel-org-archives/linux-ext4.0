From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 63511] New: EXT4-fs warning (device sdc):
 ext4_da_update_reserve_space:362: ino 75159523, allocated 1 with only 0
 reserved metadata blocks (releasing 162 blocks with reserved 162 data blocks)
Date: Tue, 22 Oct 2013 17:38:02 +0000
Message-ID: <bug-63511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54434 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354Ab3JVRiH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Oct 2013 13:38:07 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9E9FE2049D
	for <linux-ext4@vger.kernel.org>; Tue, 22 Oct 2013 17:38:05 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A11A0203F4
	for <linux-ext4@vger.kernel.org>; Tue, 22 Oct 2013 17:38:03 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=63511

            Bug ID: 63511
           Summary: EXT4-fs warning (device sdc):
                    ext4_da_update_reserve_space:362: ino 75159523,
                    allocated 1 with only 0 reserved metadata blocks
                    (releasing 162 blocks with reserved 162 data blocks)
           Product: File System
           Version: 2.5
    Kernel Version: 3.11.6
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: mikhail.v.gavrilov@gmail.com
        Regression: No

[ 2847.405452] EXT4-fs warning (device sdc): ext4_da_update_reserve_space:362:
ino 75159523, allocated 1 with only 0 reserved metadata blocks (releasing 162
blocks with reserved 162 data blocks)
[ 2847.405455] ------------[ cut here ]------------
[ 2847.405460] WARNING: CPU: 2 PID: 108 at fs/ext4/inode.c:363
ext4_da_update_reserve_space+0x2c4/0x330()
[ 2847.405461] Modules linked in: fuse nf_conntrack_netbios_ns
nf_conntrack_broadcast ipt_MASQUERADE ip6t_REJECT xt_conntrack ebtable_nat
ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security
ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security
iptable_raw bnep iTCO_wdt iTCO_vendor_support ppdev x86_pkg_temp_thermal
coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel microcode
btusb bluetooth rfkill serio_raw snd_hda_codec_realtek snd_hda_codec_hdmi
snd_emu10k1 i2c_i801 snd_util_mem snd_rawmidi snd_ac97_codec snd_hda_intel
ac97_bus snd_hda_codec snd_hwdep snd_seq snd_seq_device emu10k1_gp gameport
[ 2847.405485]  snd_pcm r8169 mii lpc_ich mfd_core mei_me snd_page_alloc mei
shpchp snd_timer snd soundcore parport_pc parport acpi_cpufreq mperf
binfmt_misc nfsd auth_rpcgss nfs_acl lockd sunrpc usb_storage hid_logitech_dj
i915 firewire_ohci firewire_core i2c_algo_bit crc_itu_t drm_kms_helper drm
sata_sil24 i2c_core video
[ 2847.405503] CPU: 2 PID: 108 Comm: kworker/u16:3 Tainted: G        W   
3.11.6-300.fc20.x86_64+debug #1
[ 2847.405504] Hardware name: Gigabyte Technology Co., Ltd. Z87M-D3H/Z87M-D3H,
BIOS F8 08/03/2013
[ 2847.405507] Workqueue: writeback bdi_writeback_workfn (flush-8:32)
[ 2847.405509]  0000000000000009 ffff88080d08f7a8 ffffffff81728a1c
0000000000000000
[ 2847.405512]  ffff88080d08f7e0 ffffffff8107458d 00000000000000a2
0000000000000001
[ 2847.405514]  ffff8801ad613020 ffff8807ee0037b0 ffff88080d08fa78
ffff88080d08f7f0
[ 2847.405516] Call Trace:
[ 2847.405520]  [<ffffffff81728a1c>] dump_stack+0x54/0x74
[ 2847.405523]  [<ffffffff8107458d>] warn_slowpath_common+0x7d/0xa0
[ 2847.405525]  [<ffffffff8107466a>] warn_slowpath_null+0x1a/0x20
[ 2847.405527]  [<ffffffff81285154>] ext4_da_update_reserve_space+0x2c4/0x330
[ 2847.405530]  [<ffffffff812b2377>] ext4_ext_map_blocks+0xe27/0x12a0
[ 2847.405532]  [<ffffffff812854ad>] ext4_map_blocks+0x2ed/0x560
[ 2847.405534]  [<ffffffff81288867>] ext4_writepages+0x677/0x1100
[ 2847.405537]  [<ffffffff810f67fb>] ? __module_address+0xab/0x130
[ 2847.405543]  [<ffffffff811854b1>] do_writepages+0x21/0x50
[ 2847.405545]  [<ffffffff81220420>] __writeback_single_inode+0x40/0x5a0
[ 2847.405546]  [<ffffffff81220be5>] writeback_sb_inodes+0x265/0x520
[ 2847.405548]  [<ffffffff81220f3f>] __writeback_inodes_wb+0x9f/0xd0
[ 2847.405549]  [<ffffffff81221293>] wb_writeback+0x323/0x550
[ 2847.405551]  [<ffffffff81221dae>] bdi_writeback_workfn+0x32e/0x680
[ 2847.405554]  [<ffffffff81096cf1>] process_one_work+0x211/0x6e0
[ 2847.405556]  [<ffffffff81096c85>] ? process_one_work+0x1a5/0x6e0
[ 2847.405558]  [<ffffffff810972dd>] worker_thread+0x11d/0x3a0
[ 2847.405560]  [<ffffffff810971c0>] ? process_one_work+0x6e0/0x6e0
[ 2847.405565]  [<ffffffff8109fe6d>] kthread+0xed/0x100
[ 2847.405568]  [<ffffffff8109fd80>] ? insert_kthread_work+0x80/0x80
[ 2847.405577]  [<ffffffff8173bcac>] ret_from_fork+0x7c/0xb0
[ 2847.405580]  [<ffffffff8109fd80>] ? insert_kthread_work+0x80/0x80
[ 2847.405581] ---[ end trace 07f881d6e2978ecc ]---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
