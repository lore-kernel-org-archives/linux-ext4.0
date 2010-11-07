From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 22302] New: 2.6.36 BUG: scheduling while atomic:
 rc.sysinit/1376/0x00000002
Date: Sun, 7 Nov 2010 08:18:58 GMT
Message-ID: <bug-22302-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:58194 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab0KGITA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Nov 2010 03:19:00 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oA78IxR1016827
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 7 Nov 2010 08:18:59 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D22302

           Summary: 2.6.36 BUG: scheduling while atomic:
                    rc.sysinit/1376/0x00000002
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.36
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: maciej.rutecki@gmail.com
                CC: rjw@sisk.pl, maciej.rutecki@gmail.com,
                    mathias.buren@gmail.com
        Regression: Yes


Subject    : 2.6.36 BUG: scheduling while atomic: rc.sysinit/1376/0x000=
00002
Submitter  : Mathias Bur=C3=A9n <mathias.buren@gmail.com>
Date       : 2010-11-01 18:39
Message-ID : AANLkTi=3DkkW7ruOVp7mPsMDWRRkL2CqrOJCyZqxj_Vekm@mail.gmail=
=2Ecom
References : http://marc.info/?l=3Dlinux-kernel&m=3D128863676810517&w=3D=
2

This entry is being used for tracking a regression from 2.6.35. Please =
don't
close it until the problem is fixed in the mainline.

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
