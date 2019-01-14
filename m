Return-Path: <SRS0=NmFT=PW=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:57044 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726777AbfANUcp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 14 Jan 2019 15:32:45 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 6078A2A13A
        for <linux-ext4@vger.kernel.org>; Mon, 14 Jan 2019 20:32:44 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 202269] New: kernel BUG at fs/buffer.c:3374!
Date: Mon, 14 Jan 2019 20:32:43 +0000
Message-ID: <bug-202269-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=202269

            Bug ID: 202269
           Summary: kernel BUG at fs/buffer.c:3374!
           Product: File System
           Version: 2.5
    Kernel Version: 4.19.14
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: selk@dragora.org
        Regression: No

Created attachment 280473
  --> https://bugzilla.kernel.org/attachment.cgi?id=280473&action=edit
kernel BUG at fs/buffer.c:3374!

[34274.790830] ------------[ cut here ]------------
[34274.791144] kernel BUG at fs/buffer.c:3374!
[34274.791465] invalid opcode: 0000 [#2] SMP NOPTI
[34274.791779] CPU: 1 PID: 13949 Comm: rm Tainted: G      D
4.19.14-gnu #2
[34274.792095] Hardware name: System manufacturer System Product
Name/CROSSHAIR
VI HERO, BIOS 6401 12/07/2018
[34274.792671] RIP: 0010:free_buffer_head+0x16/0x49
[34274.792983] Code: 0f 00 00 7e 0d 48 89 45 f8 e8 4f e8 ff ff 48 8b 45 f8
c9 c3 0f 1f 44 00 00 55 48 8b 47 48 48 8d 57 48 48 89 e5 48 39 c2 74 02 <0f>
0b 48 89 fe 48 8b 3d 27 54 48 01 e8 08 94 fa ff 65 ff 0d cb e2
[34274.793824] RSP: 0018:ffffb464913dfa88 EFLAGS: 00010286
[34274.794138] RAX: 63ff9073344bc5f8 RBX: ffff9073344bc5b0 RCX:
0000000000000000[34274.794455] RDX: ffff9073344bc5f8 RSI: ffffb464913dfa98
RDI: ffff9073344bc5b0[34274.794771] RBP: ffffb464913dfa88 R08:
ffffffffafc056e8 R09: ffffffffaea1130e[34274.795087] R10: ffffb464913dfb90
R11: ffff907354132420 R12: ffff907354132498[34274.795402] R13:
0000000000000001 R14: 0000000000000000 R15: ffff9073344bc5b0[34274.795718]
FS:  00007f908c09a918(0000) GS:ffff907396c40000(0000) knlGS:0000000000000000
[34274.796037] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[34274.796349] CR2: 00007f908c5f9ff0 CR3: 000000002b6d6000 CR4:
00000000003406e0[34274.796665] Call Trace:
[34274.796972]  try_to_free_buffers+0xb8/0xe1
[34274.797282]  jbd2_journal_try_to_free_buffers+0x6d/0xdf
[34274.797594]  ext4_releasepage+0x8d/0xa0
[34274.797903]  try_to_release_page+0x57/0x68
[34274.798213]  block_invalidatepage+0xe2/0xef
[34274.798523]  ext4_invalidatepage+0x92/0x9b
[34274.798834]  do_invalidatepage+0x2b/0x2e
[34274.799144]  truncate_cleanup_page+0x63/0x8c
[34274.799453]  truncate_inode_pages_range+0x192/0x493
[34274.799767]  ? __rt_mutex_slowlock+0xb5/0xd3
[34274.800079]  truncate_inode_pages+0x12/0x14
[34274.800390]  truncate_inode_pages_final+0x41/0x46
[34274.800701]  ext4_evict_inode+0x118/0x36a
[34274.801010]  evict+0xc0/0x175
[34274.801317]  iput+0x175/0x17d
[34274.801624]  do_unlinkat+0x130/0x1d0
[34274.801931]  __do_sys_unlinkat+0x35/0x39
[34274.802240]  __x64_sys_unlinkat+0x1a/0x1c
[34274.802552]  do_syscall_64+0x61/0x71
[34274.802860]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[34274.803172] RIP: 0033:0x7f908c08c931
[34274.803480] Code: 00 00 4c 89 c8 0f 05 48 63 7b 04 4c 89 c8 0f 05 eb 03
45 31 c0 5a 44 89 c0 5b 5d c3 48 63 ff 50 48 63 d2 b8 07 01 00 00 0f 05 <48>
89 c7 e8 84 a7 ff ff 5a c3 e9 dd 99 ff ff e9 f6 ff ff ff 8d 47
[34274.804324] RSP: 002b:00007ffcaa5617d0 EFLAGS: 00000246 ORIG_RAX:
0000000000000107
[34274.804641] RAX: ffffffffffffffda RBX: 00007f908c5e78c0 RCX:
00007f908c08c931[34274.804956] RDX: 0000000000000000 RSI: 00007f908c5e79c8
RDI: 0000000000000005[34274.805271] RBP: 0000000000000000 R08:
0000000000000003 R09: 0000000000000000[34274.805587] R10: 0000000000000000
R11: 0000000000000246 R12: 00007ffcaa5619b8[34274.805901] R13:
00007f908c5e01a0 R14: 0000000000000002 R15: 0000000000000000[34274.806217]
Modules linked in: jc42 cfg80211 8021q garp mrp stp llc dm_mod
snd_hda_codec_realtek snd_hda_codec_hdmi nouveau kvm ttm drm_kms_helper
snd_hda_codec_generic drm irqbypass agpgart snd_hda_intel fb_sys_fops
snd_hda_codec syscopyarea sysfillrect snd_hda_core sysimgblt igb
crct10dif_pclmul snd_hwdep crc32_pclmul eeepc_wmi asus_wmi snd_pcm
sparse_keymap rfkill crc32c_intel ghash_clmulni_intel video snd_timer
sp5100_tco pcbc snd joydev dca aesni_intel i2c_piix4 wmi_bmof soundcore
i2c_algo_bit i2c_core aes_x86_64 hid_logitech mxm_wmi wmi ccp crypto_simd
cryptd glue_helper uas evdev sha1_generic gpio_amdpt pinctrl_amd k10temp
pcc_cpufreq [last unloaded: i2c_dev]
[34274.808681] ---[ end trace 166b87a61721385e ]---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
