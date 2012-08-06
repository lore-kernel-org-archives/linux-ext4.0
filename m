From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 45621] Kernel ooops: BUG: unable to handle kernel paging
 request at 000000080000001c
Date: Mon,  6 Aug 2012 22:14:42 +0000 (UTC)
Message-ID: <20120806221442.D539011FA3A@bugzilla.kernel.org>
References: <bug-45621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:32964 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950Ab2HFWOq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Aug 2012 18:14:46 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6D30D201EF
	for <linux-ext4@vger.kernel.org>; Mon,  6 Aug 2012 22:14:45 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id BD94B201E0
	for <linux-ext4@vger.kernel.org>; Mon,  6 Aug 2012 22:14:43 +0000 (UTC)
In-Reply-To: <bug-45621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=45621





--- Comment #6 from markus.doits@googlemail.com  2012-08-06 22:14:42 ---
Just ran memtest for 3+ hours, 3 passes finished successfully. I know, longer
is better, but cannot run it longer atm (since it's a server with crucial
infrastructure). System is not overclocked or so, everything default.

The oops happend to me about 3-4 times in the last 3 months, often on heavy io
but maybe once when idling (can't say exactly).

So I'll wait for the next one and report back - if there's a next one.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
