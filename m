From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 114821] Frequent and recurring ext4 "bad header invalid magic"
 errors on a healthy drive
Date: Fri, 18 Mar 2016 22:46:27 +0000
Message-ID: <bug-114821-13602-FxR3eMioNZ@https.bugzilla.kernel.org/>
References: <bug-114821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:32950 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbcCRWqa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Mar 2016 18:46:30 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5CE552039C
	for <linux-ext4@vger.kernel.org>; Fri, 18 Mar 2016 22:46:29 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id D25EF20390
	for <linux-ext4@vger.kernel.org>; Fri, 18 Mar 2016 22:46:27 +0000 (UTC)
In-Reply-To: <bug-114821-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=114821

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #5 from Theodore Tso <tytso@mit.edu> ---
No file system activity should be causing a head load cycle in the absence of a
hardware problem.

Any chance you can try copying the file system image to another external usb
drive, run e2fsck on the copied file system image, and then try using the
copied file systme image on the new usb drive?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
