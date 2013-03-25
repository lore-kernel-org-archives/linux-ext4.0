From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 55651] Non-atomic short write problem with O_APPEND
Date: Mon, 25 Mar 2013 20:59:31 +0000 (UTC)
Message-ID: <20130325205931.D140F11FB35@bugzilla.kernel.org>
References: <bug-55651-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51709 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab3CYU7j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Mar 2013 16:59:39 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id ABA71202EB
	for <linux-ext4@vger.kernel.org>; Mon, 25 Mar 2013 20:59:34 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 36980202E7
	for <linux-ext4@vger.kernel.org>; Mon, 25 Mar 2013 20:59:33 +0000 (UTC)
In-Reply-To: <bug-55651-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=55651





--- Comment #1 from Quentin Barnes <qbarnes@gmail.com>  2013-03-25 20:59:31 ---
I have a small mistake in the above report.  The problem does not reproduce on
RHEL6.2 (or earlier RHEL6 releases).  Only on RHEL6.3 and later.

So it looks like the bug came in between: v3.1 and v3.2, RHEL5.7 and RHEL5.8,
and RHEL6.2 and RHEL6.3.

I'm still poking about to see if I can figure out which patch that is so I can
better have a guess at which subsystem.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
