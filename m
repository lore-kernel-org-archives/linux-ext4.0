From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 70121] Increasing efficiency of full data journaling
Date: Thu, 06 Mar 2014 05:28:19 +0000
Message-ID: <bug-70121-13602-Vy8eJ3NxWe@https.bugzilla.kernel.org/>
References: <bug-70121-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:36742 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaCFF2W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Mar 2014 00:28:22 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 09DB3201CE
	for <linux-ext4@vger.kernel.org>; Thu,  6 Mar 2014 05:28:21 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A57F32018B
	for <linux-ext4@vger.kernel.org>; Thu,  6 Mar 2014 05:28:19 +0000 (UTC)
In-Reply-To: <bug-70121-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=70121

--- Comment #4 from sworddragon2@aol.com ---
> It does no such thing.

What does it not?


> Data
> journaling only makes sense for an external journal on an ssd or
> similar

~2 years ago I have disabled full data journaling for a short time but at this
point an application crashed while it was writing a lot of files. The result
was that many files got damaged which encouraged me to never disable full data
journaling again. Now I'm seeing only 2 possible states of a file: Either it is
only registered in the filesystem with a size of 0 bytes or it is completely
written. I was never able to reproduce a half-written file with full data
journaling enabled.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
