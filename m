Return-Path: <SRS0=G5ay=OI=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:35282 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728522AbeK3DiP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 29 Nov 2018 22:38:15 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5A2E52F6DD
        for <linux-ext4@vger.kernel.org>; Thu, 29 Nov 2018 16:32:19 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Thu, 29 Nov 2018 16:32:17 +0000
Message-ID: <bug-201685-13602-LaBYjamCV2@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #72 from Jimmy.Jazz@gmx.net ---
(In reply to Theodore Tso from comment #69)
I didn't trust the kernel enough to let it work all the night without close
observation (i.e I need some rest).

In comparison with the latest tests, I feel certain the kernel is good after
one day with parallel running compilations.That's why I postponed J.Axboe
request.

Actually, I'm working with 4.18 e1333462e3 and after three clean reboot, the
disks stayed clean.

Dirvish is running today and nothing bad has append. I can say 4.18 e1333462e3
is good.
$ uptime
 17:12:44 up  3:23,  6 users,  load average: 10,54, 10,99, 10,13

Also, I didn't change my .config except when asked during the current commit. 

> how quickly do your other git bisect bad build fail ?

The builds failed after I solicit the kernel or when I back up the system
(dirvish/rsync). When the activity is low I didn't observe anything suspicious. 

Also, the server is not a stupid idle beagle.

To resume,

- I jumped to 4.19 because they were no improvement with 4.20-c3... and I
feared for my datas.
- From f48097d2 to 54dbe75b radeon module didn't work (i.e no display)
- 0a957467c5 crashed. Next try, crashed immediately during the boot. (comment
55)
- 958f338e I missed 'l1tf' patch (comment 62)
- From 958f338e to cd23ac8d I missed 'vdso' patch (comment 62)
- e1333462e3 I applied both patches 'l1tf' and 'vdso'

With commit e1333462e3, dm-4 partition could be cleaned efficiently (see
attachement).

> And I assume you have run a forced fsck
I have run a fsck /dev/dm-XX with 4.18 commit e1333462e3 first in rescue mode
than from init script during normal boot. It was not necessary to force an fsck
distinguished from 4.19 and higher releases.

> a previous bad kernel had left the file system corrupted
I thought about it too (comment 62 second paragraph). In that case, why does
only 4.18 + e2fsprogs be able to clean the partitions and not with more recent
kernels ? Doesn't e2fsprogs be compatible with 4.19 branch, does it ?

> git log --oneline e1333462e3..cd23ac8ddb7
I'm using gcc (Gentoo 8.2.0-r4 p1.5) 8.2.0 and use LD=ld.bfd. My linker is gold
by default. Sadly, I didn't find a way to compile it with clang.

> I would have expected a large number of people.
I understand. But race conditions are not always trivial.

> your file system has gotten corrupted.
dm-4 is marked read only until a backup is performed. I add (temporarily) mmp
to the file systems because I though I had a multi remount issue at first.
The report what intended to attract your attention on the following; remount,rw
or remount,ro are really slow with 4.18 commit e1333462e3 and the warning has
never appeared in that way on other builds. That was not observed with vanilla
4.18.X. 

Please, I didn't intend to misguide you. Just consider the warning as a false
positive. If the warning show of a rogue kernel, then it is the kernel 4.18 (a
contradiction).

My computers are on ups and I do an fsck on every reboot but force it again
only when an error has been detected. Anyway, corruptions that appear and
disappear all of sudden on the majority of fs with such a frequency is quite
remarkable.

The file systems are now clean over reboots. I propose to test if 4.19.5 kernel
stops showing corruptions. If they stop, it still opens a new question, why was
fsck missing some file system corruptions ?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
