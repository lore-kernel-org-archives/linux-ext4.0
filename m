Return-Path: <SRS0=Sz5y=QM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 606FFC282CB
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Feb 2019 11:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 340ED2080D
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Feb 2019 11:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbfBELnf convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 5 Feb 2019 06:43:35 -0500
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:36352 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726065AbfBELnf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Feb 2019 06:43:35 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 6F3222ACF8
        for <linux-ext4@vger.kernel.org>; Tue,  5 Feb 2019 11:43:34 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 630552AD6B; Tue,  5 Feb 2019 11:43:34 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date:   Tue, 05 Feb 2019 11:43:33 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: erhard_f@mailbox.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-201631-13602-cPw13Mnrtp@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #70 from erhard_f@mailbox.org ---
(In reply to Aneesh Kumar KV from comment #69)
> Ok, can we try with only Revert-powerpc-mm-book3s-Enable-THP-migration
> patch? I am looking at whether we are getting the migration check on page
> table entries wrong.
Applied only Revert-powerpc-mm-book3s-Enable-THP-migration to -rc5. This
provokes the bug after 1 x llvm debug build (my usual test case):

[...]
[ 1596.523635] WARNING: CPU: 15 PID: 1709 at fs/ext4/inode.c:3928
.ext4_set_page_dirty+0x70/0xb0
[ 1596.523768] Modules linked in: rpcsec_gss_krb5 auth_rpcgss nfsv4
dns_resolver nfs lockd grace sunrpc
sr_mod cdrom cfg80211 rfkill radeon evdev ghash_generic gf128mul
snd_hda_codec_hdmi i2c_algo_bit ttm ecb
 drm_kms_helper snd_hda_intel snd_hda_codec xts snd_hwdep cfbfillrect
snd_hda_core cfbimgblt xhci_pci sy
scopyarea sysimgblt snd_pcm sysfillrect fb_sys_fops cbc xhci_hcd mptsas
cfbcopyarea scsi_transport_sas u
sbcore mptscsih drm tg3 vmx_crypto powernv_flash snd_timer snd libphy mtd
mptbase at24 crc32c_vpmsum ibm
powernv opal_prd scsi_mod hwmon soundcore drm_panel_orientation_quirks
backlight usb_common lz4 lz4_comp
ress lz4_decompress zram zsmalloc
[ 1596.523840] CPU: 15 PID: 1709 Comm: debugedit Not tainted 5.0.0-rc5 #1
[ 1596.523846] NIP:  c00000000040f330 LR: c00000000025bd20 CTR:
c00000000040f2c0
[ 1596.523851] REGS: c0000007b56b7530 TRAP: 0700   Not tainted  (5.0.0-rc5)
[ 1596.523854] MSR:  9000000000029032 <SF,HV,EE,ME,IR,DR,RI>  CR: 24082498 
XER: 20040000
[ 1596.523866] CFAR: c00000000040f304 IRQMASK: 0
               GPR00: c00000000025bd20 c0000007b56b77c0 c0000000011e2b00
c00a00001a63ff40
               GPR04: 00003fffa7a33000 c000000698ffd186 0000000000000001
0000000000000000
               GPR08: 0000000000000000 0000000000000000 c00a00001a63ff08
0000000000000000
               GPR12: 0000000024082492 c0000007ffffa400 c000000698ffd186
1000000000000000
               GPR16: 00003fffa7a33000 e61fffffffffffff c0000007ab96a190
c0000000011f3918
               GPR20: 00003fffa7a34000 c00a00001a63ff40 c0000004bdc64ce8
c0000007ce95fc50
               GPR24: c0000007ab5069e8 c0000007de586198 fffffffffffffe7f
0000000000000000
               GPR28: 00003fffa7a9b000 ffffffffffffffff 0000000000000000
c00a00001a63ff40
[ 1596.523898] NIP [c00000000040f330] .ext4_set_page_dirty+0x70/0xb0
[ 1596.523903] LR [c00000000025bd20] .set_page_dirty+0xa0/0x150
[ 1596.523907] Call Trace:
[ 1596.523913] [c0000007b56b77c0] [c000000000266070] .activate_page+0xf0/0x160
(unreliable)
[ 1596.523920] [c0000007b56b7830] [c00000000025bd20] .set_page_dirty+0xa0/0x150
[ 1596.523927] [c0000007b56b78b0] [c0000000002a4c90]
.unmap_page_range+0xc10/0xe10
[ 1596.523932] [c0000007b56b7a40] [c0000000002a5224] .unmap_vmas+0xa4/0x150
[ 1596.523938] [c0000007b56b7b00] [c0000000002afc18] .unmap_region+0xe8/0x190
[ 1596.523944] [c0000007b56b7c30] [c0000000002b22f0] .__do_munmap+0x2f0/0x510
[ 1596.523949] [c0000007b56b7cf0] [c0000000002b2590] .__vm_munmap+0x80/0x110
[ 1596.523955] [c0000007b56b7db0] [c0000000002b2654] .__se_sys_munmap+0x14/0x30
[ 1596.523962] [c0000007b56b7e20] [c00000000000b3a4] system_call+0x5c/0x70
[ 1596.523966] Instruction dump:
[ 1596.523971] 71290008 4182002c e9230000 71292000 41820030 4bf6d80d 60000000
38210070
[ 1596.523981] e8010010 7c0803a6 4e800020 60000000 <0fe00000> e9230000 71292000
4082ffd8               C

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
