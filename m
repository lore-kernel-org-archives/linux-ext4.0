Return-Path: <SRS0=rNbD=QL=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 072DCC282C4
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Feb 2019 22:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0E172081B
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Feb 2019 22:30:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbfBDWac convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 4 Feb 2019 17:30:32 -0500
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:59318 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726676AbfBDWac (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Feb 2019 17:30:32 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id EDD4D2AC4F
        for <linux-ext4@vger.kernel.org>; Mon,  4 Feb 2019 22:30:30 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id DF3B72ADC0; Mon,  4 Feb 2019 22:30:30 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date:   Mon, 04 Feb 2019 22:30:30 +0000
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
Message-ID: <bug-201631-13602-uVUJEYyI4b@https.bugzilla.kernel.org/>
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

--- Comment #66 from erhard_f@mailbox.org ---
Currently I am testing this, the 2 patches from Aneesh applied and the one from
Jan. So far I was not able to provoke the original bug. I faced however another
one, don't know wether it's related:

[...]
Feb 04 23:11:43 T1000 kernel: BUG: Kernel NULL pointer dereference at
0x00000028
Feb 04 23:11:43 T1000 kernel: Faulting instruction address: 0xc0000000002a20ac
Feb 04 23:11:43 T1000 kernel: Oops: Kernel access of bad area, sig: 11 [#1]
Feb 04 23:11:43 T1000 kernel: BE SMP NR_CPUS=192 NUMA PowerNV
Feb 04 23:11:43 T1000 kernel: Modules linked in: rpcsec_gss_krb5 auth_rpcgss
nfsv4 dns_resolver nfs lockd grace sunrpc sr_mod cdrom cfg80211 rfkill evdev
radeon ghash_generic gf128mul ecb xts snd_hda_codec_hdmi>
Feb 04 23:11:43 T1000 kernel: CPU: 0 PID: 218 Comm: kswapd0 Not tainted
5.0.0-rc4 #2
Feb 04 23:11:43 T1000 kernel: NIP:  c0000000002a20ac LR: c0000000002a209c CTR:
c0000000002bd280
Feb 04 23:11:43 T1000 kernel: REGS: c0000007f8c76fa0 TRAP: 0300   Not tainted 
(5.0.0-rc4)
Feb 04 23:11:43 T1000 kernel: MSR:  900000000280b032
<SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI>  CR: 44222288  XER: 00000000
Feb 04 23:11:43 T1000 kernel: CFAR: c000000000281724 DAR: 0000000000000028
DSISR: 40000000 IRQMASK: 0 
                              GPR00: c0000000002a5a48 c0000007f8c77230
c0000000011e2a00 c0000007e2cb8000 
                              GPR04: c000000000bebb70 00003fff92170000
0000000000000040 c0000007f4f9e600 
                              GPR08: c0000000011f54d8 0000000000000000
0000000000000000 0000000000000000 
                              GPR12: 0000000024222282 c000000001e2b000
c0000007e2cb8000 0000000000000000 
                              GPR16: 0000000000000001 c00a00001ed74ac0
c0000007f8c77798 0000000000000000 
                              GPR20: c00a00001ed74ac8 5deadbeef0000100
0000000020000000 c0000007f4f9e718 
                              GPR24: c0000007f4f9ea40 7c00000000000000
7800000000000000 c0000007f4f9ea38 
                              GPR28: c0000007f4f9e600 c0000007d18cfa90
c00a00001ed74ac0 c00a00001ed74ac0 
Feb 04 23:11:43 T1000 kernel: NIP [c0000000002a20ac] .is_ext4_page+0x3c/0x4b0
Feb 04 23:11:43 T1000 kernel: LR [c0000000002a209c] .is_ext4_page+0x2c/0x4b0
Feb 04 23:11:43 T1000 kernel: Call Trace:
Feb 04 23:11:43 T1000 kernel: [c0000007f8c77230] [c0000007f9d0d880]
0xc0000007f9d0d880 (unreliable)
Feb 04 23:11:43 T1000 kernel: [c0000007f8c772b0] [c0000000002a5a48]
.get_ext4_bh_nowarn+0x18/0x80
Feb 04 23:11:43 T1000 kernel: [c0000007f8c77330] [c0000000002b963c]
.page_vma_mapped_walk+0x3c/0x9d0
Feb 04 23:11:43 T1000 kernel: [c0000007f8c77410] [c0000000002bd3d8]
.try_to_unmap_one+0x158/0x950
Feb 04 23:11:43 T1000 kernel: [c0000007f8c77560] [c0000000002bc018]
.rmap_walk_anon+0x148/0x3a0
Feb 04 23:11:43 T1000 kernel: [c0000007f8c77610] [c0000000002bf364]
.try_to_unmap+0x104/0x160
Feb 04 23:11:43 T1000 kernel: [c0000007f8c776c0] [c000000000270958]
.shrink_page_list+0x738/0x11e0
Feb 04 23:11:43 T1000 kernel: [c0000007f8c77840] [c000000000271f7c]
.shrink_inactive_list+0x34c/0x7f0
Feb 04 23:11:43 T1000 kernel: [c0000007f8c77950] [c000000000272e94]
.shrink_node_memcg+0x3c4/0x7e0
Feb 04 23:11:43 T1000 kernel: [c0000007f8c77ab0] [c0000000002733c4]
.shrink_node+0x114/0x670
Feb 04 23:11:43 T1000 kernel: [c0000007f8c77bd0] [c000000000275158]
.kswapd+0x3f8/0xc30
Feb 04 23:11:43 T1000 kernel: [c0000007f8c77d60] [c0000000000dfb6c]
.kthread+0x19c/0x1b0
Feb 04 23:11:43 T1000 kernel: [c0000007f8c77e20] [c00000000000b790]
.ret_from_kernel_thread+0x58/0x68
Feb 04 23:11:43 T1000 kernel: Instruction dump:
Feb 04 23:11:43 T1000 kernel: f8010010 f821ff81 4bfdf62d 60000000 2fa30000
419e0150 7fe3fb78 4bfdf619 
Feb 04 23:11:43 T1000 kernel: 60000000 3c82ffa1 e9230000 38849170 <e9290028>
e9290028 e8690000 78690520 
Feb 04 23:11:43 T1000 kernel: ---[ end trace 9d98850d9aa63397 ]---
[...]

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
