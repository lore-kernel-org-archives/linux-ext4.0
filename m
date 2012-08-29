From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 44731] ext4 deadlock under heavy io?
Date: Wed, 29 Aug 2012 17:26:26 +0000 (UTC)
Message-ID: <20120829172626.973AB11FB38@bugzilla.kernel.org>
References: <bug-44731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58700 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976Ab2H2R03 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Aug 2012 13:26:29 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B5F46202D4
	for <linux-ext4@vger.kernel.org>; Wed, 29 Aug 2012 17:26:28 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 98F97202BC
	for <linux-ext4@vger.kernel.org>; Wed, 29 Aug 2012 17:26:26 +0000 (UTC)
In-Reply-To: <bug-44731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=44731





--- Comment #9 from Neil Brown <neilb@suse.de>  2012-08-29 17:26:26 ---
The patch I referred to fixed problems with process hanging in
get_active_stripes().
This appears in the comment #2 trace, so the patch may fix that problem.
As you say the original problem does not mention MD raid, so it is probably a
different problem.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
