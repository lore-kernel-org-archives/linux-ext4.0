From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16227] Mount command sees partition 2 and partition 7 as same
 partition
Date: Wed, 16 Jun 2010 17:58:14 GMT
Message-ID: <201006161758.o5GHwE4b001279@demeter.kernel.org>
References: <bug-16227-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57340 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab0FPR6P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jun 2010 13:58:15 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o5GHwEmY001282
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jun 2010 17:58:14 GMT
In-Reply-To: <bug-16227-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16227


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #2 from Eric Sandeen <sandeen@redhat.com>  2010-06-16 17:58:12 ---
This is certainly not an ext3 bug, and almost certainly not a kernel bug; my
money is on user error, but there's really not enough information to know.

output from:

# fdisk -l /dev/sda

and

# cat /proc/mounts

when you see this problem would be a start.  I'll take a quick look at that
output, but I'm hovering over the "NOTABUG" button, at least for the kernel bug
tracker.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
