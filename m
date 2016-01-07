From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 108631] Stuck on mb_cache_spinlock
Date: Thu, 07 Jan 2016 15:33:08 +0000
Message-ID: <bug-108631-13602-IXzpZRjmsF@https.bugzilla.kernel.org/>
References: <bug-108631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34512 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbcAGPdM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Jan 2016 10:33:12 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A32CB201C0
	for <linux-ext4@vger.kernel.org>; Thu,  7 Jan 2016 15:33:10 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 087552014A
	for <linux-ext4@vger.kernel.org>; Thu,  7 Jan 2016 15:33:09 +0000 (UTC)
In-Reply-To: <bug-108631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=108631

--- Comment #5 from Norman Meilick <nm@sbe.de> ---
Thank you very much, I'll try the patches tomorrow.

And yes, we're indeed running several LXC containers on the affected servers.

One quick correction to my original comment: When I stated that kernel 3.14
does not seem to be affected, I mixed up the version number. It's 3.13 that
doesn't exhibit any problems for us (we didn't test with 3.14). I'm sorry for
the mistake.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
