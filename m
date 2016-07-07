From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 121371] fsck created undeletable directory
Date: Thu, 07 Jul 2016 17:13:53 +0000
Message-ID: <bug-121371-13602-avOJcJx0B8@https.bugzilla.kernel.org/>
References: <bug-121371-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45114 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbcGGRUN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Jul 2016 13:20:13 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6047F20165
	for <linux-ext4@vger.kernel.org>; Thu,  7 Jul 2016 17:13:55 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id BD1CC20145
	for <linux-ext4@vger.kernel.org>; Thu,  7 Jul 2016 17:13:53 +0000 (UTC)
In-Reply-To: <bug-121371-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=121371

Navin <navinp1912@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |navinp1912@gmail.com

--- Comment #6 from Navin <navinp1912@gmail.com> ---
Grief , your inode or directory content is empty. It is corrupted also. I got
this after fixing your #1589030 with debugfs and changing fields 
directory permissions, flags to 0x1000 from your invalid value and also
changing the modify time stamp to current value from 2032.

I think this is a case where your inode field values has been corrupted or
overwritten due to some error/failure accidently. Fixing that or opening in
debugfs write mode solves the problem.  

Please close this as it doesn't seem to be related to ext4 . If you can
reproduce this using a test case from standard utilities or other ways
accessing API's please submit the test case/code. You could go ahead and
dd/write a byte that changes some struct field in the ext4 and when broken.iso
is loaded it displays errors for one/few inodes. Unless done properly with
valid values , it is not supported i guess.



./1/plexus-component-annotations-1.5.5.jar.sha1:
total 8
drw-rw--w- 2 47469 268482890 4096 Nov 13  2014 .
drwxrwxr-x 3 47433     47433 4096 Jan 13 17:02 ..

./2:
total 12
drwxrwxrwx 3 root root 4096 Jul  7 22:31 .
drwxr-xr-x 5 root root 4096 Jul  3 20:21 ..
drwxrwxrwx 2 root root 4096 Jul  7 21:48 #1589030

./2/#1589030:
total 8
drwxrwxrwx 2 root root 4096 Jul  7 21:48 .
drwxrwxrwx 3 root root 4096 Jul  7 22:31 ..

./lost+found:
total 8
drwx------ 2 root root 4096 Jul  7 20:44 .
drwxr-xr-x 5 root root 4096 Jul  3 20:21 ..

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
