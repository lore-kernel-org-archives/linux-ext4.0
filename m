From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11960] Oops in ext4_mb_poll_new_transaction
Date: Wed,  5 Nov 2008 16:12:24 -0800 (PST)
Message-ID: <20081106001224.82BA811D107@picon.linux-foundation.org>
References: <bug-11960-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751762AbYKFAM5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Nov 2008 19:12:57 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA60COG7022557
	for <linux-ext4@vger.kernel.org>; Wed, 5 Nov 2008 16:12:25 -0800
In-Reply-To: <bug-11960-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=11960





------- Comment #3 from tytso@mit.edu  2008-11-05 16:12 -------
OK, if you had a 128megs journal, it must have been a corrupted orphan list
and/or journal that caused the crash.  That's consistent with the I'd really
like to be able to create a reproduction case for this, since otherwise we
won't know if the problem has been fixed in the newer mainline kernel.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
