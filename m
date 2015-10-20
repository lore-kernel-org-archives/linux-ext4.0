From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Tue, 20 Oct 2015 16:28:08 +0000
Message-ID: <bug-102731-13602-vaVZ1Z50bc@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59826 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbbJTQ2M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Oct 2015 12:28:12 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BCA7A2085A
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2015 16:28:10 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 54A0E206B1
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2015 16:28:09 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #29 from cwseys@physics.wisc.edu ---
If what we're seeing is the same thing...

8 of 10 VMs with <=1GB which have gone read-only.
0 of 2 VMs with >1GB where the problem has never occurred.

(This is an estimate:  May have missed some which have not gone read-only.)

So let's see what happens!
C.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
