Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:46952 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725928AbeLCUiQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2018 15:38:16 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 341772B6B1
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 20:38:15 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 20:38:13 +0000
Message-ID: <bug-201685-13602-AGCy6M47sw@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #209 from Néstor A. Marchesini (nestorm_des@hotmail.com) ---
I am investigating the dates of the files and folders found by fsck.ext4 when
repairing the partition and I find something surprising.

# ls -l /lost+foud
-rw-r--r-- 1 portage portage 5051 dic 10  2013 '#1057825'
drwxr-xr-x 3 portage portage 4096 dic 10  2013 '#1057827'
-rw-r--r-- 1 root    root    2022 oct 22 03:37 '#3184673'
-rw-r--r-- 1 root    root     634 oct 22 03:37 '#3184674'
-rw-r--r-- 1 root    root    1625 oct 22 03:37 '#3184675'

Many lost files appear on October 22 at 3:37hs, all with the same time and the
same day belonging to the root user, then a folder of December 10, 2013
belonging to the user portage group portage, for those who do not use gentoo,
only say that that user and that group is only in the system in /usr/portage

the contents of this folder:

# ls -l /lost+found/#1057827
drwxr-xr-x 11 portage portage 4096 dic 10  2013 vba

and inside that folder vba many more folders and files, all from the same ebuid
of libreoffice at the end of 2013, probably from this version, when it was
updated.

$ genlop -t libreoffice
     Fri Nov  1 00:34:35 2013 >>> app-office/libreoffice-4.1.3.2
       merge time: 1 hour, 9 minutes and 14 seconds.

This package for years that are no longer on my pc, when upgrade libreoffice
they were deleted and now fsck finds them when scanning as if they were
installed and they were corrupted, but it turns out that they were erased there
for a long time and now they are found as broken and put in lost+found.

So pay attention to the lost+found content of your partitions, to see if
they are current files or something they had long ago and had already deleted.
What I do not relate is because e2fsk.ext4 starts to detect these deleted
fragments.

It may be the journal of ext4 or one of its unsynchronized copies that
remembers things that are no longer there and retrieves them from the liberated
space?

My system and partitions were created on April 10, 2012 and I never had
corruption problems of this type.

$ genlop -t gentoo-sources |head -n3
     Wed Apr 11 23:39:02 2012 >>> sys-kernel/gentoo-sources-3.3.1

# tune2fs -l /dev/md2 |grep "Filesystem created:"
Filesystem created:       Tue Apr 10 16:18:28 2012

Regards

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
