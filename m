From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 117421] e2fsprogs: mke2fs ignores sparse_super2 when also using
 extent or 64bit
Date: Tue, 10 May 2016 21:41:05 +0000
Message-ID: <bug-117421-13602-Uspc7w1bem@https.bugzilla.kernel.org/>
References: <bug-117421-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48207 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbcEJVlJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 May 2016 17:41:09 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DBE7B201E4
	for <linux-ext4@vger.kernel.org>; Tue, 10 May 2016 21:41:06 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 84314201C7
	for <linux-ext4@vger.kernel.org>; Tue, 10 May 2016 21:41:05 +0000 (UTC)
In-Reply-To: <bug-117421-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=117421

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #2 from Theodore Tso <tytso@mit.edu> ---
I've added a commit to e2fsprogs 1.43 (when it is released) so it will accept
multiple -O options, since other people will likely make the same mistake.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
