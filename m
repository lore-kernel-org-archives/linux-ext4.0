From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15875] Add an option to disable file/directory access controls
 for USB stick-type storage devices
Date: Tue, 9 Nov 2010 20:41:48 GMT
Message-ID: <201011092041.oA9KfmnW013483@demeter2.kernel.org>
References: <bug-15875-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:49300 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab0KIUlt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Nov 2010 15:41:49 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oA9Kfmln013484
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 9 Nov 2010 20:41:48 GMT
In-Reply-To: <bug-15875-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15875





--- Comment #12 from Artem S. Tashkinov <t.artem@mailcity.com>  2010-11-09 20:41:45 ---
Yes, Theodore, you are quite right.

At first I wanted this option to be available only for ext{2,3,4} filesystems,
but then I realized it's good to have it on a VFS level (some people may
actually use any other FS on their removable mass storage devices).

And since this bug doesn't progress anywhere can you raise this question on
LKML? After all you are a core kernel developer, so people will likely listen
to your proposition more attentively.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
