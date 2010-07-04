From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15875] Add an option to disable file/directory permissions for
 ACL'ed file systems
Date: Sun, 4 Jul 2010 14:25:54 GMT
Message-ID: <201007041425.o64EPspJ012574@demeter.kernel.org>
References: <bug-15875-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54251 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab0GDOZz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Jul 2010 10:25:55 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o64EPs3R012578
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 4 Jul 2010 14:25:54 GMT
In-Reply-To: <bug-15875-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15875





--- Comment #9 from Artem S. Tashkinov <t.artem@mailcity.com>  2010-07-04 14:25:46 ---
Created an attachment (id=27012)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=27012)
Tentative patch

Probably it's not difficult to write an implementation, but I have no idea how
to check mount flags in namei.c inode_permission() function.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
