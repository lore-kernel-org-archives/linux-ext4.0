From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25352] resizing ext4 will corrupt filesystem
Date: Tue, 21 Dec 2010 19:19:47 GMT
Message-ID: <201012211919.oBLJJl5A014667@demeter2.kernel.org>
References: <bug-25352-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:39764 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab0LUTTs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Dec 2010 14:19:48 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oBLJJl7N014668
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 21 Dec 2010 19:19:47 GMT
In-Reply-To: <bug-25352-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25352





--- Comment #9 from Theodore Tso <tytso@mit.edu>  2010-12-21 19:19:46 ---
Ah, thanks for the clarification.

Ok, I think I see what's going on.  It's a difference of how e2fsck treats a
case of rec_len == 0 for block sizes less than 64k compared to the kernel.  
It's an edge case, but it's one we should definitely fix.  Thanks for pointing
it out.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
