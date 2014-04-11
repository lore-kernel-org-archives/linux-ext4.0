From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 40822] EXT4-fs error (device dm-4): ext4_lookup:1044: inode
 #3308277: comm rm: deleted inode referenced: 3058008
Date: Fri, 11 Apr 2014 12:33:49 +0000
Message-ID: <bug-40822-13602-8Dm06dSrQg@https.bugzilla.kernel.org/>
References: <bug-40822-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52141 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211AbaDKMdw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Apr 2014 08:33:52 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1DDC120824
	for <linux-ext4@vger.kernel.org>; Fri, 11 Apr 2014 12:33:51 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 20E8B2080D
	for <linux-ext4@vger.kernel.org>; Fri, 11 Apr 2014 12:33:50 +0000 (UTC)
In-Reply-To: <bug-40822-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=40822

--- Comment #6 from Theodore Tso <tytso@mit.edu> ---
The fact that the first fsck had just summary accounting errors in pass 1, and
then a subsequent, back-to-back fsck showed errors in pass2, screams either (a)
some kind of hardware error, (b) the two mirrored copies of the RAID1 are out
of sync, or (c) someone or something else was modifying the filesytem at the
same time (i.e., the file system was mounted, and for some reason e2fsck's
safety checks didn't trigger, or it some other fsck or userspace program was
running at the same time, etc.)

I'm going to guess that (b) is the most likely, since this is a local
filesystem (i.e., you're not using fibre channel, or a remote block device, or
a dual-hosted SCSI arrangement or anything else exotic).   Could you try to
force a resync of the RAID mirrors, and then run another e2fsck -f check?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
