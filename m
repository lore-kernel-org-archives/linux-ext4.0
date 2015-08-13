From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102751] infinite loop in jbd2_journal_destroy()
Date: Thu, 13 Aug 2015 02:13:31 +0000
Message-ID: <bug-102751-13602-gUcxnSoT64@https.bugzilla.kernel.org/>
References: <bug-102751-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33342 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbbHMCNg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Aug 2015 22:13:36 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1436A20636
	for <linux-ext4@vger.kernel.org>; Thu, 13 Aug 2015 02:13:35 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 38B2320653
	for <linux-ext4@vger.kernel.org>; Thu, 13 Aug 2015 02:13:32 +0000 (UTC)
In-Reply-To: <bug-102751-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102751

--- Comment #1 from Eryu Guan <guaneryu@gmail.com> ---
Seems like the issue described in this thread (and there's a patch fixing this
problem)

http://www.spinics.net/lists/linux-ext4/msg48563.html

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
