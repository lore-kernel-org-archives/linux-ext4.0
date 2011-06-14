From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14203] File permissions not working correctly
Date: Tue, 14 Jun 2011 19:13:17 GMT
Message-ID: <201106141913.p5EJDHil007862@demeter1.kernel.org>
References: <bug-14203-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:35817 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab1FNTNS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jun 2011 15:13:18 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p5EJDHFH007863
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jun 2011 19:13:17 GMT
In-Reply-To: <bug-14203-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=14203


Artem S. Tashkinov <t.artem@mailcity.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |INVALID




--- Comment #1 from Artem S. Tashkinov <t.artem@mailcity.com>  2011-06-14 19:13:14 ---
This bug has nothing to do with ext* file systems, it's the FS expected
behaviour according to POSIX.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
