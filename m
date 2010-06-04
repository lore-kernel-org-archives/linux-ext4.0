From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16122] New: 2.6.35-rc1: WARNING at fs/fs-writeback.c:1142
 __mark_inode_dirty+0x103/0x170
Date: Fri, 4 Jun 2010 13:18:44 GMT
Message-ID: <bug-16122-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34085 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab0FDNSo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jun 2010 09:18:44 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o54DIiat010389
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 4 Jun 2010 13:18:44 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16122

           Summary: 2.6.35-rc1: WARNING at fs/fs-writeback.c:1142
                    __mark_inode_dirty+0x103/0x170
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.35-rc1-00324-gad84563
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: Larry.Finger@lwfinger.net
        Regression: Yes


On booting, I get the following:

[   16.480278] ------------[ cut here ]------------
[   16.480288] WARNING: at fs/fs-writeback.c:1142
__mark_inode_dirty+0x103/0x170()
[   16.480291] Hardware name: HP Pavilion dv2700 Notebook PC
[   16.480293] Modules linked in: loop(+) dm_mod ide_cd_mod cdrom
snd_hda_codec_conexant arc4 ecb b43 ide_pci_generic rng_core mac80211 cfg80211
rfkill snd_hda_intel led_class snd_hda_codec ssb snd_pcm mmc_core snd_timer
amd74xx pcmcia k8temp snd i2c_nforce2 ide_core soundcore serio_raw hwmon sg
pcmcia_core joydev snd_page_alloc forcedeth i2c_core ac battery button ext3 jbd
mbcache ohci_hcd sd_mod ehci_hcd usbcore fan processor ahci libahci libata
scsi_mod thermal
[   16.480344] Pid: 2432, comm: udisks-part-id Not tainted
2.6.35-rc1-Linus-00324-gad84563 #202
[   16.480347] Call Trace:
[   16.480354]  [<ffffffff8104623a>] warn_slowpath_common+0x7a/0xb0
[   16.480358]  [<ffffffff81046285>] warn_slowpath_null+0x15/0x20
[   16.480362]  [<ffffffff81128f53>] __mark_inode_dirty+0x103/0x170
[   16.480367]  [<ffffffff8111d6cd>] touch_atime+0x12d/0x170
[   16.480372]  [<ffffffff810ca131>] generic_file_aio_read+0x5c1/0x720
[   16.480377]  [<ffffffff810e49d8>] ? handle_mm_fault+0x718/0x8b0
[   16.480381]  [<ffffffff81107302>] do_sync_read+0xd2/0x110
[   16.480387]  [<ffffffff8107ab85>] ? trace_hardirqs_on_caller+0x145/0x190
[   16.480391]  [<ffffffff8107abdd>] ? trace_hardirqs_on+0xd/0x10
[   16.480394]  [<ffffffff81107a23>] vfs_read+0xb3/0x170
[   16.480399]  [<ffffffff81002d1c>] ? sysret_check+0x27/0x62
[   16.480403]  [<ffffffff81107b2c>] sys_read+0x4c/0x80
[   16.480407]  [<ffffffff81002ceb>] system_call_fastpath+0x16/0x1b
[   16.480410] ---[ end trace f16a433c45bd0baa ]---

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
