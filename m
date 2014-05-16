From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76261] ext4_da_writepages err -30 after remount ro during
 shutdown
Date: Fri, 16 May 2014 12:11:39 +0000
Message-ID: <bug-76261-13602-vosoZMtB0a@https.bugzilla.kernel.org/>
References: <bug-76261-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44857 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbaEPMLm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 May 2014 08:11:42 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 887F7202EB
	for <linux-ext4@vger.kernel.org>; Fri, 16 May 2014 12:11:41 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 108F72008F
	for <linux-ext4@vger.kernel.org>; Fri, 16 May 2014 12:11:40 +0000 (UTC)
In-Reply-To: <bug-76261-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=76261

--- Comment #10 from Theodore Tso <tytso@mit.edu> ---
So see my earlier answer.   If this is a normal shutdown, you must use syncfs()
or the normal umount to unmount the file system.   Emergency_remount is
designed for emergencies when it may not be possible to do a blocking
writeback.   You could change emergency_remount to pass in a force value of 0
instead of 1.  However, this will break non-android use cases where the system
administrator really needs the current behaviour in a real emergency.  Worse,
even for the android use case, there may be times when there may be some kind
of I/O error or other malfunction, where a blocking writeblock could stall the
umount process indefinitely.

So the right answer really is to use the algorithm I've outlined in comment #6.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
