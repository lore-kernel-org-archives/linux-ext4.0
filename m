From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 117421] e2fsprogs: mke2fs ignores sparse_super2 when also using
 extent or 64bit
Date: Tue, 10 May 2016 21:40:10 +0000
Message-ID: <bug-117421-13602-qa9F5eJljQ@https.bugzilla.kernel.org/>
References: <bug-117421-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48142 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbcEJVkN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 May 2016 17:40:13 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2946F2017D
	for <linux-ext4@vger.kernel.org>; Tue, 10 May 2016 21:40:12 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id C01D0201C7
	for <linux-ext4@vger.kernel.org>; Tue, 10 May 2016 21:40:10 +0000 (UTC)
In-Reply-To: <bug-117421-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=117421

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
      Comment #1 is|1                           |0
            private|                            |

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
