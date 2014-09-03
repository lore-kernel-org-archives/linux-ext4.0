From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 56241] running e4defrag provokes "kernel BUG at
 fs/buffer.c:1833!"
Date: Wed, 03 Sep 2014 14:37:38 +0000
Message-ID: <bug-56241-13602-b2zVRPjr8P@https.bugzilla.kernel.org/>
References: <bug-56241-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38283 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932402AbaICOhy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Sep 2014 10:37:54 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C86702021B
	for <linux-ext4@vger.kernel.org>; Wed,  3 Sep 2014 14:37:44 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A41E2201DD
	for <linux-ext4@vger.kernel.org>; Wed,  3 Sep 2014 14:37:38 +0000 (UTC)
In-Reply-To: <bug-56241-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=56241

j.fikar@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |OBSOLETE

--- Comment #2 from j.fikar@gmail.com ---
I haven't seen that error for long time now, I suppose it is resolved. Now I
have 3.16.0.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
