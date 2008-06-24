From: Andrew Morton <akpm@linux-foundation.org>
Subject: Fw: [Bug 10976] New: Soft lockup on (intentionally) corrupted
 filesystem
Date: Tue, 24 Jun 2008 13:04:25 -0700
Message-ID: <20080624130425.7557e5e4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753239AbYFXUE5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jun 2008 16:04:57 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m5OK4Pdv031316
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jun 2008 13:04:26 -0700
Received: from akpm.corp.google.com (localhost [127.0.0.1])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with SMTP id m5OK4P8n003745
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jun 2008 13:04:25 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Begin forwarded message:

Date: Tue, 24 Jun 2008 12:42:00 -0700 (PDT)
From: bugme-daemon@bugzilla.kernel.org
To: akpm@linuxfoundation.org
Subject: [Bug 10976] New: Soft lockup on (intentionally) corrupted filesystem


http://bugzilla.kernel.org/show_bug.cgi?id=10976

           Summary: Soft lockup on (intentionally) corrupted filesystem
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.25.8 + patches for bug 10882 problems
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: akpm@osdl.org
        ReportedBy: sliedes@cc.hut.fi


Distribution: Debian sid (unstable)
Hardware Environment: qemu x86
Software Environment: Minimal Debian sid
Problem Description:

Mounting one of the attached intentionally corrupted ext3 filesystems and
accessing it causes a soft lockup. I believe they probably are the same bug
(both happen in __log_wait_for_space()), but the backtraces vary quite a bit so
I attach two test cases.

My kernel is 2.6.25.8 + three patches posted by Duane Griffin for #10882,
namely (I hope I understand the git terminology right, at least you can grep
lkml archives for these):
  - 6ae4ecf..8019bf2
  - 7712682..bc030f4
  - 0b8cf80..ea0236b



Steps to reproduce:

1. bunzip2 one of the filesystem images
2. mount fs.img /mnt
3. ls /mnt


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
