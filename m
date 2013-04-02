From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 55081] BUG while unlinking inode with an xattr
Date: Tue,  2 Apr 2013 21:10:33 +0000 (UTC)
Message-ID: <20130402211033.EFDC711FA61@bugzilla.kernel.org>
References: <bug-55081-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:48329 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762258Ab3DBVKg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Apr 2013 17:10:36 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 25218204AC
	for <linux-ext4@vger.kernel.org>; Tue,  2 Apr 2013 21:10:35 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 06279204A0
	for <linux-ext4@vger.kernel.org>; Tue,  2 Apr 2013 21:10:34 +0000 (UTC)
In-Reply-To: <bug-55081-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=55081


Tyler Hicks <tyhicks@canonical.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX




--- Comment #2 from Tyler Hicks <tyhicks@canonical.com>  2013-04-02 21:10:33 ---
Sorry for not getting around to verifying the fix until now. I tested 3.9-rc5
and it looks good. Thanks!

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
