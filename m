From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Sat, 03 Jan 2015 23:47:44 +0000
Message-ID: <bug-89511-13602-K6rhD6m5QA@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57845 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbbACXrs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 3 Jan 2015 18:47:48 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 32EC1201EC
	for <linux-ext4@vger.kernel.org>; Sat,  3 Jan 2015 23:47:47 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 8BA6320166
	for <linux-ext4@vger.kernel.org>; Sat,  3 Jan 2015 23:47:45 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #34 from Jun Itou <itou_jun@infoseek.jp> ---
When it is ext2, this phenomenon does not occur.
Is a journal function a problem?
Therefore will it be a thing called "write through"?

And I think of compatibility of ext4 to be contents by a version of kernel.
That when I format it in 3.2.62 and do mount in 3.2.63, an error appears in
"write through".

I looked at the source, but only a difference is checked because I do not
understand specifications.
Detailed one, please support it.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
