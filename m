From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47151] provide a file system block size of 8KB for certain
 SSDs.
Date: Fri,  5 Oct 2012 17:30:55 +0000 (UTC)
Message-ID: <20121005173055.7E6A411FC3E@bugzilla.kernel.org>
References: <bug-47151-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37995 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965Ab2JERa7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Oct 2012 13:30:59 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 005112050F
	for <linux-ext4@vger.kernel.org>; Fri,  5 Oct 2012 17:30:58 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 856CE20540
	for <linux-ext4@vger.kernel.org>; Fri,  5 Oct 2012 17:30:55 +0000 (UTC)
In-Reply-To: <bug-47151-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47151


Elmar Stellnberger <estellnb@elstel.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |REOPENED
         Resolution|WILL_NOT_FIX                |




--- Comment #9 from Elmar Stellnberger <estellnb@elstel.org>  2012-10-05 17:30:55 ---
No, there seem to be plenty of users requiring it: my first search for 'SSD 8K
file system block size' has produced an immediate hit at place #1:
http://forums.gentoo.org/viewtopic-t-935946.html?sid=6b0893c88505b69270c47558ff641326

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
