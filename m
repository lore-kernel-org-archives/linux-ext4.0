From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Thu, 11 Jun 2015 13:56:18 +0000
Message-ID: <bug-89511-13602-oQPopNy3Ac@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35477 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743AbbFKN4Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Jun 2015 09:56:24 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F3BA620661
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2015 13:56:21 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A19A720489
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2015 13:56:20 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #58 from Alan Stern <stern@rowland.harvard.edu> ---
If the "temporary write through" thing doesn't help then the patch I posted
won't help either.  This means the problem you are experiencing is _not_ the
same issue as the original one.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
