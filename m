From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 36312] New: User belonging to another Group has no access when
 chmod 0040
Date: Tue, 31 May 2011 00:19:20 GMT
Message-ID: <bug-36312-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:56721 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab1EaATV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 May 2011 20:19:21 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p4V0JKSX022026
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 31 May 2011 00:19:20 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=36312

           Summary: User belonging to another Group has no access when
                    chmod 0040
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.39
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: ubuntuefnet@gmail.com
        Regression: Yes


This may not be a bug, this may be intentional - however it was considered
pretty damn weird when encountered and worth a mention.

Say we have user 'bob', he is the owner of file 'accounting.txt' and
'accounting.txt' has group 'staff' attributed to the file which 'bob' is a part
of. If the permissions for the file only have group perms (e.g 0060), 'bob'
will not be able to access 'accounting.txt', however all other users in the
'staff' group will have access.

Replication via CLI:

touch myfile.txt && chown `whoami`:`groups | awk '{print $2}'` myfile.txt &&
chmod 0040 myfile.txt && cat myfile.txt

System: Debian 6.0.1
Arch: x86_64
Kernel: 2.6.39

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
