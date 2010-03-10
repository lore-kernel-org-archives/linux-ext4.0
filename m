From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Wed, 10 Mar 2010 15:36:25 GMT
Message-ID: <201003101536.o2AFaP8H021656@demeter.kernel.org>
References: <bug-14830-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47928 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab0CJPg0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Mar 2010 10:36:26 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2AFaPbw021657
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 10 Mar 2010 15:36:26 GMT
In-Reply-To: <bug-14830-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14830


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #21 from Eric Sandeen <sandeen@redhat.com>  2010-03-10 15:36:20 ---
Michael, you're right the patch is not in f12 (not in upstream yet, either).

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
