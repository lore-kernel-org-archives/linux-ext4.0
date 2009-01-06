From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12370] kernel BUG at fs/jbd2/journal.c:1108
Date: Tue,  6 Jan 2009 07:11:16 -0800 (PST)
Message-ID: <20090106151116.E123810800F@picon.linux-foundation.org>
References: <bug-12370-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750796AbZAFPLt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jan 2009 10:11:49 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n06FBH8h005747
	for <linux-ext4@vger.kernel.org>; Tue, 6 Jan 2009 07:11:18 -0800
In-Reply-To: <bug-12370-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12370





------- Comment #3 from jack@suse.cz  2009-01-06 07:11 -------
I'll attach a patch that fixes the problem for me.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
