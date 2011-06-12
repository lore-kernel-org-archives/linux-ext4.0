From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 37212] NULL pointer dereference in inode_has_perm() while
 setquota
Date: Sun, 12 Jun 2011 09:35:43 GMT
Message-ID: <201106120935.p5C9Zhsk014746@demeter1.kernel.org>
References: <bug-37212-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:45565 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab1FLJfo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Jun 2011 05:35:44 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p5C9ZhXV014747
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 12 Jun 2011 09:35:43 GMT
In-Reply-To: <bug-37212-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=37212


Florian Mickler <florian@mickler.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |florian@mickler.org
         Resolution|                            |UNREPRODUCIBLE




--- Comment #1 from Florian Mickler <florian@mickler.org>  2011-06-12 09:35:41 ---
Lukas wrote in the thread above:
> I am not able to reproduce it on 3.0.0-rc2, so I guess it got fixed
> already.
> 
> -Lukas

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
