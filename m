From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Mon, 31 Aug 2015 18:03:10 +0000
Message-ID: <bug-102731-13602-taNjppTriJ@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41002 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036AbbHaSDN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Aug 2015 14:03:13 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6D37720697
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2015 18:03:12 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 441AB2068A
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2015 18:03:11 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #8 from Theodore Tso <tytso@mit.edu> ---
How many guest VM's are you running, and how often does the file system
corruption happens?   It sounds like it's about once every 2-3 weeks?

Would you be willing to experiment running the VM without using the RAID1 so
we're bypassing the MD layer?   One of the common factors between those people
who are reporting this are (a) they are using KVM, and (b) they are using RAID.
  Now, I'm doing all of my testing using KVM, and I've never seen anything like
this.   So I wonder if the operative issue is happening at the MD layer....

You workload is common enough that I would expect that if this was happening
for everyone who was using ext4, I should be getting a lot more bug reports.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
