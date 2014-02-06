From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 70121] New: Increasing efficiency of full data journaling
Date: Thu, 06 Feb 2014 10:38:04 +0000
Message-ID: <bug-70121-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38022 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755954AbaBFKiH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Feb 2014 05:38:07 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CFC7A20154
	for <linux-ext4@vger.kernel.org>; Thu,  6 Feb 2014 10:38:06 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A01CE20145
	for <linux-ext4@vger.kernel.org>; Thu,  6 Feb 2014 10:38:04 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=70121

            Bug ID: 70121
           Summary: Increasing efficiency of full data journaling
           Product: File System
           Version: 2.5
    Kernel Version: 3.13.1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: enhancement
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: sworddragon2@aol.com
        Regression: No

Full data journaling provides the ability that it is guaranteed that a file
will never be saved visible for the user in a damaged state (except a hardware
defect appears afterwards). But this has the disadvantage that the writing
througput is ~halfed as all files are written 2 times.

Here comes the idea: From a logical view to achieve this safety it is not
needed to write the file 2 times. A simple committing should achieve the same
level of safety. Here is an example: The filesystem could store a value for the
file which is reflecting its state. It is initialized as empty value indicating
the file has not successfully be written. As soon as the file has been written
it is set to 1. This would avoid writing the file 2 times and still guarantee
that the file will never be visible for te user in a damaged state on a crash
as the filesystem check would see that the file state is unequal to 1 and
correct the problem.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
