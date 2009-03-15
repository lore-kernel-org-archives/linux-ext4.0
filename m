From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12821] filesystem corrupts on heavy I/O
Date: Sat, 14 Mar 2009 22:23:08 -0700 (PDT)
Message-ID: <20090315052309.10003108042@picon.linux-foundation.org>
References: <bug-12821-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750807AbZCOFYR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Mar 2009 01:24:17 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2F5N9kT007127
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2009 22:23:45 -0700
In-Reply-To: <bug-12821-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12821





------- Comment #17 from sandeen@redhat.com  2009-03-14 22:23 -------
(In reply to comment #16)

> # debugfs output:
> debugfs 1.41.4 (27-Jan-2009)
> debugfs:  stat 2491101
> 2491101: File not found by ext2_lookup 

Just FWIW, what you want is:

debugfs:  stat <2491101>

to get that inode.

Thanks,
-Eric


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
