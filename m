From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47731] Null pointer dereference at strchr
Date: Mon, 24 Sep 2012 03:01:05 +0000 (UTC)
Message-ID: <20120924030105.F10EA11FB49@bugzilla.kernel.org>
References: <bug-47731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:42187 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754651Ab2IXDBK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Sep 2012 23:01:10 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 03F73202DD
	for <linux-ext4@vger.kernel.org>; Mon, 24 Sep 2012 03:01:09 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 044CA202DA
	for <linux-ext4@vger.kernel.org>; Mon, 24 Sep 2012 03:01:06 +0000 (UTC)
In-Reply-To: <bug-47731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47731


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX




--- Comment #5 from Theodore Tso <tytso@mit.edu>  2012-09-24 03:01:05 ---
Herton Ronaldo Krzesinski has submitted a fix to this problem.

http://patchwork.ozlabs.org/patch/186011/

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
