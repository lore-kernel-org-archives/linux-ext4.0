From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 121371] New: fsck created undeletable directory
Date: Sun, 03 Jul 2016 15:41:50 +0000
Message-ID: <bug-121371-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57654 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbcGCPly (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Jul 2016 11:41:54 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 11CE1202F2
	for <linux-ext4@vger.kernel.org>; Sun,  3 Jul 2016 15:41:52 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 7ED76202B8
	for <linux-ext4@vger.kernel.org>; Sun,  3 Jul 2016 15:41:50 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=121371

            Bug ID: 121371
           Summary: fsck created undeletable directory
           Product: File System
           Version: 2.5
    Kernel Version: 4.6.3
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: iamgrief@gmail.com
        Regression: No

Now I have two directories which cannot be deleted or moved even by root. I
cannot neither change ownership nor permission of these directories as well.

I've removed everything else from that partition, leaveing only these two
directories, run zerofree, compressed an image and uploaded it to dropbox.

You can check that with the following:

cd /tmp
wget https://dl.dropboxusercontent.com/u/22701362/broken.tar.xz
tar xvf broken.tar.xz
mkdir test
sudo mount broken.iso test
cd test

More details are here:
http://askubuntu.com/questions/794262/undeletable-directory-in-lostfound

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
