From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 39072] jbd2 writes on disk every few seconds
Date: Sat, 9 Jul 2011 15:19:18 GMT
Message-ID: <201107091519.p69FJI8K017411@demeter1.kernel.org>
References: <bug-39072-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:44294 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab1GIPTT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 Jul 2011 11:19:19 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p69FJIKS017412
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 9 Jul 2011 15:19:18 GMT
In-Reply-To: <bug-39072-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=39072


mkkot <marcin2006@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |marcin2006@gmail.com
           Platform|All                         |i386




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
