From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43292] jdb2 lockup with ext3 and nfs
Date: Wed, 30 May 2012 13:33:30 +0000 (UTC)
Message-ID: <20120530133330.0407811FD1B@bugzilla.kernel.org>
References: <bug-43292-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [198.145.19.201] ([198.145.19.201]:57366 "EHLO mail.kernel.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab2E3NeO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 May 2012 09:34:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DD9CE203D0
	for <linux-ext4@vger.kernel.org>; Wed, 30 May 2012 13:33:32 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 0D5EE203CC
	for <linux-ext4@vger.kernel.org>; Wed, 30 May 2012 13:33:30 +0000 (UTC)
In-Reply-To: <bug-43292-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43292





--- Comment #8 from Jan Kara <jack@suse.cz>  2012-05-30 13:33:29 ---
Hum, it looks exactly the same like the previous attempt. I'm starting to
suspect some problem with plugging or bio list handling. Since I can see you
can trigger the lockup pretty quickly, can you gather blktrace data for me? The
filesystem is on some device mapper device so you'll need to run something
like:
blktrace -d /dev/dm-2 -d /dev/sd? ...
where you include all scsi disks compounding the dm device. And then just
tar.gz the created files after the lockup happens and attach them here.
Hopefully we'll be able to see where the read got stuck. Thanks!

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
