From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16165] Wrong data returned on read after write if file size was
 changed with ftruncate before
Date: Fri, 23 Jul 2010 21:51:42 GMT
Message-ID: <201007232151.o6NLpgXV016425@demeter.kernel.org>
References: <bug-16165-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60188 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab0GWVvm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Jul 2010 17:51:42 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o6NLpgpD016426
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 23 Jul 2010 21:51:42 GMT
In-Reply-To: <bug-16165-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16165





--- Comment #19 from Eric Sandeen <sandeen@redhat.com>  2010-07-23 21:51:37 ---
Alexander, there is another corruption problem that we've been chasing related
to unaligned AIO on ext4 & xfs; see:

http://archives.free.net.ph/message/20100722.190526.4de99e37.en.html

and

http://git.kernel.org/?p=fs/xfs/xfstests-dev.git;a=commit;h=b05ae2d65379ccf92eb3fe8360325dd2287bf766

The patches above won't take care of that problem.

Chuck, good question about when they'll be merged... I dunno.

-Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
