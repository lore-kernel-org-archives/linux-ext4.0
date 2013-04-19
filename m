From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 56831] New: RHEL Linux Data Corruption found with EXT4 system
Date: Fri, 19 Apr 2013 13:41:02 +0000 (UTC)
Message-ID: <bug-56831-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58603 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030356Ab3DSNlG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Apr 2013 09:41:06 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C7BA02067A
	for <linux-ext4@vger.kernel.org>; Fri, 19 Apr 2013 13:41:03 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 7C2FA20610
	for <linux-ext4@vger.kernel.org>; Fri, 19 Apr 2013 13:41:02 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=56831

           Summary: RHEL Linux Data Corruption found with EXT4 system
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.32-220
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: searchfordave@gmail.com
                CC: lalwanihiro@gmail.com
        Regression: No


The attached file when compiled on a 32GB Mem system, gives a data corruption
if run with number of threads greater than 15

How to run:
1. compile: # gcc random_multi_write_read.c -o test -lpthread
2. Usage:   # ./test <file path> <no. of threads>
3. Run:     # ./test file_1 15

Sample Output:
Starting 15 write threads to file_1 at different offsets and write sizes...
Parallelly reading the file for any data corruption...
DATA CORRUPTION HIT
Actual: '', Expected: 'K'd
, start:4581061500, end:5039167650
...

For More info, refer file "V_loop<%d>char<%c>" which gets created newly to
capture the corrupted data as soon as corruption is hit.

Test system details:
#CPUS: 2
#CORES: 6
SYSTEM MEMORY: 15 GB
SWAP MEMORY: 17 GB

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
