From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13603] Fallocate and DirectIO
Date: Sat, 6 Mar 2010 08:46:06 GMT
Message-ID: <201003060846.o268k6E9005359@demeter.kernel.org>
References: <bug-13603-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46851 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab0CFIqJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Mar 2010 03:46:09 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o268k7Wt005361
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 6 Mar 2010 08:46:07 GMT
In-Reply-To: <bug-13603-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13603


Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX




--- Comment #2 from Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>  2010-03-06 08:45:54 ---
yes ,with the changes from mingming  we should be able to close the bug

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
