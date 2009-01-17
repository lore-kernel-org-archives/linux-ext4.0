From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12375] ext4_block_to_path block too big cause cpu to burn
Date: Sat, 17 Jan 2009 15:44:48 -0800 (PST)
Message-ID: <20090117234448.C5CA710800F@picon.linux-foundation.org>
References: <bug-12375-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753463AbZAQXpT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Jan 2009 18:45:19 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0HNim6i011420
	for <linux-ext4@vger.kernel.org>; Sat, 17 Jan 2009 15:44:49 -0800
In-Reply-To: <bug-12375-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12375


tytso@mit.edu changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|fs_ext4@kernel-bugs.osdl.org|tytso@mit.edu
             Status|NEW                         |ASSIGNED




------- Comment #3 from tytso@mit.edu  2009-01-17 15:44 -------
Created an attachment (id=19872)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=19872&action=view)
Patch to address this bug

This patch should address this bug.  Thanks for reporting it!


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
You are the assignee for the bug, or are watching the assignee.
