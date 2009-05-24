From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13369] kernel BUG at fs/ext4/inode.c:3123
Date: Sun, 24 May 2009 12:02:05 GMT
Message-ID: <200905241202.n4OC25oQ029095@demeter.kernel.org>
References: <bug-13369-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50221 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbZEXMCE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 May 2009 08:02:04 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4OC2543029096
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2009 12:02:05 GMT
In-Reply-To: <bug-13369-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13369





--- Comment #7 from Chris Komner <ckom26@gmail.com>  2009-05-24 12:02:05 ---
The 1k blocksize was decided accidentally by an obsolete and forgotten
/etc/mke2fs.conf, and ATM I can't back up the data and reformat 4k.

The reproduction of the problem is as easy as it gets: I just launch ktorrent
and wait. Of note might be that after the bug occurs, normal reboot procedure
hangs, the kernel seems to sync and remount read-only with the magic sysrq
combos, but fails to reboot or poweroff and there's always some loss of data in
the partition.

The latest dmesg snip follows attached.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
