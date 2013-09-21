From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61631] kernel BUG at fs/ext4/super.c:818 umounting md raid6
 volume
Date: Sat, 21 Sep 2013 02:08:04 +0000
Message-ID: <bug-61631-13602-6rnrZpMfoW@https.bugzilla.kernel.org/>
References: <bug-61631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44649 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab3IUCIR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Sep 2013 22:08:17 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2FE10204EA
	for <linux-ext4@vger.kernel.org>; Sat, 21 Sep 2013 02:08:16 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 5C2FB204DE
	for <linux-ext4@vger.kernel.org>; Sat, 21 Sep 2013 02:08:14 +0000 (UTC)
In-Reply-To: <bug-61631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61631

--- Comment #7 from Jim Faulkner <jfaulkne@ccs.neu.edu> ---
(In reply to Theodore Tso from comment #5)

> Hmm, can you say a bit more about what sort of files you store on the
> file system and how the file system gets used?  What looks like is
> going on is that there is a whole series of inodes that have been left
> stalled on the orpaned inode list.  By the time we reach that point in
> the unmount, the in-memory orphan list should have been cleared.

This filesystem holds a wide variety of files.  A fair amount (and the majority
of the disk usage), is large mp3 (~5 mb) and video (500 mb to 4 gb) files. 
However, most I/O happens on small files.  It hosts the gentoo portage tree
which I update regularly, as well as regular rdiff-backups of other servers on
my network.  Both of these are involve a lot of reading and modifying of lots
of small files.

(In reply to Jan Kara from comment #6)
> Since the mountpoint is named /nfs, I suppose you are exporting the
> filesystem via NFS, right? There has been a bug in NFS server code leading
> to exactly the problems you are describing. Commit
> bf7bd3e98be5c74813bee6ad496139fb0a011b3b should fix the issue (in 3.12-rc1).

Yes, I serve large video and mp3 files over NFS.  But in addition, the gentoo
portage tree on this filesystem is NFS exported to all gentoo hosts on my
network.  Any gentoo portage operations (emerge --metadata as well as updates)
results in lots of NFS I/O on lots of small files.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
