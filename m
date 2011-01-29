From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 27652] 38-rc1: umount+rmmod cause ext4 error.
Date: Sat, 29 Jan 2011 12:03:22 GMT
Message-ID: <201101291203.p0TC3MOL022761@demeter1.kernel.org>
References: <bug-27652-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:46292 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab1A2MDZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 29 Jan 2011 07:03:25 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p0TC3OxZ022786
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 29 Jan 2011 12:03:24 GMT
In-Reply-To: <bug-27652-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=27652


Florian Mickler <florian@mickler.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |florian@mickler.org
         Resolution|                            |PATCH_ALREADY_AVAILABLE




--- Comment #7 from Florian Mickler <florian@mickler.org>  2011-01-29 12:02:12 ---
Patch: https://bugzilla.kernel.org/show_bug.cgi?id=27652#c6 

Tao Ma, does this work for you too?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
