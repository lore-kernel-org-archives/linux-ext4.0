From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15655] corrupt ext3 fs and partial freeze
Date: Tue, 13 Apr 2010 11:23:00 GMT
Message-ID: <201004131123.o3DBN0iq020972@demeter.kernel.org>
References: <bug-15655-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60958 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab0DMLXD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Apr 2010 07:23:03 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3DBN0ZF020974
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 13 Apr 2010 11:23:00 GMT
In-Reply-To: <bug-15655-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15655


Alban Browaeys <prahal@yahoo.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX




--- Comment #1 from Alban Browaeys <prahal@yahoo.com>  2010-04-13 11:22:50 ---
This is fixed with de329820e920cd9cfbc2127cad26a37026260cce ext3: fix broken
handling of EXT3_STATE_NEW I guess. I have been unable to reproduce since this
-rc3. Regarding the nature of the bug I did not bisected as the issue was
always happening and now I uses -rc3 daily without hickup.

Thanks for the quick fix.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
