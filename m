From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11492] "BUG: held lock freed" on mounting intentionally corrupted ext4 fs
Date: Sat, 17 Jan 2009 15:21:52 -0800 (PST)
Message-ID: <20090117232152.5E2AD10800F@picon.linux-foundation.org>
References: <bug-11492-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760894AbZAQXWV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Jan 2009 18:22:21 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0HNLqvQ009686
	for <linux-ext4@vger.kernel.org>; Sat, 17 Jan 2009 15:21:53 -0800
In-Reply-To: <bug-11492-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=11492


tytso@mit.edu changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |CLOSED
         Resolution|                            |PATCH_ALREADY_AVAILABLE




------- Comment #2 from tytso@mit.edu  2009-01-17 15:21 -------
Yeah, I'm 99% sure this was fixed by the referenced patch, which is in
mainline.  I'm going to close this for now.  Can you reopen it if it turns out
to still be an issue.

(And yes, we've toned down ext4_da_writepages.)


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
