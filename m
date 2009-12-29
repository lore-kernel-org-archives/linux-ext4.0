From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14936] kernel BUG at fs/ext4/inode.c:1063 if attempted to use
 non-ext4 partition with ext4
Date: Tue, 29 Dec 2009 17:00:20 GMT
Message-ID: <200912291700.nBTH0Krj014636@demeter.kernel.org>
References: <bug-14936-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56064 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbZL2RAU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Dec 2009 12:00:20 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id nBTH0Krp014637
	for <linux-ext4@vger.kernel.org>; Tue, 29 Dec 2009 17:00:20 GMT
In-Reply-To: <bug-14936-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14936


Nicolas Reinecke <pl4nkton@googlemail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |pl4nkton@googlemail.com




--- Comment #3 from Nicolas Reinecke <pl4nkton@googlemail.com>  2009-12-29 17:00:18 ---
*** Bug 14911 has been marked as a duplicate of this bug. ***

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
