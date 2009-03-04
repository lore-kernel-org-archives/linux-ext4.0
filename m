From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12815] JBD: barrier-based sync failed on dm-1:8 - disabling barriers  -- and then hang
Date: Wed,  4 Mar 2009 09:40:23 -0800 (PST)
Message-ID: <20090304174023.DA17311D10A@picon.linux-foundation.org>
References: <bug-12815-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753889AbZCDRlU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Mar 2009 12:41:20 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n24HeodB030137
	for <linux-ext4@vger.kernel.org>; Wed, 4 Mar 2009 09:40:51 -0800
In-Reply-To: <bug-12815-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12815





------- Comment #5 from joey@kitenet.net  2009-03-04 09:40 -------
> You should get it on each mount.  When else do you see it?

I do see the jbd message on each mount. But I also saw one 2.5 hours after
mount. But, probably a red herring.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
