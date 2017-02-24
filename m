From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194693] New: Repeated ext4 corruption
Date: Fri, 24 Feb 2017 08:22:30 +0000
Message-ID: <bug-194693-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:37498 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751268AbdBXIWd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 24 Feb 2017 03:22:33 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 678C1283E2
        for <linux-ext4@vger.kernel.org>; Fri, 24 Feb 2017 08:22:32 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B919428419
        for <linux-ext4@vger.kernel.org>; Fri, 24 Feb 2017 08:22:30 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=194693

            Bug ID: 194693
           Summary: Repeated ext4 corruption
           Product: File System
           Version: 2.5
    Kernel Version: 4.10.0
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: steinar+kernel@gunderson.no
        Regression: No

Hi,

I'm having a system where I run ext4 -> LVM -> dm-cache (on the whole disk, so
an LVM on top of the dm-cache volume again) -> LVM -> md (RAID-6). It's been
reliable over the past few years, but suddenly, I started getting reports of
corruption on /, so I restarted. A few volumes were ripe with various forms of
corruption, mostly double-cloned blocks, so I did touch /forcefsck, let it fix
everything, and upgraded to 4.10.0.

However, this morning, it happened again:

[60084.371367] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1188111:
comm tar: deleted inode referenced: 1213330
[60084.387140] Aborting journal on device dm-27-8.
[60084.397323] EXT4-fs (dm-27): Remounting filesystem read-only
[60084.397344] EXT4-fs error (device dm-27): ext4_journal_check_start:56:
Detected aborted journal
[60084.397346] EXT4-fs (dm-27): Remounting filesystem read-only
[60097.051975] EXT4-fs warning (device dm-27): dx_probe:751: inode #1064698:
comm tar: Unrecognised inode hash code 16
[60097.062757] EXT4-fs warning (device dm-27): dx_probe:856: inode #1064698:
comm tar: Corrupt directory, running e2fsck is recommended
[60097.082758] EXT4-fs warning (device dm-27): dx_probe:751: inode #1064718:
comm tar: Unrecognised inode hash code 32
[60097.093544] EXT4-fs warning (device dm-27): dx_probe:856: inode #1064718:
comm tar: Corrupt directory, running e2fsck is recommended
[60097.397083] EXT4-fs warning (device dm-27): dx_probe:751: inode #1064533:
comm tar: Unrecognised inode hash code 16
[60097.407843] EXT4-fs warning (device dm-27): dx_probe:856: inode #1064533:
comm tar: Corrupt directory, running e2fsck is recommended
[60097.508058] EXT4-fs error (device dm-27): ext4_lookup:1604: inode #1064009:
comm tar: 'smp-cps.h' linked to parent dir
[60111.315406] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1840154:
comm tar: deleted inode referenced: 1857201
[60111.331194] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1840154:
comm tar: deleted inode referenced: 1857199
[60111.351443] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1840154:
comm tar: deleted inode referenced: 1857208
[60111.371866] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1840154:
comm tar: deleted inode referenced: 1857203
[60111.392354] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1840154:
comm tar: deleted inode referenced: 1858416
[60111.412458] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1840154:
comm tar: deleted inode referenced: 1859508
[60111.432691] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1840154:
comm tar: deleted inode referenced: 1857207
[60111.453250] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1840154:
comm tar: deleted inode referenced: 1857205
[60111.473949] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1840154:
comm tar: deleted inode referenced: 1857211
[60111.494393] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1840154:
comm tar: deleted inode referenced: 1857209
[60118.772735] EXT4-fs error: 353 callbacks suppressed
[60118.777828] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1845428:
comm tar: deleted inode referenced: 1857460
[60118.798438] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1845428:
comm tar: deleted inode referenced: 1857457
[60118.818908] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1845428:
comm tar: deleted inode referenced: 1857459
[60118.841219] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1845428:
comm tar: deleted inode referenced: 1858615
[60118.861083] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1845428:
comm tar: deleted inode referenced: 1857461
[60118.881539] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1845428:
comm tar: deleted inode referenced: 1858531
[60118.901990] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1845428:
comm tar: deleted inode referenced: 1859518
[60118.922453] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1845428:
comm tar: deleted inode referenced: 1858554
[60118.942455] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1845428:
comm tar: deleted inode referenced: 1858581
[60118.962787] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1845428:
comm tar: deleted inode referenced: 1858586
[69012.993067] EXT4-fs error: 215 callbacks suppressed
[69012.998143] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1188111:
comm find: deleted inode referenced: 1213330
[69013.016942] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1188111:
comm find: deleted inode referenced: 1213330
[69013.037263] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1188111:
comm find: deleted inode referenced: 1213330
[69013.057815] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1188111:
comm find: deleted inode referenced: 1213330
[69013.077731] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1188111:
comm find: deleted inode referenced: 1213330
[69013.098168] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1188111:
comm find: deleted inode referenced: 1213330
[69013.118604] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1188111:
comm find: deleted inode referenced: 1213330
[69013.139101] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1188111:
comm find: deleted inode referenced: 1213330
[69013.158520] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1188111:
comm find: deleted inode referenced: 1213330
[69013.178888] EXT4-fs error (device dm-27): ext4_lookup:1611: inode #1188111:
comm find: deleted inode referenced: 1213330
[79334.333925] exim4[12198]: segfault at 7ffdc324fe1c ip 00007fc7b1990d3e sp
00007ffdc324fd60 error 6 in libc-2.24.so[7fc7b194a000+195000]

(dm-27 is my root volume.)

Rough timeline of kernels:

Dec 12: Upgraded from 4.9.0-rc2 to 4.9.0
Feb 13: Upgraded from 4.9.0 to to 4.9.9
Feb 23: Corruption detected (by nightly backup), upgraded to 4.10.0
Feb 24: Corruption detected again

It would seem likely that something happened between 4.9.0 and 4.9.9, but I
haven't read the logs. I'll be downgrading to 4.9.0 again to see if that helps.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
