From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12370] kernel BUG at fs/jbd2/journal.c:1108
Date: Tue, 13 Jan 2009 11:22:15 -0800 (PST)
Message-ID: <20090113192215.EAB6510800F@picon.linux-foundation.org>
References: <bug-12370-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564AbZAMTWp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Jan 2009 14:22:45 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0DJMFKZ020225
	for <linux-ext4@vger.kernel.org>; Tue, 13 Jan 2009 11:22:17 -0800
In-Reply-To: <bug-12370-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12370


jack@suse.cz changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|fs_ext4@kernel-bugs.osdl.org|jack@suse.cz
             Status|NEW                         |ASSIGNED




------- Comment #5 from jack@suse.cz  2009-01-13 11:22 -------
David, could you please check whether the patch fixes the issue for you?
Thanks.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
You are the assignee for the bug, or are watching the assignee.
