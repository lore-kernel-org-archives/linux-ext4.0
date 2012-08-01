From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42895] jbd2 makes all system unresponsive
Date: Wed,  1 Aug 2012 02:45:22 +0000 (UTC)
Message-ID: <20120801024522.6138C11FC6C@bugzilla.kernel.org>
References: <bug-42895-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40954 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783Ab2HACp0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Jul 2012 22:45:26 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 677B5202AE
	for <linux-ext4@vger.kernel.org>; Wed,  1 Aug 2012 02:45:25 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 6647D2031E
	for <linux-ext4@vger.kernel.org>; Wed,  1 Aug 2012 02:45:22 +0000 (UTC)
In-Reply-To: <bug-42895-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42895


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |UNREPRODUCIBLE




--- Comment #23 from Theodore Tso <tytso@mit.edu>  2012-08-01 02:45:22 ---
I'm closing this bug since the original poster never replied beyond comment #3
with more information, and in the meantime, more people have chimed in with
other unrelated complaints.  Hopefully the ftrace recipe is helpful in some
people debugging userspace bugs.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
