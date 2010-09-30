From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 19362] WARNING: at fs/fs-writeback.c:87
 __mark_inode_dirty+0x1f2/0x230()
Date: Thu, 30 Sep 2010 15:05:59 GMT
Message-ID: <201009301505.o8UF5x5O002229@demeter1.kernel.org>
References: <bug-19362-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56124 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638Ab0I3PGA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Sep 2010 11:06:00 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o8UF5x6m002230
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 30 Sep 2010 15:05:59 GMT
In-Reply-To: <bug-19362-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=19362


Thomas Renninger <trenn@suse.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
  Attachment #32042|0                           |1
        is obsolete|                            |




--- Comment #3 from Thomas Renninger <trenn@suse.de>  2010-09-30 15:05:55 ---
Created an attachment (id=32072)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=32072)
Argh, I uploaded the wrong, the local mtab, this one is mtab of the affected
system

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
