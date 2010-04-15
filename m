From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15792] ext4_inode_inode->i_flags modification is racy
Date: Thu, 15 Apr 2010 22:52:29 GMT
Message-ID: <201004152252.o3FMqTdl006732@demeter.kernel.org>
References: <bug-15792-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34326 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757064Ab0DOWwb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Apr 2010 18:52:31 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3FMqUsK006739
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 15 Apr 2010 22:52:30 GMT
In-Reply-To: <bug-15792-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15792





--- Comment #4 from Dmitry Monakhov <dmonakhov@openvz.org>  2010-04-15 22:52:22 ---
Most interesting part is last lines

[61] [2]   truncate clr s:737987 d:737987 b:104 fl:80000 
[62] [0]   clr ext4_inode_blocks_set b:104 fl:480000 bit:40000 
[63] [2]   trunc_ext begin s:737987 d:737987 b:104 fl:480000 ml:1 

I.E.
CPU2: is doing  EXT4_I(inode)->i_flags &= ~EXT4_EOFBLOCKS_FL
CPU0: is doung  ei->i_flags &= ~EXT4_HUGE_FILE_FL
CPU2: Wow  EXT4_EOFBLOCKS_FL appear again due to race with cpu0.
So even if truncate holds i_mutex it is possible to modify i_flags.
Seems that we have to modify i_flags via anomic bits operations.

A fix is almost ready. Currently i'm testing it.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
