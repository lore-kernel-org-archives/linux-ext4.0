From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 78721] VFS: brelse: Trying to free free buffer
Date: Wed, 25 Jun 2014 13:26:59 +0000
Message-ID: <bug-78721-13602-q0sk27Jn5B@https.bugzilla.kernel.org/>
References: <bug-78721-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53385 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756700AbaFYN1C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Jun 2014 09:27:02 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E53112038E
	for <linux-ext4@vger.kernel.org>; Wed, 25 Jun 2014 13:27:00 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 766DD20394
	for <linux-ext4@vger.kernel.org>; Wed, 25 Jun 2014 13:26:59 +0000 (UTC)
In-Reply-To: <bug-78721-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=78721

Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |jack@suse.cz
         Resolution|---                         |CODE_FIX

--- Comment #2 from Jan Kara <jack@suse.cz> ---
This should be fixed by patch "ext4: Fix buffer double free in
ext4_alloc_branch()" which Ted already has in his tree and should merge it
upstream soon I believe.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
