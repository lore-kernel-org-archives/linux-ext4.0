From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 53741] New: Used block count in df output
Date: Wed, 13 Feb 2013 05:15:23 +0000 (UTC)
Message-ID: <bug-53741-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57700 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab3BMFP1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Feb 2013 00:15:27 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7D02520144
	for <linux-ext4@vger.kernel.org>; Wed, 13 Feb 2013 05:15:26 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 8D94620251
	for <linux-ext4@vger.kernel.org>; Wed, 13 Feb 2013 05:15:24 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=53741

               URL: http://marc.info/?l=linux-ext4&m=136021915127138&w=2
           Summary: Used block count in df output
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.32
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: mujeeb.adil@gmail.com
        Regression: No


I have an observation on EXT4 filesystem. I created filesystem of size
1TB, 4TB, and 7TB and then checked the output of df command.

df command showed the number of 1KB blocks used. The result was:
1TB: 204056
4TB: 198680
7TB: 181784

I performed the same on XFS and the result was:
1TB: 32928
4TB: 32928
7TB: 33024

EXT4 result shows with increasing filesystem size, the number of used
blocks decreased. This looks odd.

>From the linux-ext4 mailing list discussion
(http://marc.info/?l=linux-ext4&m=136021915127138&w=2), it seems to be a bug in
df reporting.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
