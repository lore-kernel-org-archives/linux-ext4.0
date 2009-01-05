From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12272] at random rmmod/insmod corrupts filesystem
Date: Mon,  5 Jan 2009 12:11:18 -0800 (PST)
Message-ID: <20090105201118.2DC3D108042@picon.linux-foundation.org>
References: <bug-12272-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752419AbZAEULU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Jan 2009 15:11:20 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n05KBIY1007801
	for <linux-ext4@vger.kernel.org>; Mon, 5 Jan 2009 12:11:19 -0800
In-Reply-To: <bug-12272-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12272





------- Comment #5 from folkert@vanheusden.com  2009-01-05 12:11 -------
After that I tried creating a file in each filesystem. When I hit /var I got
the following dmesg error:

[  335.006864] journal_bmap: journal block not found at offset 524 on dm-0
[  335.006927] Aborting journal on device dm-0.
[  353.624981] ext3_abort called.
[  353.625058] EXT3-fs error (device dm-0): ext3_journal_start_sb: Detected
aborted journal
[  353.625211] Remounting filesystem read-only

After that no file was accessible. E.g.:
debian:/home/folkert# umount /var
bash: /bin/umount: cannot execute binary file


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
