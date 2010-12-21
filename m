From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25352] resizing ext4 will corrupt filesystem
Date: Tue, 21 Dec 2010 18:03:25 GMT
Message-ID: <201012211803.oBLI3PTl017760@demeter1.kernel.org>
References: <bug-25352-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:60175 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab0LUSD0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Dec 2010 13:03:26 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oBLI3PpC017761
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 21 Dec 2010 18:03:25 GMT
In-Reply-To: <bug-25352-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25352





--- Comment #8 from Kees Cook <kees@outflux.net>  2010-12-21 18:03:21 ---
Ted, no, sorry; I didn't mean to confuse. Those are just left-over corruption
from my initial fs hit. I just thought I'd report the fact that fsck didn't
notice this when cleaning up from the original corruption.

I.e. here's my timeline for this corruption:

resize
get errors in dmesg
umount
fsck -f (for half a day, cleans up tons)
mount
delete all of lost+found
continue using fs
more dmesg errors
umount
fsck -f (returns without error)
mount
continue using fs
still dmesg errors
rm offending directory completely
no more errors

So, it seemed like a flaw in fsck that it didn't find the bad directory, but
since it was related to the corruption introduced by this kernel bug, I thought
I'd bring it up in this thread.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
