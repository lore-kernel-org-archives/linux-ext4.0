From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Mon, 14 Dec 2009 14:46:10 GMT
Message-ID: <200912141446.nBEEkA53008036@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56744 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722AbZLNOqL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Dec 2009 09:46:11 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nBEEkAmh008037
	for <linux-ext4@vger.kernel.org>; Mon, 14 Dec 2009 14:46:10 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |axboe@kernel.dk




--- Comment #15 from Jan Kara <jack@suse.cz>  2009-12-14 14:46:07 ---
Thanks for the debugging. So the problematic files were regular files that lead
pretty simple life - no references from unexpected places or so. What catches
my eye is that inode numbers are surprisingly small (22, 12, 13; in your
original report 17, 15). Since normal inode numbers start by 11 and that is
usually taken by lost+found, numbers 12 and 13 are as small as they can get. I
suppose this is a filesystem dedicated for the build, isn't it? And the files
making problems are created as a first files on that filesystem in its root
directory. Any idea what those files are?

Another thing: i_count=2501 for inode 22 is absurdly high. We'd have to leak
references really heavily for that file.

I've checked the code in writeback_inodes_wb() and wait_sb_inodes() but
reference counting there looks fine. So I have no clue what's going on right
now. Anyway, adding Jens to CC just in case it rings a bell to him.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
