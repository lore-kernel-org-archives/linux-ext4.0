From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 24282] linux/ext2_fs.h uses defines from linux/fs.h
Date: Fri, 3 Dec 2010 15:58:33 GMT
Message-ID: <201012031558.oB3FwXZ0006133@demeter1.kernel.org>
References: <bug-24282-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:60770 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab0LCP6e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Dec 2010 10:58:34 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oB3FwYNc006148
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 3 Dec 2010 15:58:34 GMT
In-Reply-To: <bug-24282-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=24282





--- Comment #3 from Eric Sandeen <sandeen@redhat.com>  2010-12-03 15:58:32 ---
ah, userspace.  Thanks, that wasn't clear.

commit 36695673b012096228ebdc1b39a6a5850daa474e
Author: David Howells <dhowells@redhat.com>
Date:   Tue Aug 29 19:06:16 2006 +0100

    [PATCH] BLOCK: Move common FS-specific ioctls to linux/fs.h [try #6]

changed to use those FS_ flags; maybe one of the existing #includes used to
pull in fs.h, not sure.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
