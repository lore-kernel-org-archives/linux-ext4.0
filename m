From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15792] ext4_inode_inode->i_flags modification is racy
Date: Thu, 15 Apr 2010 22:17:57 GMT
Message-ID: <201004152217.o3FMHv24030052@demeter.kernel.org>
References: <bug-15792-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40950 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab0DOWR6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Apr 2010 18:17:58 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3FMHvtb030054
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 15 Apr 2010 22:17:57 GMT
In-Reply-To: <bug-15792-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15792





--- Comment #1 from Dmitry Monakhov <dmonakhov@openvz.org>  2010-04-15 22:17:54 ---
Created an attachment (id=26026)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=26026)
xfstest testcase patch

This is trivial but proven to be useful fsstress based test-case.
i'm run it like follows
while true; do ./check 227 || break ; done

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
