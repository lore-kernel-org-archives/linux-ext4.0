From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23682] New: kernel BUG at fs/jbd/commit.c:770!
Date: Wed, 24 Nov 2010 12:52:19 GMT
Message-ID: <bug-23682-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:47981 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab0KXMwU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Nov 2010 07:52:20 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oAOCqJSu023255
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 24 Nov 2010 12:52:20 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23682

           Summary: kernel BUG at fs/jbd/commit.c:770!
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.26-2-686
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: alvaro.uria@opendeusto.es
        Regression: No


Created an attachment (id=38032)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=38032)
uname -a and kernel log trace

System is Debian GNU/Linux "stable", used for Desktop purposes (browser and
email client). Without doing any particular task, and a few seconds after the
kernel error, Linux system got frozen.

"uname -a" output and kernel trace is being attached.

Please, ask me for more information if needed.

Thanks in advance.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
