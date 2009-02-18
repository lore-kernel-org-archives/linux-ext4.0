From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12689] kernel oops fs/jbd/checkpoint.c:164 __log_wait_for_space
Date: Wed, 18 Feb 2009 09:37:15 -0800 (PST)
Message-ID: <20090218173715.C915310803F@picon.linux-foundation.org>
References: <bug-12689-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753276AbZBRRhr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Feb 2009 12:37:47 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1IHbGtx008326
	for <linux-ext4@vger.kernel.org>; Wed, 18 Feb 2009 09:37:17 -0800
In-Reply-To: <bug-12689-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12689





------- Comment #2 from jack@suse.cz  2009-02-18 09:37 -------
Can you post somewhere the filesystem image you use? From your comment I
suppose it's corrupted or something like that.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
