From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12429] "BUG: spinlock cpu recursion on CPU#0, rm/699" on intentionally corrupted ext4 fs
Date: Sun, 18 Jan 2009 11:36:30 -0800 (PST)
Message-ID: <20090118193630.26493108041@picon.linux-foundation.org>
References: <bug-12429-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753574AbZARThD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Jan 2009 14:37:03 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0IJaUsP025898
	for <linux-ext4@vger.kernel.org>; Sun, 18 Jan 2009 11:36:31 -0800
In-Reply-To: <bug-12429-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12429


tytso@mit.edu changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |CLOSED




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
