From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 108631] Stuck on mb_cache_spinlock
Date: Thu, 07 Jan 2016 14:09:39 +0000
Message-ID: <bug-108631-13602-7f6xqQUFU4@https.bugzilla.kernel.org/>
References: <bug-108631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56559 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbcAGOJq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Jan 2016 09:09:46 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4D7B0201C8
	for <linux-ext4@vger.kernel.org>; Thu,  7 Jan 2016 14:09:41 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A4DDB20172
	for <linux-ext4@vger.kernel.org>; Thu,  7 Jan 2016 14:09:39 +0000 (UTC)
In-Reply-To: <bug-108631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=108631

Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |ASSIGNED
                 CC|                            |jack@suse.cz

--- Comment #2 from Jan Kara <jack@suse.cz> ---
Yeah, although your workload seems to be different than what's described in bug
107301, the principal problem with mbache is the same. Can either of you guys
test patches I have posted which should fix it? I'll attach tarball with them
in a moment.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
