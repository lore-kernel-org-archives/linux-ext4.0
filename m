From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15768] Incorrectly calculated free blocks result in ENOSPC from
 writepage
Date: Sun, 13 Jun 2010 11:44:33 GMT
Message-ID: <201006131144.o5DBiXrF015861@demeter.kernel.org>
References: <bug-15768-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36742 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab0FMLof (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Jun 2010 07:44:35 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o5DBiY1j015863
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 13 Jun 2010 11:44:34 GMT
In-Reply-To: <bug-15768-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15768


Rafael J. Wysocki <rjw@sisk.pl> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |CLOSED
         Resolution|PATCH_ALREADY_AVAILABLE     |CODE_FIX




--- Comment #6 from Rafael J. Wysocki <rjw@sisk.pl>  2010-06-13 11:44:30 ---
Fixed by commit 84061e07c5fbbbf9dc8aef8fb750fc3a2dfc31f3 .

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
