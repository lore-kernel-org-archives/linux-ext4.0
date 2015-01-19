From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89131] Hangs when checking torrent through libtorrent; kernel
 BUG at mm/iov_iter.c:219!
Date: Mon, 19 Jan 2015 17:36:59 +0000
Message-ID: <bug-89131-13602-guFosNZOf7@https.bugzilla.kernel.org/>
References: <bug-89131-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45883 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbbASRhF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Jan 2015 12:37:05 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4E1F220444
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2015 17:37:03 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A20D520445
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2015 17:37:00 +0000 (UTC)
In-Reply-To: <bug-89131-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89131

--- Comment #11 from Theodore Tso <tytso@mit.edu> ---
Created attachment 163831
  --> https://bugzilla.kernel.org/attachment.cgi?id=163831&action=edit
debugging patch (should apply for 3.17 and 3.18)

This BUG_ON is happening from the mm part of the direct_io code, which is
supposed to be file system independent, and so I don't know that half of the
DIO code as well.   Can you try applying the attached patch to see if it gets
us any useful information when the bug triggers?

Also, at this point it would be *really* useful if we could get a reproduction
case that doesn't require using rtorrent -- i.e., something that uses just dd,
or maybe a simple C program.   Would it be possible to run the a tty-mode
torrent on a serial console under strace, or some such, so we can get figure
out what the system calls were that apparently triggered the BUG_ON?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
