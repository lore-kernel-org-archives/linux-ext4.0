From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43292] jdb2 lockup with ext3 and nfs
Date: Thu, 31 May 2012 20:16:27 +0000 (UTC)
Message-ID: <20120531201627.B6CAC11FD1B@bugzilla.kernel.org>
References: <bug-43292-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53759 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964841Ab2EaUQa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 May 2012 16:16:30 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8C52620337
	for <linux-ext4@vger.kernel.org>; Thu, 31 May 2012 20:16:29 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id BE82C20330
	for <linux-ext4@vger.kernel.org>; Thu, 31 May 2012 20:16:27 +0000 (UTC)
In-Reply-To: <bug-43292-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43292





--- Comment #10 from Jan Kara <jack@suse.cz>  2012-05-31 20:16:27 ---
I have to say I'm puzzled. Everything looks normal, the IO is submitted and
completed, no sign of any hang. Just the last request - read - has been only
submitted to disk and not yet completed but that can be just a coincidence. To
check what has been read, can you attach here output of dumpe2fs /dev/dm-2?

When the lockup happens, those nfsd threads are sitting there doing nothing for
a long time, am I right?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
