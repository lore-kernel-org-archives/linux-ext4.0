From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 114621] /etc/fstab: impossible to disable relatime
Date: Tue, 15 Mar 2016 21:39:13 +0000
Message-ID: <bug-114621-13602-Mu2iFydH2J@https.bugzilla.kernel.org/>
References: <bug-114621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58121 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbcCOVjQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Mar 2016 17:39:16 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6E5B320426
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2016 21:39:15 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 9652420412
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2016 21:39:13 +0000 (UTC)
In-Reply-To: <bug-114621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=114621

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|REOPENED                    |RESOLVED
         Resolution|---                         |INVALID

--- Comment #3 from Theodore Tso <tytso@mit.edu> ---
So number one this is a distro kernel, so I suggest you ask the SuSE help desk
for support.

Number 2, I suggest you give exact reproduction details --- e.g., what was in
your fstab before and after.   And then try reproducing this on an upstream
kernel if you want support on bugzilla.kernel.org.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
