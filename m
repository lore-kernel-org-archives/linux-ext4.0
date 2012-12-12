From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51571] Assertion of j_running_transaction on
 jbd2_journal_flush()
Date: Wed, 12 Dec 2012 04:26:28 +0000 (UTC)
Message-ID: <20121212042628.5399311F7D6@bugzilla.kernel.org>
References: <bug-51571-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58891 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535Ab2LLE0c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Dec 2012 23:26:32 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 192CB20257
	for <linux-ext4@vger.kernel.org>; Wed, 12 Dec 2012 04:26:31 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 622832023D
	for <linux-ext4@vger.kernel.org>; Wed, 12 Dec 2012 04:26:29 +0000 (UTC)
In-Reply-To: <bug-51571-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51571





--- Comment #3 from yjwsignal@empal.com  2012-12-12 04:26:28 ---
Dear Jan Kara.

journal->j_running_transaction->t_handle_count is 0x0.

I also agree with your opinion. Thank you.

But, this bug is rarely happened.
ie, It is very difficult to reproduce this bug again.

But, as you memtioned, I also think that this bug has connection with
j_barrier_count at this race situation.

I wonder that this patch has the possibility to be applyed to the jbd2 at the
next release of kernel.

Thank you.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
