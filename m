From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Tue, 27 Oct 2009 23:38:42 GMT
Message-ID: <200910272338.n9RNcgGv014593@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42553 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832AbZJ0Xih (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Oct 2009 19:38:37 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9RNcgLp014594
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2009 23:38:42 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354


Andreas Dilger <adilger.kernelbugzilla@dilger.ca> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |adilger.kernelbugzilla@dilg
                   |                            |er.ca




--- Comment #137 from Andreas Dilger <adilger.kernelbugzilla@dilger.ca>  2009-10-27 23:38:40 ---
Alexey Fisher wrote:
> This attachment is about my previous test i use to get fs corruption (make
> install(3 times) && get oops && restart) with only one difference, to run fsck
> I use "-o ro,noload" to mount root. before i use "-o ro". Now i can see journal
> corruption wich was hidden by kernel before.

This is not a valid test.  Mounting with "-o noload" will discard all of the
transaction information in the journal, and virtually guarantee the filesystem
is inconsistent.  It will be no better than ext2, which requires a full e2fsck
run after each crash.  This is NOT a valid reproducer for this problem.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
