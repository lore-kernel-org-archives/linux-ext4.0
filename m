From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16711] New: Oops with 2.6.36-rc1
Date: Sat, 21 Aug 2010 10:07:31 GMT
Message-ID: <bug-16711-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58883 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab0HUKHc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Aug 2010 06:07:32 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o7LA7V2l005903
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 21 Aug 2010 10:07:31 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16711

           Summary: Oops with 2.6.36-rc1
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.36-rc1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: devnull@plzk.org
                CC: akpm@linux-foundation.org, eparis@redhat.com
        Regression: Yes


The ubuntu/debian build of 2.6.36-rc1 from [1] doesn't boot on my macbook
v.2.1. It's most likely not an EXT4 bug but I have no idea where to put it and
cc people that probably know better. I am linking to a crappy cellphone shot of
the oops, please see [2].

Unfortunately, due to the kernel-package in ubuntu being broken once again, I
can't build myself, hence no bisecting. All I can say is that 2.6.35-rc2 from
the same ppa works.

Let me know if additional info is needed.

Regards,
Tobias

[1] http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.36-rc1-maverick/
[2] http://img841.imageshack.us/img841/6654/imag0030l.jpg

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
