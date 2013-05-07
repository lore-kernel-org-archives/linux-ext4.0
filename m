From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 57761] New: Total system crash - loading data into a mysql
 database (may be unrelated)
Date: Tue,  7 May 2013 21:27:22 +0000 (UTC)
Message-ID: <bug-57761-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54099 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757627Ab3EGV1Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 May 2013 17:27:25 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0177320551
	for <linux-ext4@vger.kernel.org>; Tue,  7 May 2013 21:27:24 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id D85EE20541
	for <linux-ext4@vger.kernel.org>; Tue,  7 May 2013 21:27:22 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=57761

           Summary: Total system crash - loading data into a mysql
                    database (may be unrelated)
           Product: File System
           Version: 2.5
    Kernel Version: 3.3.6-030306-generic
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: alex.holehouse@gmail.com
        Regression: No


Second time this crash has happened. At the time I was doing memory intensive
database loading, but I'm not sure if this is related.

May  7 15:59:42 Stark kernel: [151365.247034] ------------[ cut here
]------------
May  7 15:59:42 Stark kernel: [151365.247066] kernel BUG at
/home/apw/COD/linux/fs/dcache.c:816!
May  7 15:59:42 Stark kernel: [151365.247092] invalid opcode: 0000 [#1] SMP 
May  7 15:59:42 Stark kernel: [151365.247115] CPU 1 
May  7 15:59:42 Stark kernel: [151365.247126] Modules linked in: bbswitch(O)
pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O)
snd_hda_codec_hdmi(O) snd_
hda_codec_conexant(O) bnep rfcomm bluetooth parport_pc ppdev binfmt_misc joydev
arc4 snd_hda_intel(O) snd_hda_codec(O) snd_hwdep(O) snd_pcm_oss(O)
snd_mixer_oss(O
) iwlwifi snd_pcm(O) uvcvideo videobuf2_core videodev v4l2_compat_ioctl32
videobuf2_vmalloc videobuf2_memops snd_seq_dummy(O) snd_seq_oss(O)
snd_seq_midi_event(O)
 mac80211 cfg80211 snd_seq(O) snd_timer(O) snd_seq_device(O) snd(O) psmouse
serio_raw soundcore snd_page_alloc(O) mei(C) i915 ideapad_laptop sparse_keymap
drm_kms
_helper drm i2c_algo_bit wmi video mac_hid lp parport usbhid r8169 hid
May  7 15:59:42 Stark kernel: [151365.247475] 
May  7 15:59:42 Stark kernel: [151365.247485] Pid: 35, comm: kswapd0 Tainted: G
        C O 3.3.6-030306-generic #201205121335 LENOVO IdeaPad U410    /Lenovo   

May  7 15:59:42 Stark kernel: [151365.247546] RIP: 0010:[<ffffffff81199b05>] 
[<ffffffff81199b05>] prune_dcache_sb+0x1b5/0x1c0
May  7 15:59:42 Stark kernel: [151365.247589] RSP: 0018:ffff8802203d9bf0 
EFLAGS: 00010296
May  7 15:59:42 Stark kernel: [151365.247613] RAX: ffff8801cf3d9683 RBX:
ffff8801cf3d959c RCX: ffff8801cf3d95c0
May  7 15:59:42 Stark kernel: [151365.247644] RDX: ffff8801cf3d9603 RSI:
ffff8802203d9c00 RDI: ffffffff81c04400
May  7 15:59:42 Stark kernel: [151365.247677] RBP: ffff8802203d9c50 R08:
0000000000015838 R09: ffffffffffffffff

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
