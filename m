From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12430] different oops & panic on accessing an intentionally corrupted ext4 fs image
Date: Sat, 17 Jan 2009 15:17:23 -0800 (PST)
Message-ID: <20090117231723.2BBD010800D@picon.linux-foundation.org>
References: <bug-12430-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753412AbZAQXR2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Jan 2009 18:17:28 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0HNHNBo009237
	for <linux-ext4@vger.kernel.org>; Sat, 17 Jan 2009 15:17:24 -0800
In-Reply-To: <bug-12430-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12430


tytso@mit.edu changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|fs_ext4@kernel-bugs.osdl.org|tytso@mit.edu
             Status|NEW                         |ASSIGNED




------- Comment #2 from tytso@mit.edu  2009-01-17 15:17 -------
Created an attachment (id=19869)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=19869&action=view)
Patch to address this bug

This patch should fix this problem for ext4.  It is queued to be pushed to
Linus when he gets back from LCA.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
You are the assignee for the bug, or are watching the assignee.
