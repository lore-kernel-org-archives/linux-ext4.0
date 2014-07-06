From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42723] EXT4-fs error: ext4_mb_generate_buddy
Date: Sun, 06 Jul 2014 19:42:09 +0000
Message-ID: <bug-42723-13602-GvaW5B9xsE@https.bugzilla.kernel.org/>
References: <bug-42723-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60065 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbaGFTmM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Jul 2014 15:42:12 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D44B02039D
	for <linux-ext4@vger.kernel.org>; Sun,  6 Jul 2014 19:42:10 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 01526202EC
	for <linux-ext4@vger.kernel.org>; Sun,  6 Jul 2014 19:42:10 +0000 (UTC)
In-Reply-To: <bug-42723-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42723

--- Comment #20 from mai ling <mai.ling.lists.35@gmail.com> ---
Thank you so much for your kind clarification, Theo.
After re-reading your reply and my dmesg I found out I was simply fsck-ing the
wrong device :)
I did fsck the reporting filesystem and the issue went away.
Cheers :)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
