From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Wed, 25 Nov 2015 10:09:44 +0000
Message-ID: <bug-102731-13602-cddW65xG7c@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47830 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbbKYKJv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Nov 2015 05:09:51 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9E06B208D1
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2015 10:09:50 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E306F208DB
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2015 10:09:44 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #31 from John Hughes <john@calva.com> ---
Ok, its now been 35 days since the last problem.

I'm currently running:

Host: 4.2.3
Guest: 4.2.3

Unfortunately when I moved the host from 3.16 to 4.2.3 I also changed the
amount of memory available for the guest, poor style for debugging but I was
getting a lot of flack from disgruntled users.

I will now try moving the guest back to 3.16 with 1G of ram to see whether the
problem was solved by changing the host kernel or by changing the guest memory
size.

More news as it becomes available.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
