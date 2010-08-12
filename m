From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15391] EXT4_USE_FOR_EXT23 causes ext4 partition to be mounted
 as ext2
Date: Thu, 12 Aug 2010 16:27:57 GMT
Message-ID: <201008121627.o7CGRvPa022390@demeter.kernel.org>
References: <bug-15391-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43617 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab0HLQ16 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Aug 2010 12:27:58 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o7CGRvSf022391
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 12 Aug 2010 16:27:57 GMT
In-Reply-To: <bug-15391-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15391


Alec Moskvin <alecm@gmx.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|2.6.33                      |2.6.35




--- Comment #1 from Alec Moskvin <alecm@gmx.com>  2010-08-12 16:27:54 ---
This bug is still present in Linux 2.6.35.1, but it can be easily worked-around
by appending "rootfstype=ext4" to the boot options.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
