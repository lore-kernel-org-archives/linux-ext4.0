From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 22922] New: 2.6.36: kernel panic in cascade (Fatal exception in
 interrupt)
Date: Sun, 14 Nov 2010 20:13:37 GMT
Message-ID: <bug-22922-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:60965 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab0KNUNi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Nov 2010 15:13:38 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oAEKDbHe017697
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 14 Nov 2010 20:13:37 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=22922

           Summary: 2.6.36: kernel panic in cascade (Fatal exception in
                    interrupt)
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
                CC: rjw@sisk.pl, maciej.rutecki@gmail.com, thomas@m3y3r.de
        Regression: Yes


Subject    : 2.6.36: kernel panic in cascade (Fatal exception in interrupt)
Submitter  : Thomas Meyer <thomas@m3y3r.de>
Date       : http://marc.info/?l=linux-kernel&m=128882381406884&w=2
Message-ID : 201011032334.30662.thomas@m3y3r.de
References : http://marc.info/?l=linux-kernel&m=128882381406884&w=2

This entry is being used for tracking a regression from 2.6.35. Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
