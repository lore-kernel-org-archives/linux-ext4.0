From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12821] filesystem corrupts on heavy I/O
Date: Thu,  5 Mar 2009 10:06:21 -0800 (PST)
Message-ID: <20090305180621.CC69F108042@picon.linux-foundation.org>
References: <bug-12821-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754775AbZCESGx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Mar 2009 13:06:53 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n25I6MfG011992
	for <linux-ext4@vger.kernel.org>; Thu, 5 Mar 2009 10:06:23 -0800
In-Reply-To: <bug-12821-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12821





------- Comment #3 from sandeen@redhat.com  2009-03-05 10:06 -------
I am thinking that the header check in search_right, in the loop, is still
backwards but i'm in the middle of leaving on a road trip so may be thinking
about it ... backwards.  If others don't pick this up I'll look more tomorrow.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
