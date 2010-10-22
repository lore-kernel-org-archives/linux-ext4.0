From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 20902] New: High
Date: Fri, 22 Oct 2010 08:56:20 GMT
Message-ID: <bug-20902-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:45585 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab0JVI4V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Oct 2010 04:56:21 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o9M8uKxe008356
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 22 Oct 2010 08:56:20 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=20902

           Summary: High
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.36-020636rc8-generic
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: martinmoerch@gmail.com
        Regression: No


I'm running an ext4 filesystem on a LUKS device that sits ontop of an LVM
device. The filesystem is created with no special options and is used for
storing filessizes ranging from 1KB to 20GB.

I experience extremely high IO wait times when trying to write files to the
filesystem, bot locally and through Samba.

The problem can be reproduced by doing a reboot, unlocking with cryptsetup,
mounting the filesystem and then writing a file to any directory on the
filesystem. The 'cp' process stalls for almost 15 minutes and then returns to
normal and completes the copy eventually. If I then 'cp' the same file again,
there's no problem at all and the copy goes through like normal without
stalling for 15 minutes. Rebooting and doing it again, reproduces the problem
immediately.

I've attached anything that might be of interest to anyone who'd want to look
into this.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
