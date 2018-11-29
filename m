Return-Path: <SRS0=G5ay=OI=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:41260 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726954AbeK2OYn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 29 Nov 2018 09:24:43 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 762512E86D
        for <linux-ext4@vger.kernel.org>; Thu, 29 Nov 2018 03:20:51 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Thu, 29 Nov 2018 03:20:50 +0000
Message-ID: <bug-201685-13602-a1xdh8lXil@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #69 from Theodore Tso (tytso@mit.edu) ---
Hi Jimmy,  how certain are you that e1333462e3 is stable for you?    i.e., how
long have you been running with that kernel and how quickly do your other git
bisect bad build fail for you?

And I assume you have run a forced fsck (ideally while 4.18 is booted) on the
file system before installing each kernel that you were bisect testing, right? 
  Otherwise it's possible that a previous bad kernel had left the file system
corrupted, and so a particular kernel stumbled on a corruption, but it wasn't
actually *caused* by that kernel.

The reason why I'm asking these question is that based on your bisect, it would
*appear* that the problem was introduced by an RCU change.  If you look at the
output of "git log --oneline e1333462e3..cd23ac8ddb7" all of the changes are
RCU related.   That's a bit surprising, since given that only some users are
seeing this problem.  If there was a regression was introduced in the RCU
subsystem, I would have expected a large number of people would have been
complaining, with many more bugs than just in ext4.

And there is some evidence that your file system has gotten corrupted.  The
warnings you report here:

[12421.017028] EXT4-fs warning (device dm-4): kmmpd:191: kmmpd being stopped
since filesystem has been remounted as readonly.
[12434.457445] EXT4-fs warning (device dm-4): ext4_multi_mount_protect:325: MMP 
interval 42 higher than expected, please wait.

Are caused by the MMP feature being enabled on your kernel.  It's not enabled
by default, and unless you have relatively exotic hardware (e.g., dual-attached
SCSI disks that can be reached by two servers for failover) there is no reason
to turn on the MMP feature.    You can disable it via:  "tune2fs -O ^mmp
/dev/dm-4".   (And you can enable it via "tune2fs -O mmp /dev/dm-4".)    So
apparently while you were running your tests, the superblock had at least one
bit (the MMP feature bit) flipped by a rogue kernel.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
