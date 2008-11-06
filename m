From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11964] JBD: grub-probe wants too many credits (266 > 256)
Date: Thu,  6 Nov 2008 13:39:29 -0800 (PST)
Message-ID: <20081106213929.DE019108043@picon.linux-foundation.org>
References: <bug-11964-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751686AbYKFVjc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 16:39:32 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA6LdTf9008216
	for <linux-ext4@vger.kernel.org>; Thu, 6 Nov 2008 13:39:30 -0800
In-Reply-To: <bug-11964-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=11964


tytso@mit.edu changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|fs_ext4@kernel-bugs.osdl.org|tytso@mit.edu
             Status|NEW                         |ASSIGNED




------- Comment #1 from tytso@mit.edu  2008-11-06 13:39 -------
Patch to fix this problem here:

http://article.gmane.org/gmane.comp.file-systems.ext4/9947


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
You are the assignee for the bug, or are watching the assignee.
