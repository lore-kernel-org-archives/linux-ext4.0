From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51431] ext4_mb_generate_buddy self ext4 errors
Date: Sat,  8 Dec 2012 16:42:45 +0000 (UTC)
Message-ID: <20121208164245.A0C1A11FC70@bugzilla.kernel.org>
References: <bug-51431-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50362 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964908Ab2LHQms (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Dec 2012 11:42:48 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2DDA8201B0
	for <linux-ext4@vger.kernel.org>; Sat,  8 Dec 2012 16:42:47 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id AD573201AA
	for <linux-ext4@vger.kernel.org>; Sat,  8 Dec 2012 16:42:45 +0000 (UTC)
In-Reply-To: <bug-51431-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51431





--- Comment #4 from Eric Sandeen <sandeen@redhat.com>  2012-12-08 16:42:45 ---
Ok, so it was a userspace/kernel mismatch that caused the errors to repeat.

The root cause for the original errors is still unknown, I guess (they must
have been encountered on the 3.0.54 kernel, FWIW).

I'd be interested to know what bug you hit on which centos kernel, if you want
to shoot me an email.

Thanks,
-Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
