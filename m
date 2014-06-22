From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 78721] New: VFS: brelse: Trying to free free buffer
Date: Sun, 22 Jun 2014 21:25:03 +0000
Message-ID: <bug-78721-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44267 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbaFVVZH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Jun 2014 17:25:07 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 80679201DE
	for <linux-ext4@vger.kernel.org>; Sun, 22 Jun 2014 21:25:06 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 169522021A
	for <linux-ext4@vger.kernel.org>; Sun, 22 Jun 2014 21:25:04 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=78721

            Bug ID: 78721
           Summary: VFS: brelse: Trying to free free buffer
           Product: File System
           Version: 2.5
    Kernel Version: 3.15.1
          Hardware: i386
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: deweloper@wp.pl
        Regression: No

Created attachment 140641
  --> https://bugzilla.kernel.org/attachment.cgi?id=140641&action=edit
dmesg

[ 5188.946855] ------------[ cut here ]------------
[ 5188.956366] WARNING: CPU: 0 PID: 6949 at fs/buffer.c:1206
__brelse+0x34/0x40()
[ 5188.971168] VFS: brelse: Trying to free free buffer
[ 5188.981113] Modules linked in: af_packet snd_via82xx snd_mpu401_uart
snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_timer snd soundcore eeprom
i2c_viapro vt8231 saa7134_empress via686a hwmon saa6752hs tuner_simple
tuner_types tda9887 tda8290 tuner saa7134 tveeprom videobuf_dma_sg
videobuf_core v4l2_common videodev i2c_core sd_mod uhci_hcd sata_nv pata_amd
pata_via ata_piix libata scsi_mod ext4 crc16 mbcache jbd2 vfat fat via_rhine
forcedeth 8139too 3c59x mii 3c509 nvram rtc_cmos usbkbd usbcore usb_common unix
pcspkr
[ 5189.076610] CPU: 0 PID: 6949 Comm: record Not tainted 3.15.1 #6
[ 5189.088652]  c0314842 c0126df6 c0385d24 c22afbcc 00001b25 c0384b22 000004b6
c01b3ca4
[ 5189.104729]  c01b3ca4 c22afc14 c1b028f8 00000003 c22afc38 c0126ea3 00000009
c22afbb4
[ 5189.120931]  c0385d24 c22afbcc c01b3ca4 c0384b22 000004b6 c0385d24 c49f2c6c
00000001
[ 5189.137091] Call Trace:
[ 5189.142177]  [<c0314842>] ? dump_stack+0xa/0x13
[ 5189.151503]  [<c0126df6>] ? warn_slowpath_common+0x76/0x90
[ 5189.162740]  [<c01b3ca4>] ? __brelse+0x34/0x40
[ 5189.171894]  [<c01b3ca4>] ? __brelse+0x34/0x40
[ 5189.181165]  [<c0126ea3>] ? warn_slowpath_fmt+0x33/0x40
[ 5189.192079]  [<c01b3ca4>] ? __brelse+0x34/0x40
[ 5189.201536]  [<c49f2c6c>] ? ext4_ind_map_blocks+0x31c/0x5b0 [ext4]
[ 5189.214409]  [<c49c5984>] ? ext4_map_blocks+0x2a4/0x560 [ext4]
[ 5189.226614]  [<c49c7216>] ? _ext4_get_block+0x76/0x180 [ext4]
[ 5189.238418]  [<c01b381b>] ? alloc_page_buffers+0x4b/0x90
[ 5189.249321]  [<c01b5130>] ? __block_write_begin+0x160/0x380
[ 5189.260918]  [<c49c849f>] ? ext4_write_begin+0x17f/0x3e0 [ext4]
[ 5189.273283]  [<c49c7340>] ? ext4_get_block_write+0x10/0x10 [ext4]
[ 5189.285943]  [<c49c9520>] ? ext4_write_end+0x200/0x350 [ext4]
[ 5189.297750]  [<c0167b0e>] ? generic_perform_write+0xbe/0x1c0
[ 5189.309382]  [<c016955d>] ? __generic_file_aio_write+0x1ed/0x470
[ 5189.321704]  [<c016982a>] ? generic_file_aio_write+0x4a/0x100
[ 5189.333631]  [<c49c1042>] ? ext4_file_write+0xc2/0x4f0 [ext4]
[ 5189.345479]  [<c4b7638d>] ? __videobuf_copy_to_user.isra.2+0x3d/0x50
[videobuf_core]
[ 5189.361315]  [<c4b77e1f>] ? videobuf_read_stream+0x25f/0x2b0 [videobuf_core]
[ 5189.375728]  [<c01907db>] ? do_sync_write+0x5b/0x90
[ 5189.385772]  [<c0190780>] ? do_sync_readv_writev+0x90/0x90
[ 5189.397018]  [<c01912f7>] ? vfs_write+0x97/0x190
[ 5189.406529]  [<c019171c>] ? SyS_write+0x4c/0xb0
[ 5189.415810]  [<c03171fa>] ? syscall_call+0x7/0xb
[ 5189.425310] ---[ end trace 9de2bd6272909976 ]---
[ 5189.464211] ------------[ cut here ]------------

uname -a:
Linux video 3.15.1 #6 Sun Jun 22 13:12:40 CEST 2014 i586 GNU/Linux

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
