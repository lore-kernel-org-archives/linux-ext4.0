From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43023] Bad page map in process plugin-containe
Date: Mon, 2 Apr 2012 18:54:29 GMT
Message-ID: <201204021854.q32IsTms027453@bugzilla.kernel.org>
References: <bug-43023-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:37144 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab2DBSya (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Apr 2012 14:54:30 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q32IsTrR027454
	for <linux-ext4@vger.kernel.org>; Mon, 2 Apr 2012 18:54:29 GMT
In-Reply-To: <bug-43023-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43023


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu
          Component|ext4                        |Other
         AssignedTo|fs_ext4@kernel-bugs.osdl.or |akpm@linux-foundation.org
                   |g                           |
            Product|File System                 |Memory Management




--- Comment #1 from Theodore Tso <tytso@mit.edu>  2012-04-02 18:54:27 ---
This looks like a VM problem (a corrupted page table entry), not an ext4 file
system issue.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
