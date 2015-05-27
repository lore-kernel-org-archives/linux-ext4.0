From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 99051] New: general protection fault in ext4_htree_store_dirent
Date: Wed, 27 May 2015 16:51:26 +0000
Message-ID: <bug-99051-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57321 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702AbbE0Qvb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 May 2015 12:51:31 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D9FA82064D
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2015 16:51:29 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 64CEF20656
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2015 16:51:27 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=99051

            Bug ID: 99051
           Summary: general protection fault in ext4_htree_store_dirent
           Product: File System
           Version: 2.5
    Kernel Version: 4.1.0-rc5
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: ernstp@gmail.com
        Regression: No

It happened on one of these filesystems:
/dev/sda1 on / type ext4
(rw,noatime,nobarrier,errors=remount-ro,data=writeback)
/dev/mapper/Storage-Storage on /media/Storage type ext4
(rw,noatime,nobarrier,errors=remount-ro,data=writeback)

With this kernel:
http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.1-rc5-unstable/

[  919.084597] general protection fault: 0000 [#1] SMP
[  919.084620] Modules linked in: ipt_REJECT nf_reject_ipv4 ppp_mppe ppp_async
crc_ccitt xt_multiport iptable_filter ip_tables x_tables cmac rfcomm bnep
rc_anysee ir_lirc_codec lirc_dev ir_xmp_decoder ir_mce_kbd_decoder
ir_sharp_decoder ir_sanyo_decoder ir_sony_decoder ir_nec_decoder ir_rc6_decoder
ir_rc5_decoder ir_jvc_decoder tda18212 cxd2820r btusb dvb_usb_anysee btbcm
dvb_usb_v2 btintel dvb_core rc_rc6_mce bluetooth media mceusb arc4 intel_rapl
iosf_mbi x86_pkg_temp_thermal intel_powerclamp snd_soc_rt5640 coretemp
snd_soc_rl6231 snd_soc_core kvm_intel snd_compress snd_pcm_dmaengine kvm
snd_seq_midi iwlmvm snd_seq_midi_event mac80211 crct10dif_pclmul snd_rawmidi
crc32_pclmul ghash_clmulni_intel aesni_intel iwlwifi snd_hda_codec_realtek
snd_hda_codec_generic snd_hda_codec_hdmi aes_x86_64 lrw snd_seq
[  919.084910]  gf128mul glue_helper ablk_helper cryptd snd_hda_intel
snd_hda_controller snd_hda_codec snd_seq_device snd_hda_core cfg80211 snd_hwdep
mei_me serio_raw snd_pcm mei lpc_ich snd_timer shpchp snd nuvoton_cir rc_core
soundcore i2c_hid snd_soc_sst_acpi mac_hid i2c_designware_platform dw_dmac
i2c_designware_core dw_dmac_core 8250_dw spi_pxa2xx_platform acpi_pad
parport_pc ppdev lp parport autofs4 hid_generic usbhid hid uas usb_storage i915
i2c_algo_bit psmouse drm_kms_helper e1000e drm ptp ahci pps_core libahci
sdhci_acpi video sdhci
[  919.085111] CPU: 1 PID: 4329 Comm: apt-check Tainted: G        W      
4.1.0-040100rc5-generic #201505250235
[  919.085145] Hardware name:
\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff
\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff/NUC5i3RYB,
BIOS RYBDWi35.86A.0246.2015.0309.1355 03/09/2015
[  919.085192] task: ffff880073ec1420 ti: ffff880270838000 task.ti:
ffff880270838000
[  919.085218] RIP: 0010:[<ffffffff811e6c4d>]  [<ffffffff811e6c4d>]
__kmalloc+0x9d/0x260
[  919.085250] RSP: 0018:ffff88027083bb28  EFLAGS: 00010286
[  919.085269] RAX: 0000000000000000 RBX: 00000000000080d0 RCX:
00000000000097e0
[  919.085294] RDX: 00000000000097df RSI: 0000000000000000 RDI:
000000000001a6c0
[  919.085318] RBP: ffff88027083bb78 R08: ffff88027ec9a6c0 R09:
ffffffff81285050
[  919.085343] R10: 00000000f53187a5 R11: 000000000f0f0f0f R12:
ffff880276001900
[  919.085367] R13: f9d41851528b70e6 R14: ffff880276001900 R15:
00000000000080d0
[  919.085392] FS:  00007ff8855be700(0000) GS:ffff88027ec80000(0000)
knlGS:0000000000000000
[  919.085421] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  919.085441] CR2: 00000000017469e8 CR3: 0000000270851000 CR4:
00000000003407e0
[  919.085465] Stack:
[  919.085473]  ffffffff81285050 ffff88006dff2360 ffffffff812b3db0
0000000000000080
[  919.085501]  ffff88027083bbc8 000000003f8050b2 ffff880075d16c98
ffff88025680aaf0
[  919.085529]  ffff88027083bc50 ffff88006dff22f8 ffff88027083bbc8
ffffffff81285050
[  919.085557] Call Trace:
[  919.085569]  [<ffffffff81285050>] ? ext4_htree_store_dirent+0x40/0x150
[  919.085593]  [<ffffffff812b3db0>] ? ext4_put_link+0x40/0x40
[  919.085614]  [<ffffffff81285050>] ext4_htree_store_dirent+0x40/0x150
[  919.085638]  [<ffffffff8129684e>] htree_dirblock_to_tree+0x23e/0x2b0
[  919.085662]  [<ffffffff812974fd>] ext4_htree_fill_tree+0x1bd/0x2e0
[  919.085685]  [<ffffffff811e7cf4>] ? kfree+0x134/0x170
[  919.085704]  [<ffffffff8128416d>] ? free_rb_tree_fname+0x5d/0x90
[  919.085725]  [<ffffffff81284584>] ext4_dx_readdir+0x1a4/0x430
[  919.085746]  [<ffffffff81284edf>] ext4_readdir+0x57f/0x660
[  919.085767]  [<ffffffff81218653>] iterate_dir+0xb3/0x140
[  919.085787]  [<ffffffff8106a62f>] ? __do_page_fault+0x1af/0x470
[  919.085809]  [<ffffffff812187fc>] SyS_getdents+0x8c/0x110
[  919.085829]  [<ffffffff812184a0>] ? filldir64+0x110/0x110
[  919.085850]  [<ffffffff8180c7b2>] system_call_fastpath+0x16/0x75
[  919.085871] Code: 05 41 35 e2 7e 4d 8b 28 49 8b 40 10 4d 85 ed 0f 84 81 01
00 00 48 85 c0 0f 84 78 01 00 00 49 63 44 24 20 49 8b 3c 24 48 8d 4a 01 <49> 8b
5c 05 00 4c 89 e8 65 48 0f c7 0f 0f 94 c0 84 c0 74 b5 49
[  919.085983] RIP  [<ffffffff811e6c4d>] __kmalloc+0x9d/0x260
[  919.086004]  RSP <ffff88027083bb28>
[  919.094783] ---[ end trace 2bc5247d655a2bad ]---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
