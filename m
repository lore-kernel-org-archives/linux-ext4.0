From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71301] New: CPU soft lockup
Date: Fri, 28 Feb 2014 16:28:30 +0000
Message-ID: <bug-71301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54406 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbaB1Q2c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Feb 2014 11:28:32 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C66D320240
	for <linux-ext4@vger.kernel.org>; Fri, 28 Feb 2014 16:28:31 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id DF2F42026D
	for <linux-ext4@vger.kernel.org>; Fri, 28 Feb 2014 16:28:30 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=71301

            Bug ID: 71301
           Summary: CPU soft lockup
           Product: File System
           Version: 2.5
    Kernel Version: 3.13.5
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: cyril.adrian@gmail.com
        Regression: No

Created attachment 127701
  --> https://bugzilla.kernel.org/attachment.cgi?id=127701&action=edit
.config and syslog

During a simple and innocent "du" :-)

The process locked in the kernel, I could not kill it, machine froze at
shutdown (I had to turn it off the hard way).

I join the syslog (only starting from the first bug).

Home-compiled kernel, .config joined too.

For more info please ask.

Best regards,

Cyril

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
