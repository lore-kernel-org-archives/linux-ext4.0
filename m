From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51571] Assertion of j_running_transaction on
 jbd2_journal_flush()
Date: Wed, 12 Dec 2012 00:10:57 +0000 (UTC)
Message-ID: <20121212001057.2E03111F9D5@bugzilla.kernel.org>
References: <bug-51571-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:42926 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385Ab2LLALD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Dec 2012 19:11:03 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2D67C202D6
	for <linux-ext4@vger.kernel.org>; Wed, 12 Dec 2012 00:11:02 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 39B9F202E2
	for <linux-ext4@vger.kernel.org>; Wed, 12 Dec 2012 00:10:58 +0000 (UTC)
In-Reply-To: <bug-51571-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51571





--- Comment #2 from Jan Kara <jack@suse.cz>  2012-12-12 00:10:56 ---
Created an attachment (id=88941)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=88941)
Patch fixing assertion failure in jbd2_journal_flush()

Can you test this patch please?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
