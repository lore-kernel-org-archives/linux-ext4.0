From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15018] ext4 backtraces out of nowhere
Date: Wed, 27 Jan 2010 11:51:48 GMT
Message-ID: <201001271151.o0RBpmrK025148@demeter.kernel.org>
References: <bug-15018-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41703 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab0A0Lvt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Jan 2010 06:51:49 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0RBpn71025149
	for <linux-ext4@vger.kernel.org>; Wed, 27 Jan 2010 11:51:49 GMT
In-Reply-To: <bug-15018-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15018





--- Comment #7 from Jan Kara <jack@suse.cz>  2010-01-27 11:51:47 ---
Aneesh, I agree that switching to non-delayed allocation does not guarantee a
success in block allocation. But flushing inode does not guarantee that either
(and IMHO does not bring us that much). The user might have other inodes which
have delayed-allocated writes still pending and overestimation of reserved
space on these inodes causes EDQUOT. So the ultimately correct way would be to
flush all user's inodes but I'm not sure we want to do that from
ext4_da_write_begin and it wouldn't be an easy thing to do. A middle ground
might be to call writeback_inodes_sb_if_idle (similarly as we do that from
ext4_nonda_switch) when we hit EDQUOT but I'm not too satisfied with that
either...

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
