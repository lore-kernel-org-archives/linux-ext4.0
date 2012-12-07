From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51391] New: BUG: unable to handle kernel NULL pointer
 dereference
Date: Fri,  7 Dec 2012 11:21:01 +0000 (UTC)
Message-ID: <bug-51391-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:42839 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933552Ab2LGLVG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Dec 2012 06:21:06 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CC6452020A
	for <linux-ext4@vger.kernel.org>; Fri,  7 Dec 2012 11:21:04 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 9CEC2201F5
	for <linux-ext4@vger.kernel.org>; Fri,  7 Dec 2012 11:21:02 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51391

           Summary: BUG: unable to handle kernel NULL pointer dereference
           Product: File System
           Version: 2.5
    Kernel Version: 3.2.0-29-generic
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: ktsirunyan@gmail.com
        Regression: No


Architecture :  x86_64 emulated by VirtualBox version 4.1.2_Ubuntu r38459
Distributive :     Ubuntu 12.04
File System  :     Ext4
Detected by the Spruce System (http://linuxtesting.org/spruce)
Bug appears when trying to mount a device with MS_NODEV flag attempted.
See the kernel message attached below.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
