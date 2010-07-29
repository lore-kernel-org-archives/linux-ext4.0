From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16312] WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
Date: Thu, 29 Jul 2010 19:29:54 GMT
Message-ID: <201007291929.o6TJTsNv008007@demeter.kernel.org>
References: <bug-16312-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40590 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757273Ab0G2T34 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Jul 2010 15:29:56 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o6TJTtcc008008
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 29 Jul 2010 19:29:55 GMT
In-Reply-To: <bug-16312-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16312





--- Comment #19 from Larry Finger <Larry.Finger@lwfinger.net>  2010-07-29 19:29:50 ---
This one needs to be reopened. The WARNING that I get does not happen every
reboot, but now I'm getting 2 when it happens. This kernel includes the 3
patches posted above.

[   12.183797] ------------[ cut here ]------------
[   12.183808] WARNING: at fs/fs-writeback.c:964
__mark_inode_dirty+0x10f/0x1a0()
[   12.183811] Hardware name: HP Pavilion dv2700 Notebook PC
[   12.183814] Modules linked in: loop(+) dm_mod ide_cd_mod cdrom
ide_pci_generic arc4 ecb b43 rng_core mac80211 snd_hda_codec_conexant cfg80211
rfkill led_class amd74xx ssb mmc_core ide_core snd_hda_intel snd_hda_codec
snd_pcm snd_timer k8temp pcmcia pcmcia_core forcedeth snd i2c_nforce2 joydev
hwmon sg snd_page_alloc serio_raw i2c_core ac battery button ext4 mbcache jbd2
crc16 ohci_hcd ehci_hcd sd_mod usbcore fan processor ahci libahci libata
scsi_mod thermal
[   12.183872] Pid: 2444, comm: udisks-part-id Not tainted 2.6.35-rc6-realtek+
#11
[   12.183875] Call Trace:
[   12.183882]  [<ffffffff8104608a>] warn_slowpath_common+0x7a/0xb0
[   12.183887]  [<ffffffff810460d5>] warn_slowpath_null+0x15/0x20
[   12.183891]  [<ffffffff81129d5f>] __mark_inode_dirty+0x10f/0x1a0
[   12.183895]  [<ffffffff8111e07d>] touch_atime+0x12d/0x170
[   12.183901]  [<ffffffff810cab91>] generic_file_aio_read+0x5c1/0x720
[   12.183906]  [<ffffffff81107ca2>] do_sync_read+0xd2/0x110
[   12.183912]  [<ffffffff81077e7d>] ? trace_hardirqs_on+0xd/0x10
[   12.183916]  [<ffffffff811083c3>] vfs_read+0xb3/0x170
[   12.183921]  [<ffffffff81002d1c>] ? sysret_check+0x27/0x62
[   12.183925]  [<ffffffff811084cc>] sys_read+0x4c/0x80
[   12.183929]  [<ffffffff81002ceb>] system_call_fastpath+0x16/0x1b
[   12.183932] ---[ end trace fdce3ec00c26fa3d ]---
[   12.183935] bdi-block not registered
[   12.205056] ------------[ cut here ]------------
[   12.205067] WARNING: at fs/fs-writeback.c:964
__mark_inode_dirty+0x10f/0x1a0()
[   12.205070] Hardware name: HP Pavilion dv2700 Notebook PC
[   12.205072] Modules linked in: loop(+) dm_mod ide_cd_mod cdrom
ide_pci_generic arc4 ecb b43 rng_core mac80211 snd_hda_codec_conexant cfg80211
rfkill led_class amd74xx ssb mmc_core ide_core snd_hda_intel snd_hda_codec
snd_pcm snd_timer k8temp pcmcia pcmcia_core forcedeth snd i2c_nforce2 joydev
hwmon sg snd_page_alloc serio_raw i2c_core ac battery button ext4 mbcache jbd2
crc16 ohci_hcd ehci_hcd sd_mod usbcore fan processor ahci libahci libata
scsi_mod thermal
[   12.205131] Pid: 2456, comm: udisks-part-id Tainted: G        W  
2.6.35-rc6-realtek+ #11
[   12.205134] Call Trace:
[   12.205141]  [<ffffffff8104608a>] warn_slowpath_common+0x7a/0xb0
[   12.205146]  [<ffffffff810460d5>] warn_slowpath_null+0x15/0x20
[   12.205150]  [<ffffffff81129d5f>] __mark_inode_dirty+0x10f/0x1a0
[   12.205155]  [<ffffffff8111e07d>] touch_atime+0x12d/0x170
[   12.205160]  [<ffffffff810cab91>] generic_file_aio_read+0x5c1/0x720
[   12.205165]  [<ffffffff81107ca2>] do_sync_read+0xd2/0x110
[   12.205171]  [<ffffffff81077e7d>] ? trace_hardirqs_on+0xd/0x10
[   12.205175]  [<ffffffff811083c3>] vfs_read+0xb3/0x170
[   12.205180]  [<ffffffff81002d1c>] ? sysret_check+0x27/0x62
[   12.205183]  [<ffffffff811084cc>] sys_read+0x4c/0x80
[   12.205188]  [<ffffffff81002ceb>] system_call_fastpath+0x16/0x1b
[   12.205191] ---[ end trace fdce3ec00c26fa3e ]---
[   12.205193] bdi-block not registered

I will put the diagnostic patch from comment 12 to get more info.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
