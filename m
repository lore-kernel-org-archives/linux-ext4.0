From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 41712] kernel BUG at fs/jbd/transaction.c:1155!
Date: Sat, 14 Jan 2012 00:58:48 GMT
Message-ID: <201201140058.q0E0wmpO015568@bugzilla.kernel.org>
References: <bug-41712-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:41469 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab2ANA6t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jan 2012 19:58:49 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q0E0wmIg015569
	for <linux-ext4@vger.kernel.org>; Sat, 14 Jan 2012 00:58:48 GMT
In-Reply-To: <bug-41712-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=41712





--- Comment #1 from Simon <sur3@gmx.de>  2011-08-26 04:31:57 ---
Created an attachment (id=70352)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=70352)
fsck finally destroyed the remaining filesystem :-/ O.o

fsck finally destroyed the remaining filesystem :-/ O.o

--- Comment #2 from Simon <sur3@gmx.de>  2012-01-14 00:58:48 ---
ext4 also destroyed evrything, so probalby its a luks problem with 4k-sektor
gpt drives?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
