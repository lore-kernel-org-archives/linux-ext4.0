From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 121371] fsck created undeletable directory
Date: Sun, 03 Jul 2016 18:43:55 +0000
Message-ID: <bug-121371-13602-JF4vTniW9U@https.bugzilla.kernel.org/>
References: <bug-121371-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40144 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbcGCSn6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Jul 2016 14:43:58 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7D7462026F
	for <linux-ext4@vger.kernel.org>; Sun,  3 Jul 2016 18:43:57 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 05DDD2024C
	for <linux-ext4@vger.kernel.org>; Sun,  3 Jul 2016 18:43:56 +0000 (UTC)
In-Reply-To: <bug-121371-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=121371

--- Comment #4 from Grief <iamgrief@gmail.com> ---
(In reply to Darrick J. Wong from comment #3)
> The undeletable directory also has the inline_data flag set, even though the
> filesystem doesn't ==> possible memory bitflip?

Was that question addressed to me? Sorry, I don't think that I can help with
the answer.

By the way, while one from askubuntu.com has success with removing both
directories with removal of attributes from them, I was able to remove only one
directory with that way. the second doesn't even let me see attrbutes set on
that dir:
http://askubuntu.com/questions/794371/lsattr-permission-denied-while-reading-flags-on-directory

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
