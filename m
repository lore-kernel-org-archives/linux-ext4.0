From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13909] New: md5sum on 3GB file is constantly hanging
Date: Tue, 4 Aug 2009 10:44:46 GMT
Message-ID: <bug-13909-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53234 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693AbZHDKop (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Aug 2009 06:44:45 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n74AikQR023732
	for <linux-ext4@vger.kernel.org>; Tue, 4 Aug 2009 10:44:46 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13909

           Summary: md5sum on 3GB file is constantly hanging
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.30.4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: harbour@sfinx.od.ua
        Regression: Yes


Hi,

Simply pickup any 3GB file and try to md5sum it. Process is not killable. Plain
Linus kernel, latest gcc and binutils. Laptop AMD X2 Acer Ferrari 1100 on
SB600. Can supply any additional info.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
