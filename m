From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12543] ext4_da_writepages error in 2.6.28.1 after a disk error
Date: Tue, 27 Jan 2009 11:08:13 -0800 (PST)
Message-ID: <20090127190813.6E77B108040@picon.linux-foundation.org>
References: <bug-12543-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753665AbZA0TIr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2009 14:08:47 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0RJ8DwR009835
	for <linux-ext4@vger.kernel.org>; Tue, 27 Jan 2009 11:08:14 -0800
In-Reply-To: <bug-12543-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12543


tytso@mit.edu changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |CLOSED
         Resolution|                            |PATCH_ALREADY_AVAILABLE




------- Comment #3 from tytso@mit.edu  2009-01-27 11:08 -------
Having ext4 handling this gracefully is already in mainline.   See commit:

2a21e37e4: ext4: tone down ext4_da_writepages warnings


    ext4: tone down ext4_da_writepages warnings

    If the filesystem has errors, ext4_da_writepages() will return a *lot*
    of errors, including lots and lots of stack dumps.  While it's true
    that we are dropping user data on the floor, which is unfortunate, the
    stack dumps aren't helpful, and they tend to obscure the true original
    root cause of the problem.  So in the case where the filesystem has
    aborted, return an EROFS right away.

    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

It is in 2.6.29-rc1 and I plan to send it for the 2.6.28.y release, just
because it is *so* annoying.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
