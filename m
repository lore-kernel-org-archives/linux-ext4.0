From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12790] kernel build warning causes EXT4 boot warning
Date: Sat, 28 Feb 2009 06:12:56 -0800 (PST)
Message-ID: <20090228141256.C680C11D107@picon.linux-foundation.org>
References: <bug-12790-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751592AbZB1ON3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Feb 2009 09:13:29 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1SECvK4006787
	for <linux-ext4@vger.kernel.org>; Sat, 28 Feb 2009 06:12:58 -0800
In-Reply-To: <bug-12790-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12790





------- Comment #2 from tytso@mit.edu  2009-02-28 06:12 -------
The two are unrelated.  The boot-time warning is because you are using the ext4
filesystem driver on a file system that does not have extents.  This is
harmless unless it's not what you wanted to do.  This might be because you have
ext4 built into a system where you have an ext2 root file system, or because
you explicitly asked for the filesystem to be mounted with ext4 even though it
doesn't have the extents feature enabled.

The build warning is harmless, and is fixed in 2.6.29 when we make ext4_group_t
be an unsigned int --- it has no need to be an unsigned long.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
