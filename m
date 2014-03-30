From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23732] ext4 timestamp range contains 68-year gaps
Date: Sun, 30 Mar 2014 13:47:11 +0000
Message-ID: <bug-23732-13602-yZVzAFB9iI@https.bugzilla.kernel.org/>
References: <bug-23732-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59372 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbaC3NrO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Mar 2014 09:47:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8F6052039C
	for <linux-ext4@vger.kernel.org>; Sun, 30 Mar 2014 13:47:12 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B2EA12037D
	for <linux-ext4@vger.kernel.org>; Sun, 30 Mar 2014 13:47:11 +0000 (UTC)
In-Reply-To: <bug-23732-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23732

Conrad Meyer <cse.cem@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |cse.cem@gmail.com

--- Comment #1 from Conrad Meyer <cse.cem@gmail.com> ---
Impressively, this bug is still present in v3.14-rc8.

$ touch -d 2038-01-31 test-123
$ sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
$ ls -ld test-123
drwxrwxr-x 2 cmeyer cmeyer 4096 Dec 25  1901 test-123

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
