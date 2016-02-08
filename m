From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Mon, 08 Feb 2016 10:56:09 +0000
Message-ID: <bug-102731-13602-v0mEI5PstL@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39983 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbcBHK4M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Feb 2016 05:56:12 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0E753203B1
	for <linux-ext4@vger.kernel.org>; Mon,  8 Feb 2016 10:56:11 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 87A2A203A4
	for <linux-ext4@vger.kernel.org>; Mon,  8 Feb 2016 10:56:09 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #38 from John Hughes <john@calva.com> ---
My current status is:

Host: 4.2.3
Guest: 3.16.7

Guest uptime: 20 days.

I'm going to leave it like this for some more time, but my current 
feeling is that the ext4 subsystem in a KVM quest is only stable if the 
host kernel is > 4.something.  The ext3 subsystem did not seem to be 
vunerable to whatever the host was doing wrong before 4.whatever.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
