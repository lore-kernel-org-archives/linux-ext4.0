From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15906] performance regression in "umount" of filesystems using
 barriers
Date: Mon, 17 May 2010 03:44:21 GMT
Message-ID: <201005170344.o4H3iLUi029192@demeter.kernel.org>
References: <bug-15906-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45371 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab0EQDoW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 May 2010 23:44:22 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4H3iLwb029193
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 17 May 2010 03:44:21 GMT
In-Reply-To: <bug-15906-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15906





--- Comment #23 from Dmitry Monakhov <dmonakhov@openvz.org>  2010-05-17 03:44:19 ---
Created an attachment (id=26403)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=26403)
Fix async inodes writeback for FS with delalloc

Attach second patch, after it has passed 1 week review cycle in a list.

Seems that we have an agreement for both issues. IMHO They are 99.999% percent
candidates for 2.6.35-rc1(and then for stable).
Who will take care about patches? Jens, will you?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
