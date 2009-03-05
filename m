From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12821] filesystem corrupts on heavy I/O
Date: Thu,  5 Mar 2009 11:06:00 -0800 (PST)
Message-ID: <20090305190600.BE6AD108042@picon.linux-foundation.org>
References: <bug-12821-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751756AbZCETGx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Mar 2009 14:06:53 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n25J61Mh016584
	for <linux-ext4@vger.kernel.org>; Thu, 5 Mar 2009 11:06:02 -0800
In-Reply-To: <bug-12821-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12821





------- Comment #6 from tytso@mit.edu  2009-03-05 11:06 -------
If it's what I think it is, it's not an anomaly; e2fsck 1.41.3 had a bug which
would cause it to not fix certain types of corruption in the extent tree, and
it would just bail out with an exit(1).   And the error messages that the
kernel printed are consistent with it.  Did you try re-running a forced fsck on
the filesystem after you got that failure?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
