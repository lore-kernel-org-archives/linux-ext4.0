From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43292] jdb2 lockup with ext3 and nfs
Date: Thu,  7 Jun 2012 09:29:00 +0000 (UTC)
Message-ID: <20120607092900.9679511FC42@bugzilla.kernel.org>
References: <bug-43292-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:56895 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760468Ab2FGJ3E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Jun 2012 05:29:04 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7B9C520301
	for <linux-ext4@vger.kernel.org>; Thu,  7 Jun 2012 09:29:02 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id A235A20306
	for <linux-ext4@vger.kernel.org>; Thu,  7 Jun 2012 09:29:00 +0000 (UTC)
In-Reply-To: <bug-43292-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43292





--- Comment #20 from Jan Kara <jack@suse.cz>  2012-06-07 09:29:00 ---
Ah, that's interesting to know! It would be great if you could narrow down in
which -stable update the problem got introduced (that should take like 4 tests)
and then I can have a look at patches in that release and see whether something
that catches my eye.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
