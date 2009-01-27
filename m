From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12551] end_request: I/O error, dev cciss/c0d0, sector 87435720
Date: Tue, 27 Jan 2009 07:42:47 -0800 (PST)
Message-ID: <20090127154247.F033A108040@picon.linux-foundation.org>
References: <bug-12551-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328AbZA0PnJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2009 10:43:09 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0RFgmrL020097
	for <linux-ext4@vger.kernel.org>; Tue, 27 Jan 2009 07:42:49 -0800
In-Reply-To: <bug-12551-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12551


tytso@mit.edu changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mike.miller@hp.com




------- Comment #2 from tytso@mit.edu  2009-01-27 07:42 -------
Looks like the cciss driver is returning an error when we try to do a write
with barriers enabled.   If we get a failure return from the device driver, we
fall back to writing the commit block w/o barriers, and that is apparently
succeeding.   So this looks like a cciss issue.

I've added Mike Miller, the maintainer of the cciss driver, to the cc list. 
Mike, does this ring any bells; has there been any changes between 2.6.28.1 and
2.6.29-rc2-git3 that might account for this?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
