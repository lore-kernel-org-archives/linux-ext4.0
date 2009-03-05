From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12821] filesystem corrupts on heavy I/O
Date: Thu,  5 Mar 2009 10:59:20 -0800 (PST)
Message-ID: <20090305185920.E4A95108042@picon.linux-foundation.org>
References: <bug-12821-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754292AbZCES7x (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Mar 2009 13:59:53 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n25IxLkX016049
	for <linux-ext4@vger.kernel.org>; Thu, 5 Mar 2009 10:59:22 -0800
In-Reply-To: <bug-12821-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12821





------- Comment #5 from ddi@dubex.dk  2009-03-05 10:59 -------
@sandeen: Thanks a *lot*. Have a nice trip!

@tytso: Same to you, info much appreciated! (I was wondering if the fsck thing
was an anomaly or not.)

> Are you willing to try a newer kernel?
> This looks familiar and I think it's
> fixed in the latest 2.6.29-rc7 kernel.

I'd rather not since it's production stuff, but then again if you know what the
problem is, and a shiny new kernel is the cure, then yes.  I'll have to live on
the edge, bleeding. (or whatever it's called..)

FYI, e2image is coming up when it's done (running for about an hour now).


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
