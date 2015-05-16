From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 98461] New: OOPS: general protection fault: 0000 [#1] SMP
Date: Sat, 16 May 2015 07:03:51 +0000
Message-ID: <bug-98461-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43701 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbbEPHDz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 May 2015 03:03:55 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AF8A8204E3
	for <linux-ext4@vger.kernel.org>; Sat, 16 May 2015 07:03:53 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 93D8A20456
	for <linux-ext4@vger.kernel.org>; Sat, 16 May 2015 07:03:52 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=98461

            Bug ID: 98461
           Summary: OOPS: general protection fault: 0000 [#1] SMP
           Product: File System
           Version: 2.5
    Kernel Version: 3.10.72
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: mmokrejs@gmail.com
        Regression: No

Hi,
  I had some external eSATA connection to a disk broken. I admit kernl was in
bad stage since then. I tried to unmount the disk (gone already a long while)
and got:

# umount /mnt/blah
Core dumped
# dmesg
...
[75965.174636] EXT4-fs error (device sdg1): ext4_find_entry:1309: inode #2:
comm gvfsd-trash: reading directory lblock 0
[75965.174701] EXT4-fs error (device sdg1): ext4_find_entry:1309: inode #2:
comm gvfsd-trash: reading directory lblock 0
[75979.272844] EXT4-fs error (device sdg1): ext4_put_super:760: Couldn't clean
up the journal
[75979.282411] ------------[ cut here ]------------
[75979.282418] WARNING: at lib/kobject.c:600 kobject_put+0x60/0x70()
[75979.282423] general protection fault: 0000 [#1] SMP 
[75979.282456] Modules linked in: vfat fat fuse iwldvm ums_realtek iwlwifi
uvcvideo usb_storage videobuf2_vmalloc videobuf2_memops intel_powerclamp
videobuf2_core sata_sil24 [last unloaded: vboxdrv]
[75979.282538] CPU: 1 PID: 17304 Comm: umount Tainted: G           O
3.10.72-default-pciehp #6
[75979.282564] Hardware name: Dell Inc. Vostro 3550/, BIOS A12 02/18/2014
[75979.282586] task: ffff88006a2d1e40 ti: ffff8803f466a000 task.ti:
ffff8803f466a000
[75979.282609] RIP: 0010:[<ffffffff81334ae9>]  [<ffffffff81334ae9>]
strnlen+0x9/0x50
[75979.282635] RSP: 0018:ffff8803f466b960  EFLAGS: 00010086
[75979.282654] RAX: ffffffff81cc29ef RBX: ffffffff8201170c RCX:
0000000000000000
[75979.282676] RDX: 0a0005000e000d00 RSI: ffffffffffffffff RDI:
0a0005000e000d00
[75979.282698] RBP: ffff8803f466b960 R08: 000000000000ffff R09:
000000000000ffff
[75979.282729] R10: 0000000000000000 R11: 0000000000000000 R12:
0a0005000e000d00
[75979.282752] R13: ffffffff82011ae0 R14: 00000000ffffffff R15:
0000000000000000
[75979.282782] FS:  00007fd8ba24c780(0000) GS:ffff88041fa80000(0000)
knlGS:0000000000000000
[75979.282808] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[75979.282835] CR2: 00007fdb33d46000 CR3: 000000027e30a000 CR4:
00000000000407e0
[75979.282857] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[75979.282887] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[75979.282909] Stack:
[75979.282919]  ffff8803f466b998 ffffffff81336e6b ffffffff8201170c
ffffffff82011ae0
[75979.282947]  ffff8803f466bae0 ffffffff81cde75e ffffffff81cde75e
ffff8803f466b9f8
[75979.282985]  ffffffff81337cc9 00000000ffffffff 000000000000000c
ffffffff82011700
[75979.283021] Call Trace:
[75979.283032]  [<ffffffff81336e6b>] string.isra.5+0x3b/0xe0
[75979.283051]  [<ffffffff81337cc9>] vsnprintf+0x1c9/0x640
[75979.283068]  [<ffffffff8133814d>] vscnprintf+0xd/0x40
[75979.283087]  [<ffffffff8109a63b>] vprintk_emit+0x9b/0x580
[75979.283106]  [<ffffffff8132f160>] ? kobject_put+0x60/0x70
[75979.283125]  [<ffffffff8132f160>] ? kobject_put+0x60/0x70
[75979.283144]  [<ffffffff8109ab3a>] vprintk+0x1a/0x20
[75979.283161]  [<ffffffff810984b2>] warn_slowpath_common+0x52/0x80
[75979.283182]  [<ffffffff81098527>] warn_slowpath_fmt+0x47/0x50
[75979.283202]  [<ffffffff8132f160>] kobject_put+0x60/0x70
[75979.283220]  [<ffffffff81494582>] put_device+0x12/0x20
[75979.283239]  [<ffffffff814ad700>] scsi_host_dev_release+0xb0/0xd0
[75979.283259]  [<ffffffff8149430d>] device_release+0x2d/0xa0
[75979.283279]  [<ffffffff8132f24f>] kobject_release+0x3f/0x80
[75979.283297]  [<ffffffff8132f135>] kobject_put+0x35/0x70
[75979.283316]  [<ffffffff81494582>] put_device+0x12/0x20
[75979.283335]  [<ffffffff814b4e3a>] scsi_target_dev_release+0x1a/0x20
[75979.283354]  [<ffffffff8149430d>] device_release+0x2d/0xa0
[75979.283374]  [<ffffffff8132f24f>] kobject_release+0x3f/0x80
[75979.283393]  [<ffffffff8132f135>] kobject_put+0x35/0x70
[75979.283411]  [<ffffffff81494582>] put_device+0x12/0x20
[75979.283430]  [<ffffffff814b7d55>]
scsi_device_dev_release_usercontext+0x185/0x190
[75979.283453]  [<ffffffff814b7bd0>] ? scsi_device_cls_release+0x20/0x20
[75979.283482]  [<ffffffff810b7149>] execute_in_process_context+0x89/0xa0
[75979.283506]  [<ffffffff814b7ba7>] scsi_device_dev_release+0x17/0x20
[75979.284376]  [<ffffffff8149430d>] device_release+0x2d/0xa0
[75979.285228]  [<ffffffff8132f24f>] kobject_release+0x3f/0x80
[75979.286025]  [<ffffffff8132f135>] kobject_put+0x35/0x70
[75979.286816]  [<ffffffff81494582>] put_device+0x12/0x20
[75979.287596]  [<ffffffff814abf05>] scsi_device_put+0x35/0x50
[75979.288366]  [<ffffffff814c513d>] scsi_disk_put+0x2d/0x40
[75979.289117]  [<ffffffff814c53cc>] sd_release+0x2c/0x60
[75979.289871]  [<ffffffff811c70e5>] __blkdev_put+0x185/0x1c0
[75979.290611]  [<ffffffff811c707b>] __blkdev_put+0x11b/0x1c0
[75979.291339]  [<ffffffff811c7a49>] blkdev_put+0x49/0x170
[75979.292061]  [<ffffffff811911ec>] kill_block_super+0x3c/0x70
[75979.292795]  [<ffffffff8119166d>] deactivate_locked_super+0x3d/0x60
[75979.293504]  [<ffffffff811916ec>] deactivate_super+0x5c/0x60
[75979.294187]  [<ffffffff811add06>] mntput_no_expire+0xe6/0x140
[75979.294861]  [<ffffffff811aeb45>] SyS_umount+0x95/0x3d0
[75979.295523]  [<ffffffff8182ca36>] system_call_fastpath+0x1a/0x1f
[75979.296206] Code: 40 00 48 83 c0 01 80 38 00 75 f7 48 29 f8 5d c3 31 c0 5d
c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 85 f6 48 89 e5 74 3f <80> 3f
00 74 3a 48 8d 47 01 48 01 fe eb 13 66 0f 1f 84 00 00 00 
[75979.297826] RIP  [<ffffffff81334ae9>] strnlen+0x9/0x50
[75979.298601]  RSP <ffff8803f466b960>
[75979.303670] ---[ end trace bf09cf1f31586f68 ]---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
