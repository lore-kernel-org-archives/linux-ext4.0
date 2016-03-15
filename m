From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 114621] /etc/fstab: impossible to disable relatime
Date: Tue, 15 Mar 2016 15:21:05 +0000
Message-ID: <bug-114621-13602-FuWa5oM2kY@https.bugzilla.kernel.org/>
References: <bug-114621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34173 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbcCOPVJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Mar 2016 11:21:09 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BACEF202FE
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2016 15:21:07 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 561D1202E5
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2016 15:21:05 +0000 (UTC)
In-Reply-To: <bug-114621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=114621

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |tytso@mit.edu
         Resolution|---                         |INVALID

--- Comment #1 from Theodore Tso <tytso@mit.edu> ---
These errors have nothing to do with relatime.  

You can control whether the last access time is updated on every single read
(which is a performance disaster, but required by POSIX) using the mount option
strictatime.  You can also set the last access time to never be updated using
the mount option noatime.   The default, relatime will update atime if it is
more than 24 hours out of date, or if atime < mtime. 

None of this has anything to do with the NCQ error, which is coming from the
device, and not the file system.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
