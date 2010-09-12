From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 18372] New: A filled up named pipe always has a size of zero!
Date: Sun, 12 Sep 2010 21:47:04 GMT
Message-ID: <bug-18372-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:32862 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab0ILVrG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Sep 2010 17:47:06 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o8CLl4ke021511
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 12 Sep 2010 21:47:04 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=18372

           Summary: A filled up named pipe always has a size of zero!
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.32-22-generic (also older and newer ones)
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: tom.bzliknl83947@online.de
                CC: tom.bzliknl83947@online.de
        Regression: No


Hi, there!

The size of a filled named pipe is always zero. This is wrong! A read operation
is going to hang for try to read from an empty pipe. To go around this trap it
is necessary to do a conditional test on the filesize, [ -s pipe ]. Problem:
The test doesn't work, because filesize is always zero.

Try:
mknod pipe &
sleep 3600  <>pipe &
echo 'date' >pipe
[ -s pipe ] && echo "filled up"
ls -l pipe; stat pipe    # if size zero, it is wrong
[ -s pipe ] && (read val <pipe; echo $val)


This is a critical error. While parallel processing a script would be blocked.
In worst case it causes a deadlock situation. Every changing of a condition of
a file should be reported whithin the i-node. 

I found it in several disto: Ubuntu KarmicKoala 9.1, LucidLynx 10.04,
Linux Mint Debian Edition 5, Slackware 13.1 x64

Best regards
TOM

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
