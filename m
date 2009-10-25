From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14465] New: WARNING: at
 /build/buildd/linux-2.6.31/fs/inode.c:1212 generic_delete_inode+0x14e/0x160
Date: Sun, 25 Oct 2009 20:30:49 GMT
Message-ID: <bug-14465-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56933 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbZJYUap (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 25 Oct 2009 16:30:45 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9PKUnhp004608
	for <linux-ext4@vger.kernel.org>; Sun, 25 Oct 2009 20:30:49 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14465

               URL: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/4
                    53039
           Summary: WARNING: at /build/buildd/linux-2.6.31/fs/inode.c:1212
                    generic_delete_inode+0x14e/0x160
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.31
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: socketpair@gmail.com
        Regression: No


ct 16 17:47:14 mmarkk-laptop kernel: [ 554.606251] ------------[ cut here
]------------
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606272] WARNING: at
/build/buildd/linux-2.6.31/fs/inode.c:1212 generic_delete_inode+0x14e/0x160(
)
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606278] Hardware name: 900
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606282] Modules linked in:
nls_iso8859_1 nls_cp437 vfat fat binfmt_misc ppdev joydev arc4 ecb sn
d_hda_codec_realtek iptable_filter ip_tables x_tables snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy s
nd_seq_oss ath5k snd_seq_midi mac80211 snd_rawmidi snd_seq_midi_event led_class
uvcvideo snd_seq ath psmouse snd_timer videodev snd_seq_devic
e v4l1_compat serio_raw cfg80211 snd atl2 soundcore snd_page_alloc lp
eeepc_laptop parport fbcon tileblit font bitblit softcursor usb_storage
 i915 drm i2c_algo_bit video output intel_agp agpgart
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606380] Pid: 2300, comm: chattr Not
tainted 2.6.31-14-generic #47-Ubuntu
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606385] Call Trace:
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606398] [<c014518d>]
warn_slowpath_common+0x6d/0xa0
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606406] [<c01faf6e>] ?
generic_delete_inode+0x14e/0x160
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606413] [<c01faf6e>] ?
generic_delete_inode+0x14e/0x160
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606422] [<c01451d5>]
warn_slowpath_null+0x15/0x20
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606429] [<c01faf6e>]
generic_delete_inode+0x14e/0x160
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606438] [<c05708b8>] ?
_spin_lock+0x8/0x10
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606445] [<c01fafa5>]
generic_drop_inode+0x25/0x30
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606454] [<c01fa011>] iput+0x41/0x60
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606462] [<c0284896>]
ext4_ext_migrate+0x3d6/0x520
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606471] [<c0263447>] ?
ext4_do_update_inode+0x267/0x4b0
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606479] [<c0269292>]
ext4_ioctl+0x6f2/0x750
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606488] [<c0268ba0>] ?
ext4_ioctl+0x0/0x750
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606496] [<c01f4c9c>]
vfs_ioctl+0x1c/0x90
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606502] [<c01f0236>] ?
putname+0x26/0x40
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606510] [<c01f4fc1>]
do_vfs_ioctl+0x71/0x310
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606517] [<c01f52bf>]
sys_ioctl+0x5f/0x80
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606525] [<c01e5669>] ?
sys_open+0x29/0x40
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606533] [<c010336c>]
syscall_call+0x7/0xb
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606539] ---[ end trace
11cc579a33f830d2 ]---
Oct 16 17:47:14 mmarkk-laptop kernel: [ 554.606613] ------------[ cut here
]------------

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
