From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29492] kernel BUG at
 /home/kernel-ppa/COD/linux/fs/inode.c:1421!
Date: Fri, 25 Feb 2011 10:21:44 GMT
Message-ID: <201102251021.p1PALiFN030845@demeter1.kernel.org>
References: <bug-29492-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:40683 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404Ab1BYKVo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Feb 2011 05:21:44 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p1PALimB030846
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 25 Feb 2011 10:21:44 GMT
In-Reply-To: <bug-29492-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29492


Florian Mickler <florian@mickler.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |florian@mickler.org




--- Comment #4 from Florian Mickler <florian@mickler.org>  2011-02-25 10:21:38 ---
Does https://bugzilla.kernel.org/show_bug.cgi?id=29202#c10 fix this?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
