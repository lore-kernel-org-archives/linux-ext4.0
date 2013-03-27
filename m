From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 55821] kernel oops when unmounting ext3 fs
Date: Wed, 27 Mar 2013 16:19:00 +0000 (UTC)
Message-ID: <20130327161900.AC73D11FB3C@bugzilla.kernel.org>
References: <bug-55821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39596 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990Ab3C0QTI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Mar 2013 12:19:08 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9A34D2043E
	for <linux-ext4@vger.kernel.org>; Wed, 27 Mar 2013 16:19:03 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 4D3D220418
	for <linux-ext4@vger.kernel.org>; Wed, 27 Mar 2013 16:19:01 +0000 (UTC)
In-Reply-To: <bug-55821-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=55821


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz
         AssignedTo|fs_ext3@kernel-bugs.osdl.or |jack@suse.cz
                   |g                           |




--- Comment #2 from Jan Kara <jack@suse.cz>  2013-03-27 16:19:00 ---
Thanks for report. The fix for this problem is already in my tree (commit
e643692138cfa33528f054b071ba2583509bb217).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
