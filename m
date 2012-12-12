From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51571] Assertion of j_running_transaction on
 jbd2_journal_flush()
Date: Wed, 12 Dec 2012 15:18:18 +0000 (UTC)
Message-ID: <20121212151818.D2FDE11F7FB@bugzilla.kernel.org>
References: <bug-51571-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45342 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab2LLPSX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Dec 2012 10:18:23 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C6EF020262
	for <linux-ext4@vger.kernel.org>; Wed, 12 Dec 2012 15:18:22 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id E08E420267
	for <linux-ext4@vger.kernel.org>; Wed, 12 Dec 2012 15:18:19 +0000 (UTC)
In-Reply-To: <bug-51571-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51571





--- Comment #4 from Jan Kara <jack@suse.cz>  2012-12-12 15:18:18 ---
Thanks, t_handle_count == 0 confirms the scenario I described likely happened.
I'll push the fix upstream.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
