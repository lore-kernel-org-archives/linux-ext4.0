From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12371] oops in ext4_get_group_desc
Date: Tue,  6 Jan 2009 11:05:15 -0800 (PST)
Message-ID: <20090106190515.B89AE10800F@picon.linux-foundation.org>
References: <bug-12371-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751477AbZAFTFr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jan 2009 14:05:47 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n06J5F2L021345
	for <linux-ext4@vger.kernel.org>; Tue, 6 Jan 2009 11:05:16 -0800
In-Reply-To: <bug-12371-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12371


tytso@mit.edu changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |PATCH_ALREADY_AVAILABLE




------- Comment #3 from tytso@mit.edu  2009-01-06 11:05 -------
Thanks for reporting this.  A patch is already in the ext4 patch queue which
prevents this problem, and it will be pushed to Linus shortly:

ext4: Add sanity checks for the superblock before mounting the filesystem

With this patch applied, the mount will be refused and the kernel messages will
show:

EXT4-fs: groups count too large: 0 (block count 56857945295556608, first data
block 55808, blocks per group 16384)


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
