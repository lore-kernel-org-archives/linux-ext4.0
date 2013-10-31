From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 63471] Please add a "quit" command to the e2fsck interactive
 mode
Date: Thu, 31 Oct 2013 01:11:42 +0000
Message-ID: <bug-63471-13602-oSuEmoE5oG@https.bugzilla.kernel.org/>
References: <bug-63471-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55639 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab3JaBLp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Oct 2013 21:11:45 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8EC4D20414
	for <linux-ext4@vger.kernel.org>; Thu, 31 Oct 2013 01:11:44 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 856E5203EC
	for <linux-ext4@vger.kernel.org>; Thu, 31 Oct 2013 01:11:42 +0000 (UTC)
In-Reply-To: <bug-63471-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=63471

--- Comment #2 from unforgettableid@gmail.com ---
"Quit Safely" would be helpful for e2fsck newbies who want to halt the machine,
go to bed, and hire an expert the next day.

"Quit Safely" would also be helpful to e2fsck newbies who want to use a
console-mode Web browser or IRC client to get help.

"Quit Safely" would also be helpful to e2fsck newbies who:
* accidentally started the tool in fully-interactive mode
* but realize they should have used -y ("Yes to All") mode.
Those users could simply choose "Quit Safely" then rerun e2fsck with the -y
option.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
