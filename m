From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15025] Oops in ext4 driver
Date: Wed, 27 Jan 2010 19:35:11 GMT
Message-ID: <201001271935.o0RJZB43002094@demeter.kernel.org>
References: <bug-15025-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41985 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab0A0TfM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Jan 2010 14:35:12 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0RJZBgx002095
	for <linux-ext4@vger.kernel.org>; Wed, 27 Jan 2010 19:35:11 GMT
In-Reply-To: <bug-15025-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15025


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #4 from Theodore Tso <tytso@mit.edu>  2010-01-27 19:35:09 ---
Hi Steiner,

Sorry for not getting back to you right away; I've been doing a huge amount of
travel right during January.   Can you tell me something about the file system
workload on your machine?  What does it do?  NFS, rsync server, backups, ...?  
And do you know what it might be doing right before it crashed?   How easily
can you reproduce this?  I take it since you had to stop using 2.6.33-rcX you
could reproduce it easily?

If you are willing to try a 2.6.33-rcX kernel, I'd suggest seeing if "echo 0 >
/sys/fs/ext4/<dev>/max_writeback_mb_bump" makes the crashes go away.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
