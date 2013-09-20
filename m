From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61631] kernel BUG at fs/ext4/super.c:818 umounting md raid6
 volume
Date: Fri, 20 Sep 2013 22:41:39 +0000
Message-ID: <bug-61631-13602-Dy2iDWuhjl@https.bugzilla.kernel.org/>
References: <bug-61631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:42081 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab3ITWlo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Sep 2013 18:41:44 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 650332017A
	for <linux-ext4@vger.kernel.org>; Fri, 20 Sep 2013 22:41:43 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E67142011D
	for <linux-ext4@vger.kernel.org>; Fri, 20 Sep 2013 22:41:41 +0000 (UTC)
In-Reply-To: <bug-61631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61631

Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz

--- Comment #6 from Jan Kara <jack@suse.cz> ---
Since the mountpoint is named /nfs, I suppose you are exporting the filesystem
via NFS, right? There has been a bug in NFS server code leading to exactly the
problems you are describing. Commit bf7bd3e98be5c74813bee6ad496139fb0a011b3b
should fix the issue (in 3.12-rc1).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
