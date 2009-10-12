From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Mon, 12 Oct 2009 02:18:42 GMT
Message-ID: <200910120218.n9C2Ig49010735@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60988 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbZJLCTS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Oct 2009 22:19:18 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9C2Ig6g010739
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2009 02:18:42 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #18 from Theodore Tso <tytso@mit.edu>  2009-10-12 02:18:41 ---
Created an attachment (id=23353)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23353)
jbd2 debugging patch

The jbd2-checksum-debugging patch adds two options which can be added to the
boot line.   The first, jbd2.xsum_debug=1, will print two additional kernel
messages when replaying a journal that will help debug checksums.   The second,
jbd2.ignore_xsum=1, will cause jbd2 to ignore any checksum errors.

If you can come up with a repeatable test case, it would be useful to apply
this patch and then add "jbd2.xsum_debug=1 jbd2.ignore_xsum=1" to the boot
line.   Then let me know (a) if the problem goes away when you add the boot
command-line options, and (b) give me the dmesg output either way.

Thanks!

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
