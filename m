From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17361] Watchdog detected hard LOCKUP in
 jbd2_journal_get_write_access
Date: Tue, 7 Sep 2010 22:05:22 GMT
Message-ID: <201009072205.o87M5MHp024738@demeter1.kernel.org>
References: <bug-17361-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39013 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab0IGWFX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Sep 2010 18:05:23 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o87M5M7J024739
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 7 Sep 2010 22:05:22 GMT
In-Reply-To: <bug-17361-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=17361


Andrew Morton <akpm@linux-foundation.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |akpm@linux-foundation.org
          Component|ext3                        |ext4
         AssignedTo|fs_ext3@kernel-bugs.osdl.or |fs_ext4@kernel-bugs.osdl.or
                   |g                           |g




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
