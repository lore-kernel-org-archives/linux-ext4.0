From: Larry Keegan <lk@pfw.demon.co.uk>
Subject: 3.10.0: kernel BUG at fs/ext4/super.c:804!
Date: Sat, 20 Jul 2013 18:49:07 +0000
Message-ID: <20130720184907.4fff17ee@fs6.al.itld>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pfw.demon.co.uk ([62.49.22.168]:36403 "EHLO pfw.demon.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715Ab3GTS75 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Jul 2013 14:59:57 -0400
Received: from fs6.al.itld (fs6.al.itld [10.1.1.175])
	by pfw.demon.co.uk (Postfix) with ESMTP id 2F10043
	for <linux-ext4@vger.kernel.org>; Sat, 20 Jul 2013 18:49:11 +0000 (UTC)
Received: from fs6.al.itld (fs6.al.itld [10.1.1.175])
	by fs6.al.itld (Postfix) with ESMTP id 1F94C253
	for <linux-ext4@vger.kernel.org>; Sat, 20 Jul 2013 18:49:10 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear Sirs,

I just had a nasty surprise when unmounting an ext 4 system on my file
server. It was running a plain kernel 3.10.0 at the time.

It is a pretty quiet file server which is in an HA configuration with
an identical machine. It serves a dozen or so low traffic home volumes
over NFSv4.1. All the machines were running identical software. A few
minutes before I elected to unmount the filesystems I was running
claws-mail on a client machine. Despite using mbox format, claws-mail
really hammers the file server with the conventional mbox lock/unlock
trickery *for each message in each mbox*. Even so, it only lasts a few
seconds.

When I elected to shut down the machine, I unexported the NFS
filesystems and unmounted them. At this point umount SEGVd and this
appeared in syslog:

EXT4-fs (dm-41): sb orphan head is 5207
sb_info orphan list:
  inode dm-41:5207 at e3a7cef8: mode 100644, nlink 0, next 0
------------[ cut here ]------------
kernel BUG at fs/ext4/super.c:804!
invalid opcode: 0000 [#1] SMP 
Modules linked in: videobuf_dvb dvb_core mt20xx tda9887 tda18271 xc5000
tuner_simple videobuf_core t da8290 tuner_types tuner_xc2028 tda827x
mc44s803 tda10048 xc4000 s5h1411 m2m_deinterlace videobuf2_dma_contig
videobuf2_memops v4l2_mem2mem videob uf2_core videodev media
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
snd_page_alloc snd_timer snd soundcore objlayoutdriver netlink_diag
generic_bl fbcon tileblit blocklayoutdriver nfs_layout_nfsv41_files
libore ams369fg06 lcd bitblit output font ip_vs_ftp softcursor f b
fbdev intel_agp intel_gtt agpgart CPU: 1 PID: 32533 Comm: umount Not
tainted 3.10.0 #1 Hardware name: Gigabyte Technology Co., Ltd.
EP45-UD3L/EP45-UD3L, BIOS F4 02/24/2009 task: e9a3f2c0 ti: e7662000
task.ti: e7662000 EIP: 0060:[ext4_put_super+0x2f9/0x300] EFLAGS:
00010216 CPU: 1 EIP is at ext4_put_super+0x2f9/0x300 EAX: 0000003c EBX:
e7ed4800 ECX: e7ed4950 EDX: e7ed4950 ESI: e7ed6c00 EDI: 00000002 EBP:
e7663ef4 ESP: e7663ec0 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
CR0: 8005003b CR2: b717d7e0 CR3: 29f09000 CR4: 000007f0 DR0: 00000000
DR1: 00000000 DR2: 00000000 DR3: 00000000 DR6: ffff0ff0 DR7: 00000400
Stack: c1ee5834 e7ed6dbc 00001457 e3a7cef8 000081a4 00000000 00000000
e3a7ced8 e7ed4950 e7ed4914 e7ed6c00 e7ed6c58 c1c40ee0 e7663f10 c111479c
e7663f20 c10e6fc2 f0443400 00000083 ea0ba310 e7663f20 c1114834 e7ed6c00
c20637a8 Call Trace:
 [generic_shutdown_super+0x4c/0xc0] generic_shutdown_super+0x4c/0xc0
 [pcpu_free_area+0x162/0x1f0] ? pcpu_free_area+0x162/0x1f0
 [kill_block_super+0x24/0x70] kill_block_super+0x24/0x70
 [deactivate_locked_super+0x33/0x60] deactivate_locked_super+0x33/0x60
 [deactivate_super+0x42/0x60] deactivate_super+0x42/0x60
 [mntput_no_expire+0xc3/0x120] mntput_no_expire+0xc3/0x120
 [sys_umount+0x84/0x320] SyS_umount+0x84/0x320
 [sys_oldumount+0x19/0x20] SyS_oldumount+0x19/0x20
 [syscall_call+0x7/0x0b] syscall_call+0x7/0xb
Code: 55 ec 89 4d e8 05 bc 01 00 00 89 44 24 04 e8 be 4d a0 00 8b 4d e8
8b 55 ec 8b 09 39 ca 75 b2 3b 93 50 01 00 00 0f 84 de fe ff ff <0f> 0b
90 8d 74 26 00 55 89 e5 83 ec 20 8d 45 18 c7 04 24 68 58 EIP:
[ext4_put_super+0x2f9/0x300] ext4_put_super+0x2f9/0x300 SS:ESP
0068:e7663ec0 ---[ end trace 5309e7ede4b7c1d0 ]---

The strange thing is that this particular filesystem, although exported
via NFS won't have been mounted by any machine (not for weeks at any
rate).

After the crash, attempts to umount or sync caused those processes to
hang, followed by more processes and so on. The only escape was to
SysRq+U and SysRq+B. No filesystem errors were reported by e2fsck on
any filesystems when they came back up.

I've been experiencing a few oddities when unmounting filesystems ever
since I upgraded my file server to gigabit when I was running kernel
3.4.4. I am satisfied that I can reproduce the hanging problem
reliably-enough for it to be a real pain in the arse, but this is the
first time I've seen a BUG.

I'm now running 3.10.1 and have NFSv4.1 client support switched off in
the hope it might not happen again.

Any ideas?

Yours,

Larry.
