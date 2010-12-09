From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15875] Add an option to disable file/directory access controls
 for USB stick-type storage devices
Date: Thu, 9 Dec 2010 16:50:58 GMT
Message-ID: <201012091650.oB9GovFA023147@demeter1.kernel.org>
References: <bug-15875-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:47271 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab0LIQvA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Dec 2010 11:51:00 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oB9Gow02023148
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 9 Dec 2010 16:50:58 GMT
In-Reply-To: <bug-15875-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15875


sergey <sergey-feo@yandex.ru> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sergey-feo@yandex.ru




--- Comment #13 from sergey <sergey-feo@yandex.ru>  2010-12-09 16:50:51 ---
Excuse me for my bad English :-)

Now we have many variants that can be implemented.

1. Disable rights control at VFS level or at formatting time. 
a) at VFS level only (FS-independent)
b) at formatting time only (FS-dependent)
c) both at VFS level and at formatting time (FS level). Default option is
"rights on". It can be overwritted at FS level during formatting and then it
can be overwritted at VFS level during mounting.

My vote is 1c.

2. In case of VFS-level option - what UID, GID and mode will be set for created
files and directories?
a) as always. Independ of option "Disable rights control".
b) user root, group root, rwxrwxrwx.
c) something like umask option will be implemented.

In other words, we mount FS with disabling rights. Then we write something on
it. Then we remount FS with enabling rights. What permissions will we see?

My vote is 2a.

3. Lets imagine that we have ext3 filesistem mounted with "Disable right
control" option enabled. We run ls -l - what permissions will it show?
a) rwxrwxrwx
b) rwArwArwA, where A = true when at least one of "executable" bits on disk is
set to "true".

In other words, will our new option affect all rights or only read-write but
not exec?   

My vote is 3a (simple solution).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
