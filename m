From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14620] New: WARNING: at mm/page_alloc.c:1805
 __alloc_pages_nodemask
Date: Mon, 16 Nov 2009 21:30:29 GMT
Message-ID: <bug-14620-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56794 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbZKPVaY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Nov 2009 16:30:24 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAGLUUYH018112
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2009 21:30:30 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=3D14620

           Summary: WARNING: at mm/page_alloc.c:1805
                    __alloc_pages_nodemask
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.31-rc6
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: rjw@sisk.pl
            Blocks: 14230
        Regression: Yes


Subject    : 2.6.31-rc6: WARNING: at mm/page_alloc.c:1805 __alloc_pages=
_nodemas
Submitter  : Rog=C3=A9rio Brito <rbrito@ime.usp.br>
Date       : 2009-11-06 23:10
References : http://marc.info/?l=3Dlinux-kernel&m=3D125754907413892&w=3D=
4

This entry is being used for tracking a regression from 2.6.31.  Please=
 don't
close it until the problem is fixed in the mainline.

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
