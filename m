From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
Date: Wed, 13 Jul 2011 07:52:13 GMT
Message-ID: <201107130752.p6D7qDGJ002885@demeter2.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:40976 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965002Ab1GMHwN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jul 2011 03:52:13 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p6D7qD0g002886
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 13 Jul 2011 07:52:13 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832


Bryce Nesbitt <bryce2@obviously.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bryce2@obviously.com




--- Comment #84 from Bryce Nesbitt <bryce2@obviously.com>  2011-07-13 07:52:10 ---
The bug bit me today, after I pulled out a mounted ext3 usb drive.  A total
Kernel hang.  Video still displayed.  No ping.  No mouse.  No keyboard. 
Unfortunately I forgot about Magic SysRq
(http://en.wikipedia.org/wiki/Magic_SysRq_key ) and did not probe.  Here's all
I got:

# vi /var/log/syslog
Jul 13 00:31:43 ubuntu kernel: [181916.094245] JBD2: I/O error detected when
updating journal superblock for sde1-8.
Jul 13 00:40:49 ubuntu kernel: imklog 4.6.4, log source = /proc/kmsg started.

# uname -a
Linux ubuntu 2.6.38-8-generic #42-Ubuntu SMP Mon Apr 11 03:31:24 UTC 2011
x86_64 x86_64 x86_64 GNU/Linux

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
