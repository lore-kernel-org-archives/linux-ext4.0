From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 39732] JBD: Spotted dirty metadata buffer (dev = dm-2, blocknr
 = 2512725). There's a risk of filesystem corruption in case of system crash.
Date: Fri, 22 Jul 2011 22:13:33 GMT
Message-ID: <201107222213.p6MMDXW0019388@demeter1.kernel.org>
References: <bug-39732-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:51994 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab1GVWNe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Jul 2011 18:13:34 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p6MMDXpr019390
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jul 2011 22:13:33 GMT
In-Reply-To: <bug-39732-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=39732


Rafael J. Wysocki <rjw@sisk.pl> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |rjw@sisk.pl
             Blocks|                            |36912




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
