From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15074] Problem with quota on ext4
Date: Fri, 29 Jan 2010 17:28:03 GMT
Message-ID: <201001291728.o0THS3is018395@demeter.kernel.org>
References: <bug-15074-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38408 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab0A2R2E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Jan 2010 12:28:04 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o0THS3JU018397
	for <linux-ext4@vger.kernel.org>; Fri, 29 Jan 2010 17:28:03 GMT
In-Reply-To: <bug-15074-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15074


Tim Bauer <gt6@gmx.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |gt6@gmx.net




--- Comment #1 from Tim Bauer <gt6@gmx.net>  2010-01-29 17:27:58 ---
I can confirm this on 2.6.32.6 (built Jan 25). It's the official Archlinux
kernel26. Using these fstab options:

/dev/sda1 / ext4 defaults,noatime,usrjquota=aquota.user,jqfmt=vfsv0 0 1
/dev/sda2 /home ext4 defaults,noatime,usrjquota=aquota.user,jqfmt=vfsv0 0 1

After a couple of minutes, and lots and lots of these backtraces, the machine
remounts / readonly and spits a couple of quota and IO errors to TTY1. Here's
the backtrace:

Jan 29 01:07:52 jackfruit kernel: ------------[ cut here ]------------
Jan 29 01:07:52 jackfruit kernel: WARNING: at fs/quota/dquot.c:964 dquot_claim_
space+0x14c/0x170()
Jan 29 01:07:52 jackfruit kernel: Hardware name: System Product Name
Jan 29 01:07:52 jackfruit kernel: Modules linked in: quota_v2 quota_tree snd_se
q_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_via82xx_modem snd_via82xx sn
d_pcm_oss snd_ac97_codec snd_mixer_oss snd_mpu401 ac97_bus snd_mpu401_uart batt
ery snd_pcm snd_rawmidi fan ppdev snd_timer analog snd_seq_device ac uhci_hcd i
2c_viapro lp psmouse snd ns558 parport_pc edac_core ehci_hcd asus_atk0110
serio_raw pcspkr thermal shpchp edac_mce_amd gameport parport button k8temp
processor snd_page_alloc soundcore i2c_core sg evdev usbcore sky2 pci_hotplug
rtc_cmos rtc_core rtc_lib ext4 mbcache jbd2 crc16 sr_mod cdrom sd_mod pata_via
sata_via pata_acpi ata_generic 3w_9xxx libata scsi_mod
Jan 29 01:07:52 jackfruit kernel: Pid: 1324, comm: flush-8:0 Tainted: G       
W  2.6.32-ARCH #1
Jan 29 01:07:52 jackfruit kernel: Call Trace:
Jan 29 01:07:52 jackfruit kernel: [<ffffffff810579d3>] ?
warn_slowpath_common+0x73/0xb0
Jan 29 01:07:52 jackfruit kernel: [<ffffffff81164acc>] ?
dquot_claim_space+0x14c/0x170
Jan 29 01:07:52 jackfruit kernel: [<ffffffffa010b65b>] ?
ext4_mb_mark_diskspace_used+0x3eb/0x4c0 [ext4]
Jan 29 01:07:52 jackfruit kernel: [<ffffffffa010fbdb>] ?
ext4_mb_new_blocks+0x29b/0x5a0 [ext4]
Jan 29 01:07:52 jackfruit kernel: [<ffffffffa010473f>] ?
ext4_ext_find_extent+0x2af/0x2f0 [ext4]
Jan 29 01:07:52 jackfruit kernel: [<ffffffffa01068d0>] ?
ext4_ext_get_blocks+0xe40/0x1610 [ext4]
Jan 29 01:07:52 jackfruit kernel: [<ffffffffa010fbdb>] ? ext4_mb_new_blocks+0x2
9b/0x5a0 [ext4]
Jan 29 01:07:52 jackfruit kernel: [<ffffffffa010473f>] ? ext4_ext_find_extent+0
x2af/0x2f0 [ext4]
Jan 29 01:07:52 jackfruit kernel: [<ffffffffa01068d0>] ? ext4_ext_get_blocks+0x
e40/0x1610 [ext4]
Jan 29 01:07:52 jackfruit kernel: [<ffffffff810d5fe9>] ?
mempool_alloc+0x59/0x140
Jan 29 01:07:52 jackfruit kernel: [<ffffffffa00e44cb>] ?
ext4_get_blocks+0x1fb/0x370 [ext4]
Jan 29 01:07:52 jackfruit kernel: [<ffffffffa00e47cb>] ?
mpage_da_map_blocks+0xbb/0x450 [ext4]
Jan 29 01:07:52 jackfruit kernel: [<ffffffffa00e4e9a>] ?
ext4_da_writepages+0x33a/0x700 [ext4]
Jan 29 01:07:52 jackfruit kernel: [<ffffffff810db030>] ? __writepage+0x0/0x30
Jan 29 01:07:52 jackfruit kernel: [<ffffffff81075e04>] ?
bit_waitqueue+0x14/0xcJan 29 01:07:52 jackfruit kernel: [<ffffffff81075e04>] ?
bit_waitqueue+0x14/0xc
0
Jan 29 01:07:52 jackfruit kernel: [<ffffffff81135b03>] ?
writeback_single_inode+0xf3/0x3c0
Jan 29 01:07:52 jackfruit kernel: [<ffffffff81136b63>] ?
writeback_inodes_wb+0x403/0x5d0
Jan 29 01:07:52 jackfruit kernel: [<ffffffff81136e3d>] ?
wb_writeback+0x10d/0x1e0
Jan 29 01:07:52 jackfruit kernel: [<ffffffff811371c9>] ?
wb_do_writeback+0x1d9/0x1f0
Jan 29 01:07:52 jackfruit kernel: [<ffffffff81067e20>] ?
process_timeout+0x0/0x10
Jan 29 01:07:52 jackfruit kernel: [<ffffffff81137223>] ?
bdi_writeback_task+0x43/0xd0
Jan 29 01:07:52 jackfruit kernel: [<ffffffff810ecf80>] ? bdi_start_fn+0x0/0xf0
Jan 29 01:07:52 jackfruit kernel: [<ffffffff810ecffe>] ? bdi_start_fn+0x7e/0xf0
Jan 29 01:07:52 jackfruit kernel: [<ffffffff810ecf80>] ? bdi_start_fn+0x0/0xf0
Jan 29 01:07:52 jackfruit kernel: [<ffffffff81075b5e>] ? kthread+0x8e/0xa0
Jan 29 01:07:52 jackfruit kernel: [<ffffffff8101311a>] ? child_rip+0xa/0x20
Jan 29 01:07:52 jackfruit kernel: [<ffffffff81075ad0>] ? kthread+0x0/0xa0
Jan 29 01:07:52 jackfruit kernel: [<ffffffff81013110>] ? child_rip+0x0/0x20
Jan 29 01:07:52 jackfruit kernel: ---[ end trace 366c68d94c2ad887 ]---

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
