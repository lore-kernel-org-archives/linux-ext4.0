From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102621] New: Directory name or file name staring with '-'
 cannot be handled through command line,i.e.,terminal
Date: Mon, 10 Aug 2015 16:31:27 +0000
Message-ID: <bug-102621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60980 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115AbbHJQba (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Aug 2015 12:31:30 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 249B120646
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2015 16:31:29 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 52CA92063C
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2015 16:31:28 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102621

            Bug ID: 102621
           Summary: Directory name or file name staring with '-' cannot be
                    handled through command line,i.e.,terminal
           Product: File System
           Version: 2.5
    Kernel Version: 3.16.7-21-desktop
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext2
          Assignee: fs_ext2@kernel-bugs.osdl.org
          Reporter: saptarshinag620@gmail.com
        Regression: No

Firstly,one cannot create a directory or a file through command-line with its
name starting with '-'. That is one cannot give command like 'mkdir -test' or
'touch -test' where '-test' is the directory name and file name
respectively.But in other way,one can easily create or work with such directory
or file in GUI,but that file or directory cannot be accessed or handled through
command-line.It has been tested in Suse Linux and Ubuntu,maybe it is universal
bug for linux

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
