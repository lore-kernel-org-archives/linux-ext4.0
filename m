From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 38852] Oops in page_waitqueue during large copy to ext4
 filesystem
Date: Wed, 6 Jul 2011 14:57:28 GMT
Message-ID: <201107061457.p66EvSwc004847@demeter2.kernel.org>
References: <bug-38852-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:59238 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab1GFO52 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jul 2011 10:57:28 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p66EvSGY004848
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 6 Jul 2011 14:57:28 GMT
In-Reply-To: <bug-38852-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=38852


Jim Paris <jim@jtan.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |INVALID




--- Comment #2 from Jim Paris <jim@jtan.com>  2011-07-06 14:57:27 ---
Nevermind this report.  Besides installing new disks and upgrading the kernel,
I also added more RAM, so I just ran memtester for a while:

pagesize is 4096
pagesizemask is 0xfffffffffffff000
want 4096MB (4294967296 bytes)
got  4096MB (4294967296 bytes), trying mlock ...locked.
Loop 1:
  Stuck Address       : ok
  Random Value        : FAILURE: 0xfbb90e87ff7d6321 != 0xfbb90e87ff7d6721 at
offset 0x08ab3585.
FAILURE: 0xf7fcbbb567f370e7 != 0xf7fcbbb567f374e7 at offset 0x08ac3585.
FAILURE: 0xaedce87b7ff0b265 != 0xaedce87b7ff0b665 at offset 0x08b86f85.
FAILURE: 0x237ffcdd3b79d98a != 0x237ffcdd3b79dd8a at offset 0x08bbcd85.

... etc.

I'll go back to my known-good RAM and close this for now.  Sorry for the noise.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
