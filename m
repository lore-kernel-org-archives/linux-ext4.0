From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12579] ext4 filesystem hang
Date: Fri, 13 Feb 2009 14:06:06 -0800 (PST)
Message-ID: <20090213220606.AE8FC11D109@picon.linux-foundation.org>
References: <bug-12579-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753326AbZBMWGh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Feb 2009 17:06:37 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1DM66C3027345
	for <linux-ext4@vger.kernel.org>; Fri, 13 Feb 2009 14:06:07 -0800
In-Reply-To: <bug-12579-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12579





------- Comment #8 from sandeen@redhat.com  2009-02-13 14:06 -------
Created an attachment (id=20238)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=20238&action=view)
Tested patch

Patch from Aneesh, un-whitespace-mangled.

Ted, can you push this out?  Works great.  :)  We might want to ask the other
reporter of something similar (next-20090206: deadlock on ext4) to test it too.
 I'll ping him.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
