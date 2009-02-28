From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12790] New: kernel build warning causes EXT4 boot warning
Date: Sat, 28 Feb 2009 02:25:46 -0800 (PST)
Message-ID: <bug-12790-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752096AbZB1K0U (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Feb 2009 05:26:20 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1SAPlKP025598
	for <linux-ext4@vger.kernel.org>; Sat, 28 Feb 2009 02:25:48 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12790

           Summary: kernel build warning causes EXT4 boot warning
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.28.7
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: thoralf.dassler@gmail.com


Latest working kernel version: unknown
Earliest failing kernel version: unknown
Distribution: Slamd64
Hardware Environment: Toshiba Satellite P200
Software Environment: n/a
Problem Description: Boot message: 
EXT4-fs warning (device sda1): ext4_fill_super: extents feature not enabled on
this filesystem, use tune2fs.
Steps to reproduce: boot into Linux

I get these lines when I build the kernel: 
CC      fs/ext4/super.o
fs/ext4/super.c: In function 'ext4_fill_super':
fs/ext4/super.c:2177: warning: format '%u' expects type 'unsigned int', but
argument 2 has type 'ext4_group_t'

See .config attached. I also noticed several patches on Google, but am
reluctant to apply them.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
