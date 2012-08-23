From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 46361] ext4 partition mount takes long time with 3.5.1+ kernel
Date: Thu, 23 Aug 2012 19:16:43 +0000 (UTC)
Message-ID: <20120823191643.BFE0411FC6C@bugzilla.kernel.org>
References: <bug-46361-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58501 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab2HWTQt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Aug 2012 15:16:49 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BBAD020515
	for <linux-ext4@vger.kernel.org>; Thu, 23 Aug 2012 19:16:46 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id C3A1820563
	for <linux-ext4@vger.kernel.org>; Thu, 23 Aug 2012 19:16:43 +0000 (UTC)
In-Reply-To: <bug-46361-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=46361


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |tytso@mit.edu
         Resolution|                            |CODE_FIX




--- Comment #6 from Theodore Tso <tytso@mit.edu>  2012-08-23 19:16:43 ---
This was fixed in commit 0548bbb85337e532ca2ed697c3e9b227ff2ed4b4 which hit
mainline in v3.6-rc3.  It will hopefully be in the next stable release, v3.5.3,
but that hasn't been released yet.

Please try cherry-picking that fix, and let me know if that doesn't fix it.  If
it doesn't, we can reopen this bug and I'll take a closer look.  But I'm 99.9%
sure this should fix things for you.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
