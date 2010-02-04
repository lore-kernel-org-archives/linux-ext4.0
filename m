From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Thu, 4 Feb 2010 04:16:44 GMT
Message-ID: <201002040416.o144GiW0015911@demeter.kernel.org>
References: <bug-14830-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44194 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756497Ab0BDEQp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Feb 2010 23:16:45 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o144GjIE015913
	for <linux-ext4@vger.kernel.org>; Thu, 4 Feb 2010 04:16:45 GMT
In-Reply-To: <bug-14830-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14830





--- Comment #17 from Michael Godfrey <godfrey@isl.stanford.edu>  2010-02-04 04:16:40 ---
I have now set deadline for all tests, and I had
a chance to try a system just like the one I have been
using, but with an 8.1T ext4 partition instead of the
11T partition before.

I used the same load:  rsync  /aaa /bbb, where /aaa was
NFS-mounted.
The behavior was quite similar, but the longest sync
time was about 4 minutes.

This suggests that the size of the filesystem is an
important factor.  Increasing the filesystem size by 36%
more than doubled the sync time.

Th size of the database in the 2 systems was somewhat larger
in the 11T system, but part of that was unused in the transfer.

Michael

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
