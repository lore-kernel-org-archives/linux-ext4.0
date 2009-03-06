From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12821] filesystem corrupts on heavy I/O
Date: Thu,  5 Mar 2009 23:16:07 -0800 (PST)
Message-ID: <20090306071607.BA5E4108042@picon.linux-foundation.org>
References: <bug-12821-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226AbZCFHQO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Mar 2009 02:16:14 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n267G8mP030742
	for <linux-ext4@vger.kernel.org>; Thu, 5 Mar 2009 23:16:09 -0800
In-Reply-To: <bug-12821-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12821





------- Comment #9 from tytso@mit.edu  2009-03-05 23:16 -------
Well, the first thing I would do before doing anything else is upgrade to
e2fsprogs 1.41.4, and then run '"script -c "e2fsck -fv /dev/sdb1" e2fsck.log',
and upload the e2fsck.log file to bugzilla.  Then see if the problem goes away.
  The fact that e2fsck exited with a status code one of 1 causes me to suspect
that you really did have an inconsistent filesystem, and it's not the problem
which Eric is chasing.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
