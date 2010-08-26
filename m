From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16711] Oops with 2.6.36-rc1
Date: Thu, 26 Aug 2010 09:36:18 GMT
Message-ID: <201008260936.o7Q9aIDN002315@demeter1.kernel.org>
References: <bug-16711-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38524 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab0HZJgU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Aug 2010 05:36:20 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o7Q9aJJr002318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 26 Aug 2010 09:36:19 GMT
In-Reply-To: <bug-16711-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16711





--- Comment #5 from John Johansen <john.johansen@canonical.com>  2010-08-25 16:14:50 ---
Tobias,

thanks for testing.  It looks like apparmor is disabled in both.  Can you
provide some more detail about your setup?

--- Comment #6 from John Johansen <john.johansen@canonical.com>  2010-08-26 09:35:12 ---
Tobias,

Can you clarify how the kernel packaging in ubuntu is broken, so we can look
into fixing it.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
