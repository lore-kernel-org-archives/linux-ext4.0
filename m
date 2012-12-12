From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51571] Assertion of j_running_transaction on
 jbd2_journal_flush()
Date: Wed, 12 Dec 2012 15:18:31 +0000 (UTC)
Message-ID: <20121212151831.0994B11FA0C@bugzilla.kernel.org>
References: <bug-51571-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45405 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab2LLPSl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Dec 2012 10:18:41 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C81C420294
	for <linux-ext4@vger.kernel.org>; Wed, 12 Dec 2012 15:18:31 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 0B5ED20262
	for <linux-ext4@vger.kernel.org>; Wed, 12 Dec 2012 15:18:31 +0000 (UTC)
In-Reply-To: <bug-51571-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51571


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|fs_ext4@kernel-bugs.osdl.or |jack@suse.cz
                   |g                           |




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
