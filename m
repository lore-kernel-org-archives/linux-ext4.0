From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15875] New: Add options to disable POSIX acl for ext2/ext3/ext4
 file systems
Date: Thu, 29 Apr 2010 09:29:12 GMT
Message-ID: <bug-15875-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40848 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933315Ab0D3Rbx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Apr 2010 13:31:53 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3T9TCRl022990
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 29 Apr 2010 09:29:12 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15875

           Summary: Add options to disable POSIX acl for ext2/ext3/ext4
                    file systems
           Product: File System
           Version: 2.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: enhancement
          Priority: P1
         Component: ext2
        AssignedTo: fs_ext2@kernel-bugs.osdl.org
        ReportedBy: t.artem@mailcity.com
        Regression: No


VFAT becomes less of an option for many hardware producers and many of them
will be glad to embrace ext2/ext3/ext4 filesystems but they have an inherent
problem, they enforce POSIX ACLs.

So, imagine a situation when Peter who has UID=63555 (he's in a corporate
network and that's his real UID according to LDAP) formats his flash drive
using ext2/ext3/ext4 filesystem, then uses sudo to recursively chown the whole
filesystem for his own possession.

Now, Peter comes to a less savvy Alice who wasn't given root permissions on her
PC and she tries to open Peter's flash stick. Oops, Alice cannot open or read
any file on it. I can come up with ten other different scenarios when ACLs are
superfluous.

Taking this situation into consideration it becomes clear that ACL's for
removable storage is more a hassle than a security feature.

So, I strongly suggest implementing a flag which tells the kernel to disregard
all file/directory permissions on the aforementioned FS's.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
