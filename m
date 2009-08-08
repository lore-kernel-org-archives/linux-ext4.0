From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13930] non-contiguous files (64.9%) on a ext4 fs
Date: Sat, 8 Aug 2009 01:30:25 GMT
Message-ID: <200908080130.n781UPPx014934@demeter.kernel.org>
References: <bug-13930-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55876 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbZHHBaZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Aug 2009 21:30:25 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n781UQgJ014935
	for <linux-ext4@vger.kernel.org>; Sat, 8 Aug 2009 01:30:26 GMT
In-Reply-To: <bug-13930-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13930





--- Comment #4 from Theodore Tso <tytso@mit.edu>  2009-08-08 01:30:24 ---
There are so many extents because as discussed in the linux-ext4 mailing list
thread I referenced above, when you write multiple large files close together
in time, the large files get interleaved with each other.   

"cp -R /cifs /ext4" doesn't call fsync() between writing each file, so the
dirty pages for multiple files are left dirty in the page cache during the
copy.   The VM page flush daemon doesn't write one file out completely, and
then another, but instead round-robins between different inodes.   The ext4
delayed allocation code tries to work around this by trying to find adjacent
dirty pages and then trying to do a large block allocation; but currently the
ext4 multiblock allocator only tries to grab up to 8 megabytes at a time, to
avoid spending too much CPU time in what might be a fruitless attempt to find
that many contiguous free blocks.

It's a known bug, but fixing is a bit complicated.  It's on our TODO list.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
