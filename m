From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111891] access to file does not change access time to folders
 above up to /(root)
Date: Fri, 05 Feb 2016 02:38:19 +0000
Message-ID: <bug-111891-13602-EkLXGdG960@https.bugzilla.kernel.org/>
References: <bug-111891-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39999 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbcBECie (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Feb 2016 21:38:34 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C8CD120395
	for <linux-ext4@vger.kernel.org>; Fri,  5 Feb 2016 02:38:29 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 0E2F42038E
	for <linux-ext4@vger.kernel.org>; Fri,  5 Feb 2016 02:38:20 +0000 (UTC)
In-Reply-To: <bug-111891-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=111891

Andreas Dilger <adilger.kernelbugzilla@dilger.ca> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |adilger.kernelbugzilla@dilg
                   |                            |er.ca

--- Comment #1 from Andreas Dilger <adilger.kernelbugzilla@dilger.ca> ---
I'm not sure where you got the idea that the access time of all parent
directories should be changed, but that isn't how POSIX works. Only the access
time of the file will be modified, otherwise there would be a huge amount of
overhead (e.g. maybe dozens of disk writes) for every file access.

Also, most filesystems have no way of determining the parent directories for a
given file, and there may be multiple parent directories for a single file
(hard links), and it wouldn't make sense to update all of those directories, so
this is also impractical to implement for most filesystems.

People have enough problems with atime without making it even more expensive,
and relatime is already reducing the number of cases where atime is updated
significantly.

Seems I cannot close this bug (Ted, can you give me permission for this?), but
it should be closed as "not a bug".

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
