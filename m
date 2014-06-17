From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 78151] New: e2image -I does not work(?)
Date: Tue, 17 Jun 2014 10:16:03 +0000
Message-ID: <bug-78151-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59045 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbaFQKQF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Jun 2014 06:16:05 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3B677200E7
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2014 10:16:04 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 5EC7A20204
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2014 10:16:03 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=78151

            Bug ID: 78151
           Summary: e2image -I does not work(?)
           Product: File System
           Version: 2.5
    Kernel Version: 3.8.0-42-generic (Xubuntu 12.04)
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: barth@ub.uni-heidelberg.de
        Regression: No

dd if=/dev/zero of=e4.dat bs=1 count=1 seek=999999999
mkfs.ext4 e4.dat
mount e4.dat /mnt
rsync -a /usr/include/ /mnt/
umount /mnt

e2image e4.dat e4.img

mount e4.dat /mnt
rm -r /mnt/*
umount /mnt

e2image -I e4.dat e4.img

# Filesystem in e4.dat is unusable.
# after fsck -y e4.dat and mounting it,
# in /mnt/lost+found there are lots of files+dirs,
# but with names like #12345

# expected that all metadata would be recovered?
# is there an e4image?

Kind regards,
J.B.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
