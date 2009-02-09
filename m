From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12676] New: fs/ext4/extents.c: In function =?UTF-8?Q?_=E2=80=98ext4_ext_search_right=E2=80=99:?= fs/ext4/extents.c:1120: warning: =?UTF-8?Q?_=E2=80=98ix=E2=80=99?= may be used uninitialized in this function
Date: Mon,  9 Feb 2009 03:15:49 -0800 (PST)
Message-ID: <bug-12676-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549AbZBILQX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Feb 2009 06:16:23 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n19BFnD4008359
	for <linux-ext4@vger.kernel.org>; Mon, 9 Feb 2009 03:15:50 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=3D12676

           Summary: fs/ext4/extents.c: In function
                    =E2=80=98ext4_ext_search_right=E2=80=99: fs/ext4/ex=
tents.c:1120:
                    warning: =E2=80=98ix=E2=80=99 may be used uninitial=
ized in this
                    function
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.28.4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: blubaustin@gmail.com


Latest working kernel version:2.6.29-rc2
Earliest failing kernel version:2.6.29rc3
Distribution:Debian Sid
Hardware Environment:Imac G3 600mhz 640MB RAM, 40GB Hard drive
Software Environment:?
Problem Description:
When compiling gets this error on Ext4 FS:
"fs/ext4/extents.c: In function =E2=80=98ext4_ext_search_right=E2=80=99=
:
fs/ext4/extents.c:1120: warning: =E2=80=98ix=E2=80=99 may be used unini=
tialized in this
function
"

Steps to reproduce:Compile kernel with Ext4


--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
