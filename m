From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13964] ext4: panic causes lost data in git
Date: Sat, 29 Aug 2009 02:47:24 GMT
Message-ID: <200908290247.n7T2lO7t030695@demeter.kernel.org>
References: <bug-13964-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52393 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZH2CrW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Aug 2009 22:47:22 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7T2lOgi030696
	for <linux-ext4@vger.kernel.org>; Sat, 29 Aug 2009 02:47:24 GMT
In-Reply-To: <bug-13964-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13964


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #3 from Theodore Tso <tytso@mit.edu>  2009-08-29 02:47:23 ---
The alloc_on_commit patch had a number of deadlock problems, and I've never had
time to try to work them out.

For now, the recommended solution for git is to put the following in your
.gitconfig file:

[core]
         fsyncobjectfiles = yes

This will cause git to force an fsync() when writing object files, which is the
only portable way of guaranteeing the object files will be written after a
crash.  This is needed for safety reasons for ext4, xfs, and btrfs filesystems.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
