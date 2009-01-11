From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12430] different oops & panic on accessing an intentionally corrupted ext4 fs image
Date: Sun, 11 Jan 2009 08:24:52 -0800 (PST)
Message-ID: <20090111162452.7307D10800F@picon.linux-foundation.org>
References: <bug-12430-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752339AbZAKQZU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Jan 2009 11:25:20 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0BGOqfD004430
	for <linux-ext4@vger.kernel.org>; Sun, 11 Jan 2009 08:24:53 -0800
In-Reply-To: <bug-12430-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12430





------- Comment #1 from sliedes@cc.hut.fi  2009-01-11 08:24 -------
Created an attachment (id=19744)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=19744&action=view)
Test case, corrupted ext4 filesystem, gzipped


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
