From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 36172] "kernel BUG at fs/ext4/super.c" triggered after
 tune2fs/remount
Date: Tue, 31 May 2011 19:29:43 GMT
Message-ID: <201105311929.p4VJThFo023179@demeter2.kernel.org>
References: <bug-36172-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:44105 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245Ab1EaT3n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 May 2011 15:29:43 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p4VJThuW023180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 31 May 2011 19:29:43 GMT
In-Reply-To: <bug-36172-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=36172


Manish Katiyar <mkatiyar@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mkatiyar@gmail.com




--- Comment #3 from Manish Katiyar <mkatiyar@gmail.com>  2011-05-31 19:29:40 ---
Yes, either tune2fs should be fixed to not change the mounted fs state, or the
code should be prepared to deal with it silently. Since the next mount isn't
going
to see the journal, it doesn't matter whether we clear the errors or not.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
