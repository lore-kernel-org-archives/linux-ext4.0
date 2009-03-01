From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12793] New: ext4 gives wrong errno with too long extended attribute values
Date: Sun,  1 Mar 2009 04:40:58 -0800 (PST)
Message-ID: <bug-12793-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752414AbZCAMlb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Mar 2009 07:41:31 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n21CexZF019080
	for <linux-ext4@vger.kernel.org>; Sun, 1 Mar 2009 04:41:00 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12793

           Summary: ext4 gives wrong errno with too long extended attribute
                    values
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.29-rc6
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: betelgeuse@gentoo.org


Latest working kernel version: haven't seen it working
Earliest failing kernel version: 2.6.28-gentoo-r1 had the same issue
Distribution: Gentoo
Hardware Environment: SMP Sun Mar 1 14:15:44 EET 2009 i686 Intel(R) Core(TM)2
CPU 6600 @ 2.40GHz GenuineIntel GNU/Linux
Software Environment: Gentoo ~x86
Problem Description:

>From man attr_set:

       attr_set will fail if one or more of the following are true:

       [ENOATTR]        The attribute name given is not associated with the
indicated filesystem object and the ATTR_REPLACE flag bit was set.

       [E2BIG]          The value of the given attribute is too large, it
exceeds the maximum allowable size of an attribute value.

This is what the test script gives for ext4:

3900                                            
4000                                                                            
4100                                                                            
Traceback (most recent call last):                                              
  File "test_xattr.py", line 10, in <module>                                    
    xattr.set('/mnt/test/header.txt','user.test',s)                             
IOError: [Errno 28] No space left on device   

This is what xfs gives:

65500
65600
Traceback (most recent call last):
  File "test_xattr.py", line 10, in <module>
    xattr.set('/mnt/test/header.txt','user.test',s)
IOError: [Errno 7] Argument list too long

>>> errno.errorcode[7]
'E2BIG'
>>> errno.errorcode[28]
'ENOSPC'

Steps to reproduce:

betelgeuse@pena ~/python $ cat test_xattr.py
import xattr
hundred = ''
for i in range(100):
        hundred+='a'

s=hundred

while True:
        print len(s)
        xattr.set('/mnt/test/header.txt','user.test',s)
        s+=hundred


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
