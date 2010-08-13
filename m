From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16583] New: ext4: delayed block allocation failed and
 application not respond any more
Date: Fri, 13 Aug 2010 20:01:48 GMT
Message-ID: <bug-16583-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55263 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab0HMUBt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Aug 2010 16:01:49 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o7DK1mXX027356
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 13 Aug 2010 20:01:49 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16583

           Summary: ext4: delayed block allocation failed and application
                    not respond any more
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.35.1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: andrej.gelenberg@udo.edu
        Regression: No


dmesg:

EXT4-fs (dm-6): warning: mounting fs with errors, running e2fsck is recommended
EXT4-fs (dm-6): recovery complete
EXT4-fs (dm-6): mounted filesystem with ordered data mode. Opts: acl,commit=100
EXT4-fs (dm-6): mounted filesystem with ordered data mode. Opts: acl,commit=100
...
EXT4-fs error (device dm-6): ext4_ext_search_left: inode #3510: (comm
flush-254:6) ix (42117) != EXT_FIRST_INDEX (0) (depth 1)!
EXT4-fs (dm-6): delayed block allocation failed for inode 3510 at logical
offset 42117 with max blocks 77 with error -5
This should not happen!!  Data will be lost

transmission-daemon (which had the data on dm-6) don't respond anymore and i
can't kill it with kill -9. I can't shutdown the system too (only mit sys-rq
keys).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
