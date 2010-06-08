From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16165] New: Wrong data returned on read after write if file
 size was changed with ftruncate before
Date: Tue, 8 Jun 2010 22:01:57 GMT
Message-ID: <bug-16165-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52280 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab0FHWB5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jun 2010 18:01:57 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o58M1vMb004791
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jun 2010 22:01:57 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16165

           Summary: Wrong data returned on read after write if file size
                    was changed with ftruncate before
           Product: File System
           Version: 2.5
    Kernel Version: at least up to 2.6.34
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: Alexander.Eichner@sun.com
        Regression: No


Created an attachment (id=26701)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=26701)
Testcase showing the corruption

Hi,

we use the direct async I/O API for file I/O in VirtualBox since 3.2 and got
some reports about corrupted guest filesystems. It turned out that only users
are affected which disk images are stored on a ext4 filesystem. I could create
a testcase which reproduces the error. Further investigation showed that the
data corruption happens if ftruncate is used, data is written to the so far
unallocated offset and immediately read back. The buffer holding the read data
contains only \0 afterwards. The data is there if the file is closed and
another
program is used to view the file content (less for example). Everything works
if ftruncate is not used.
The same testcase with ftruncate works on ext3 here. A simple testcase is
attached.

Compile with: gcc -D_GNU_SOURCE -o aio_corrupt aio_corrupt.c -laio
Usage: aio_corrupt <path/to/the/file>

Expected output: Success!
Output on ext3: Success!
Output on ext4: Corrupted buffer!

Kind regards,
Alexander Eichner

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
