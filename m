From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15018] ext4 backtraces out of nowhere
Date: Tue, 26 Jan 2010 23:19:23 GMT
Message-ID: <201001262319.o0QNJNp0024737@demeter.kernel.org>
References: <bug-15018-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34437 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab0AZXTY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jan 2010 18:19:24 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0QNJNuP024738
	for <linux-ext4@vger.kernel.org>; Tue, 26 Jan 2010 23:19:23 GMT
In-Reply-To: <bug-15018-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15018





--- Comment #4 from Jan Kara <jack@suse.cz>  2010-01-26 23:19:18 ---
Hmm, I don't like the code in ext4_da_reserve_space even after your patch - the
retries are duplicated with the ones from ext4_da_write_begin and calling
write_inode_now from ext4_da_write_begin doesn't make too much sense either -
why not write all inodes with delayed allocation if we want to write something?

Actually, instead of retrying delayed allocation, I think it makes more sense
to just fall back to normal allocation. Attached patch does that and it also
allows me to completely fill user's quota.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
