Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44268 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727673AbeK1Vma (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 28 Nov 2018 16:42:30 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5E8B12CFBE
        for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2018 10:41:17 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Wed, 28 Nov 2018 10:41:17 +0000
Message-ID: <bug-201631-13602-lO6j67MLSo@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #4 from erhard_f@mailbox.org ---
Next occurrence on 4.20-rc4, during building clang:

[ 1211.616339] WARNING: CPU: 18 PID: 15049 at fs/ext4/inode.c:3927
.ext4_set_page_dirty+0x70/0xb0
[ 1211.616469] Modules linked in: rpcsec_gss_krb5 auth_rpcgss nfsv4
dns_resolver nfs lockd grace sunrpc cfg80211 rfkill evdev radeon ghash_generic
gf128mul ecb snd_hda_codec_hdmi xts snd_hda_intel i2c_algo_bit ttm mptsas
snd_hda_codec scsi_transport_sas drm_kms_helper xhci_pci mptscsih cbc mptbase
snd_hwdep xhci_hcd snd_hda_core cfbfillrect cfbimgblt syscopyarea tg3
vmx_crypto powernv_flash sysimgblt scsi_mod snd_pcm sysfillrect mtd fb_sys_fops
opal_prd cfbcopyarea ibmpowernv crc32c_vpmsum drm usbcore snd_timer at24 snd
libphy drm_panel_orientation_quirks backlight usb_common soundcore hwmon
nx_compress 842 842_decompress 842_compress lz4 lz4_compress lz4_decompress
zram zsmalloc
[ 1211.616544] CPU: 18 PID: 15049 Comm: debugedit Not tainted 4.20.0-rc4 #1
[ 1211.616549] NIP:  c0000000004279a0 LR: c000000000275740 CTR:
c000000000427930
[ 1211.616554] REGS: c0002001b5e73550 TRAP: 0700   Not tainted  (4.20.0-rc4)
[ 1211.616557] MSR:  9000000000029032 <SF,HV,EE,ME,IR,DR,RI>  CR: 24082488 
XER: 20040000
[ 1211.616568] CFAR: c000000000427974 IRQMASK: 0 
               GPR00: c000000000275740 c0002001b5e737e0 c0000000011ee200
c00a00000bb46ac0 
               GPR04: 00003fffa52a0000 c0000002ed1ab186 0000000000000001
0000000000000000 
               GPR08: 0000000000000000 0000000000000000 c00a00000a60e948
0000000000000000 
               GPR12: 0000000024082482 c0002003ff7ff280 1000000000000000
c0000000011fd918 
               GPR16: 00003fffa52a0000 e61fffffffffffff c0000002ed1ab186
c0000001b3442d48 
               GPR20: 00003fffa52a1000 c00a00000bb46ac0 c0000003ee23c7a8
c0002003f061a850 
               GPR24: c0002001b53a9500 fffffffffffffe7f c0002000d3450948
0000000000000000 
               GPR28: ffffffffffffffff 00003fffa530f000 0000000000000000
c00a00000bb46ac0 
[ 1211.616602] NIP [c0000000004279a0] .ext4_set_page_dirty+0x70/0xb0
[ 1211.616607] LR [c000000000275740] .set_page_dirty+0xa0/0x150
[ 1211.616611] Call Trace:
[ 1211.616616] [c0002001b5e737e0] [c00000000027fa40] .activate_page+0xf0/0x160
(unreliable)
[ 1211.616622] [c0002001b5e73850] [c000000000275740] .set_page_dirty+0xa0/0x150
[ 1211.616629] [c0002001b5e738d0] [c0000000002be260]
.unmap_page_range+0xbf0/0xe10
[ 1211.616635] [c0002001b5e73a60] [c0000000002be7e4] .unmap_vmas+0x84/0x130
[ 1211.616640] [c0002001b5e73b00] [c0000000002c9218] .unmap_region+0xe8/0x190
[ 1211.616646] [c0002001b5e73c30] [c0000000002cb8f0] .__do_munmap+0x2f0/0x510
[ 1211.616651] [c0002001b5e73cf0] [c0000000002cbb90] .__vm_munmap+0x80/0x110
[ 1211.616656] [c0002001b5e73db0] [c0000000002cbc54] .__se_sys_munmap+0x14/0x30
[ 1211.616664] [c0002001b5e73e20] [c00000000000b3a4] system_call+0x5c/0x70
[ 1211.616668] Instruction dump:
[ 1211.616674] 71290008 4182002c e9230000 71292000 41820030 4bf6e5dd 60000000
38210070 
[ 1211.616684] e8010010 7c0803a6 4e800020 60000000 <0fe00000> e9230000 71292000
4082ffd8 
[ 1211.616694] irq event stamp: 22098
[ 1211.616699] hardirqs last  enabled at (22097): [<c00000000026ec5c>]
.free_unref_page_list+0x21c/0x3e0
[ 1211.616705] hardirqs last disabled at (22098): [<c000000000008f2c>]
program_check_common+0x14c/0x160
[ 1211.616712] softirqs last  enabled at (22008): [<c0000000009f9144>]
.__do_softirq+0x4b4/0x5e4
[ 1211.616718] softirqs last disabled at (22001): [<c0000000000d1c28>]
.irq_exit+0xf8/0x1b0
[ 1211.616722] ---[ end trace 97217f5745b818a0 ]---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
