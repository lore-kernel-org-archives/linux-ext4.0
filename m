From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43292] jdb2 lockup with ext3 and nfs
Date: Tue, 29 May 2012 21:44:13 +0000 (UTC)
Message-ID: <20120529214414.0347D11FD1B@bugzilla.kernel.org>
References: <bug-43292-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33897 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab2E2VoQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 May 2012 17:44:16 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 41BBA20210
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2012 21:44:15 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 0741E203B7
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2012 21:44:14 +0000 (UTC)
In-Reply-To: <bug-43292-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43292





--- Comment #3 from Florian Pritz <flo@xssn.at>  2012-05-29 21:44:13 ---
Created an attachment (id=73459)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=73459)
output of echo w > /proc/sysrq-trigger

This is with linux 3.0.32 instead of 3.4 because 3.4 had lots of bugs that
caused me to switch all systems away from it. (These might get their own
reports some day unless someone else takes care of them first)

If you think it really makes a difference I can switch back to 3.4 for testing.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
