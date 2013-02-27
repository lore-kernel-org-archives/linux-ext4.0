From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 54551] New: write fails with one short >2GB write.
Date: Wed, 27 Feb 2013 14:49:33 +0000 (UTC)
Message-ID: <bug-54551-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60481 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759935Ab3B0Otg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Feb 2013 09:49:36 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9E18520334
	for <linux-ext4@vger.kernel.org>; Wed, 27 Feb 2013 14:49:35 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 9AFAC2031A
	for <linux-ext4@vger.kernel.org>; Wed, 27 Feb 2013 14:49:34 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=54551

           Summary: write fails with one short >2GB write.
           Product: File System
           Version: 2.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: meetmehiro@gmail.com
        Regression: No


Hi,

I have one application where we are writing on-short 3G of data but when write
succeed, it writes only 2G of data.

simple program.

if ( (ret = write(fd,buf,3221225472)) != limit) {

printf("\nError no:=%d",errno);
printf("\nret : %d",ret);
}

in above program, write only writes 2GB data..

could you please tell me, how to resolve this..

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
