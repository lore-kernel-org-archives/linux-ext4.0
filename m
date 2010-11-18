From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23232] New: kernel hang on insert ext4 usb key
Date: Thu, 18 Nov 2010 16:45:42 GMT
Message-ID: <bug-23232-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:54711 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab0KRQpm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Nov 2010 11:45:42 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oAIGjg9r001553
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 18 Nov 2010 16:45:42 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23232

           Summary: kernel hang on insert ext4 usb key
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.37-rc2-git3
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: shal@free.fr
        Regression: No


Created an attachment (id=37592)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=37592)
error messages of the kernel

Hello,

On my 2.6.37-rc2-git3 (with sched_autogroup patch), my computer crash when I
insert an USB key formated in ext4. No problem if the  usb key is in vfat.

When the bug occured, I can used magic sys key but the sync works.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
