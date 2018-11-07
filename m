Return-Path: <SRS0=XuXQ=NS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54470 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726363AbeKHDpm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Nov 2018 22:45:42 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id ADD532BE62
        for <linux-ext4@vger.kernel.org>; Wed,  7 Nov 2018 18:14:08 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] New: WARNING: CPU: 11 PID: 29593 at
 fs/ext4/inode.c:3927 .ext4_set_page_dirty+0x70/0xb0
Date: Wed, 07 Nov 2018 18:14:07 +0000
Message-ID: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

            Bug ID: 201631
           Summary: WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
                    .ext4_set_page_dirty+0x70/0xb0
           Product: File System
           Version: 2.5
    Kernel Version: 4.20-rc1
          Hardware: PPC-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: erhard_f@mailbox.org
        Regression: No

Created attachment 279373
  --> https://bugzilla.kernel.org/attachment.cgi?id=279373&action=edit
kernel config

[ 3894.535640] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
.ext4_set_page_dirty+0x70/0xb0
[ 3894.535794] Modules linked in: rpcsec_gss_krb5 auth_rpcgss nfsv4
dns_resolver nfs lockd grace sunrpc cfg80211 rfkill radeon evdev ghash_generic
i2c_algo_bit gf128mul snd_hda_codec_hdmi ttm ecb drm_kms_helper snd_hda_intel
snd_hda_codec cfbfillrect cfbimgblt mptsas syscopyarea sysimgblt xts snd_hwdep
sysfillrect snd_hda_core scsi_transport_sas fb_sys_fops cfbcopyarea xhci_pci
drm snd_pcm xhci_hcd mptscsih mptbase snd_timer ctr usbcore tg3 scsi_mod cbc
at24 snd powernv_flash drm_panel_orientation_quirks backlight libphy usb_common
mtd soundcore ibmpowernv vmx_crypto opal_prd hwmon crc32c_vpmsum lz4
lz4_compress lz4_decompress zram zsmalloc
[ 3894.535880] CPU: 11 PID: 29593 Comm: debugedit Not tainted 4.20.0-rc1 #1
[ 3894.535886] NIP:  c000000000401d40 LR: c000000000250440 CTR:
c000000000401cd0
[ 3894.535893] REGS: c0000003c6d9f560 TRAP: 0700   Not tainted  (4.20.0-rc1)
[ 3894.535898] MSR:  9000000000029032 <SF,HV,EE,ME,IR,DR,RI>  CR: 24082488 
XER: 20040000
[ 3894.535913] CFAR: c000000000401d14 IRQMASK: 0 
               GPR00: c000000000250440 c0000003c6d9f7e8 c0000000011d5d00
c00a00800786e640 
               GPR04: 00003fffb263e000 c0002001e1b99186 0000000000000001
0000000000000000 
               GPR08: 0000000000000000 0000000000000000 c00a0080095480c8
0000000000000000 
               GPR12: 0000000024082488 c0000003ffffb400 1000000000000000
c0000000011e3918 
               GPR16: 00003fffb263e000 e61fffffffffffff c0002001e1b99186
c0002003e3a30960 
               GPR20: 00003fffb263f000 c00a00800786e640 c00000035c777ab8
c0000003c7692850 
               GPR24: c0000003645aa1f0 fffffffffffffe7f c0000003c55b3c98
0000000000000000 
               GPR28: ffffffffffffffff 00003fffb2649000 0000000000000000
c00a00800786e640 
[ 3894.535957] NIP [c000000000401d40] .ext4_set_page_dirty+0x70/0xb0
[ 3894.535965] LR [c000000000250440] .set_page_dirty+0xa0/0x150
[ 3894.535970] Call Trace:
[ 3894.535976] [c0000003c6d9f7e8] [c000000000247908]
.__get_free_pages+0x18/0x70 (unreliable)
[ 3894.535984] [c0000003c6d9f858] [c000000000250440] .set_page_dirty+0xa0/0x150
[ 3894.535994] [c0000003c6d9f8d8] [c000000000298de0]
.unmap_page_range+0xbf0/0xe10
[ 3894.536001] [c0000003c6d9fa68] [c000000000299364] .unmap_vmas+0x84/0x130
[ 3894.536009] [c0000003c6d9fb08] [c0000000002a3d98] .unmap_region+0xe8/0x190
[ 3894.536016] [c0000003c6d9fc38] [c0000000002a6470] .__do_munmap+0x2f0/0x510
[ 3894.536024] [c0000003c6d9fcf8] [c0000000002a6710] .__vm_munmap+0x80/0x110
[ 3894.536031] [c0000003c6d9fdb8] [c0000000002a67d4] .__se_sys_munmap+0x14/0x30
[ 3894.536040] [c0000003c6d9fe28] [c00000000000b3a4] system_call+0x5c/0x70
[ 3894.536046] Instruction dump:
[ 3894.536053] 71290008 4182002c e9230000 71292000 41820030 4bf6e8fd 60000000
38210070 
[ 3894.536066] e8010010 7c0803a6 4e800020 60000000 <0fe00000> e9230000 71292000
4082ffd8 
[ 3894.536080] irq event stamp: 18532
[ 3894.536087] hardirqs last  enabled at (18531): [<c00000000024a120>]
.get_page_from_freelist+0x2b0/0x1940
[ 3894.536094] hardirqs last disabled at (18532): [<c000000000008f2c>]
program_check_common+0x14c/0x160
[ 3894.536103] softirqs last  enabled at (18306): [<c0000000009b2384>]
.__do_softirq+0x4b4/0x5e4
[ 3894.536111] softirqs last disabled at (18299): [<c0000000000b2128>]
.irq_exit+0xf8/0x1b0
[ 3894.536117] ---[ end trace ca79a42e82947be5 ]---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
