From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12579] ext4 filesystem hang
Date: Thu, 12 Feb 2009 10:55:46 -0800 (PST)
Message-ID: <20090212185546.AA0CD108040@picon.linux-foundation.org>
References: <bug-12579-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756988AbZBLS4S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Feb 2009 13:56:18 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1CItlwd021221
	for <linux-ext4@vger.kernel.org>; Thu, 12 Feb 2009 10:55:48 -0800
In-Reply-To: <bug-12579-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12579





------- Comment #5 from sandeen@redhat.com  2009-02-12 10:55 -------
Yep.  the 2 patches Aneesh refers to are just hours hold, so they were fixes
after I originally saw the hang and worth testing, but they don't seem to help.

I'm still trying some bisection of the changes (unfortunately many intermediate
points seem nonfunctional) and may have finally found a spot; if this doesn't
yield results though it's time for another crash-course in writeback.  ;)

-Eric


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
