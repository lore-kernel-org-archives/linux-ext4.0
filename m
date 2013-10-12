From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61631] kernel BUG at fs/ext4/super.c:818 umounting md raid6
 volume
Date: Sat, 12 Oct 2013 00:14:36 +0000
Message-ID: <bug-61631-13602-fAnPNCyCeW@https.bugzilla.kernel.org/>
References: <bug-61631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34453 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab3JLAOm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Oct 2013 20:14:42 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B774020386
	for <linux-ext4@vger.kernel.org>; Sat, 12 Oct 2013 00:14:41 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 18E6220374
	for <linux-ext4@vger.kernel.org>; Sat, 12 Oct 2013 00:14:39 +0000 (UTC)
In-Reply-To: <bug-61631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61631

--- Comment #9 from Jim Faulkner <jfaulkne@ccs.neu.edu> ---
I ran dumpe2fs -h followed by sync a few times, but was not able to trigger the
bug, nor did the dumpe2fs output differ between syncs.

umount did trigger the bug, however, and the dumpe2fs output was different
after the umount.

After triggering the bug, I was able to capture the debugfs output of one of
the listed inodes.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
