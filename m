From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Tue, 12 Jan 2010 20:12:44 GMT
Message-ID: <201001122012.o0CKCiOx001695@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33714 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab0ALUMp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jan 2010 15:12:45 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0CKCiOK001696
	for <linux-ext4@vger.kernel.org>; Tue, 12 Jan 2010 20:12:44 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #22 from Jan Kara <jack@suse.cz>  2010-01-12 20:12:39 ---
Hmm, strange. I've now downloaded eglibc 2.10.1 from the site you pointed to
and followed instructions there. Now I don't have any ld-linux hung processes
and everything seems to finish fine but still no luck in reproducing the
problem.

About finding which test is causing this: I suppose you could easily disable
tests from different directories and the when you find in which directory the
problematic test is, you could do a binary search on tests. But I understand
it's quite a bit of work...

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
