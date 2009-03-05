From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12821] filesystem corrupts on heavy I/O
Date: Thu,  5 Mar 2009 11:25:53 -0800 (PST)
Message-ID: <20090305192553.C659E108041@picon.linux-foundation.org>
References: <bug-12821-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753921AbZCETZ5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Mar 2009 14:25:57 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n25JPsNf018105
	for <linux-ext4@vger.kernel.org>; Thu, 5 Mar 2009 11:25:55 -0800
In-Reply-To: <bug-12821-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12821





------- Comment #7 from ddi@dubex.dk  2009-03-05 11:25 -------
> If it's what I think it is, it's not an anomaly;

(By "anomaly" I just meant that I have no clue whether "fsck died with exit
status 1" means "all OK" or "something bad happened".  The console message
doesn't really say anything about whether fsck exit code 1 is a good, bad or
neutral thing.  Just sort of states the fact, heh.)

> e2fsck 1.41.3 had a bug which would cause it to ... bail out with an exit(1).

Got it.  No, I didn't try a forced fsck (didn't know it would be different from
an automated one), but I'll re-mount ro and do just that when e2image is
finished!

If it still breaks, I'll upgrade e2progs as suggested?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
