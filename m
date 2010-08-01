From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16312] WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
Date: Sun, 1 Aug 2010 19:40:04 GMT
Message-ID: <201008011940.o71Je405005455@demeter.kernel.org>
References: <bug-16312-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33892 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab0HATkF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Aug 2010 15:40:05 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o71Je4wf005456
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 1 Aug 2010 19:40:04 GMT
In-Reply-To: <bug-16312-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16312





--- Comment #20 from Larry Finger <Larry.Finger@lwfinger.net>  2010-08-01 19:40:00 ---
The diagnostics patch from #12 did not change anything.

I am beginning to think that Bug 16312 is not the same as Bug 16122. Even with
the patches from 16312, I still get warnings as below:

[   11.728776] ------------[ cut here ]------------
[   11.728787] WARNING: at fs/fs-writeback.c:964
__mark_inode_dirty+0x10f/0x1a0()
[   11.728790] Hardware name: HP Pavilion dv2700 Notebook PC
[   11.728792] Modules linked in: loop(+) dm_mod ide_cd_mod cdrom
snd_hda_codec_conexant ide_pci_generic arc4 ecb b43 rng_core mac80211
snd_hda_intel r8712u(C) cfg80211 snd_hda_codec amd74xx snd_pcm sg ide_core
rfkill led_class snd_timer ssb mmc_core pcmcia snd joydev k8temp hwmon
i2c_nforce2 pcmcia_core forcedeth serio_raw snd_page_alloc i2c_core battery ac
button ext4 mbcache jbd2 crc16 ohci_hcd sd_mod ehci_hcd usbcore fan processor
ahci libahci libata scsi_mod thermal
[   11.728854] Pid: 2449, comm: udisks-part-id Tainted: G         C 
2.6.35-rc6-realtek+ #15
[   11.728857] Call Trace:
[   11.728865]  [<ffffffff8104608a>] warn_slowpath_common+0x7a/0xb0
[   11.728869]  [<ffffffff810460d5>] warn_slowpath_null+0x15/0x20
[   11.728874]  [<ffffffff81129d5f>] __mark_inode_dirty+0x10f/0x1a0
[   11.728879]  [<ffffffff8111e07d>] touch_atime+0x12d/0x170
[   11.728885]  [<ffffffff810cab91>] generic_file_aio_read+0x5c1/0x720
[   11.728890]  [<ffffffff81107ca2>] do_sync_read+0xd2/0x110
[   11.728896]  [<ffffffff81077e7d>] ? trace_hardirqs_on+0xd/0x10
[   11.728900]  [<ffffffff811083c3>] vfs_read+0xb3/0x170
[   11.728906]  [<ffffffff81002d1c>] ? sysret_check+0x27/0x62
[   11.728909]  [<ffffffff811084cc>] sys_read+0x4c/0x80
[   11.728914]  [<ffffffff81002ceb>] system_call_fastpath+0x16/0x1b
[   11.728917] ---[ end trace 32e16cacad33229f ]---
[   11.728919] bdi-block not registered

The warnings do not occur with every boot and appear to be some kind of race
condition.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
