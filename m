From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23732] ext4 timestamp range contains 68-year gaps
Date: Thu, 19 Feb 2015 20:16:30 +0000
Message-ID: <bug-23732-13602-J6AVNIux96@https.bugzilla.kernel.org/>
References: <bug-23732-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35124 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbbBSUQe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Feb 2015 15:16:34 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A81B420351
	for <linux-ext4@vger.kernel.org>; Thu, 19 Feb 2015 20:16:33 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E154520353
	for <linux-ext4@vger.kernel.org>; Thu, 19 Feb 2015 20:16:30 +0000 (UTC)
In-Reply-To: <bug-23732-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23732

--- Comment #8 from Conrad Meyer <cse.cem@gmail.com> ---
The test case is 'touch -d 2243-01-01 test-123'... 2038 works fine.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
