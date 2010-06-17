From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16227] Mount command sees partition 2 and partition 7 as same
 partition
Date: Thu, 17 Jun 2010 18:11:52 GMT
Message-ID: <201006171811.o5HIBqhh032528@demeter.kernel.org>
References: <bug-16227-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48072 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734Ab0FQSLx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jun 2010 14:11:53 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o5HIBqkZ032529
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jun 2010 18:11:52 GMT
In-Reply-To: <bug-16227-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16227


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|fs_ext3@kernel-bugs.osdl.or |sandeen@redhat.com
                   |g                           |
             Status|NEW                         |RESOLVED
         Resolution|                            |INVALID




--- Comment #6 from Eric Sandeen <sandeen@redhat.com>  2010-06-17 17:44:48 ---
You have mounted the same device to 3 different mount points; of course a
change in one will show up on the other.  It's the same as a bind mount.

--- Comment #7 from Eugene Blanchard <eugene.blanchard@sait.ca>  2010-06-17 18:11:48 ---
That's a typo here, I was just trying to correct it at the same time that you
responded. 

mount /dev/cciss/c0d0p5 /mnt/p5
mount /dev/cciss/c0d0p6 /mnt/p6
mount /dev/cciss/c0d0p7 /mnt/p7

If this was a unique situation then I would agree that it could be pebkac
(problem exists between keyboard and chair) but it's occurred on 3 different
classes of servers: PC, DL320 and DL360. 

I've got a spare server that I can bring up and mount the other partitions.
Normally, only one partition is booted to at a time. Post-secondary VoIP lab
each student pair gets there own partition/PBX server to work on.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
