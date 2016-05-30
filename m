From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118511] Corruption of VM qcow2 image file on EXT4 with crypto
 enabled
Date: Mon, 30 May 2016 16:46:11 +0000
Message-ID: <bug-118511-13602-hpsh9krNE4@https.bugzilla.kernel.org/>
References: <bug-118511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34805 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161668AbcE3QqP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 May 2016 12:46:15 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4E98B200C6
	for <linux-ext4@vger.kernel.org>; Mon, 30 May 2016 16:46:13 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id DA228202B8
	for <linux-ext4@vger.kernel.org>; Mon, 30 May 2016 16:46:11 +0000 (UTC)
In-Reply-To: <bug-118511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118511

ass3mbler@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |PATCH_ALREADY_AVAILABLE

--- Comment #3 from ass3mbler@gmail.com ---
Hi Navin,

I can confirm that moving to kernel 4.6 following your suggestion fully solved
the issue.

Thank you a lot for pointing me in the right direction, I mark this issue as
resolved.

Best regards,

Andrew

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
