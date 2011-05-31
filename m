From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 36172] "kernel BUG at fs/ext4/super.c" triggered after
 tune2fs/remount
Date: Tue, 31 May 2011 19:07:03 GMT
Message-ID: <201105311907.p4VJ73O4025668@demeter1.kernel.org>
References: <bug-36172-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:36177 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab1EaTHD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 May 2011 15:07:03 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p4VJ73RS025669
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 31 May 2011 19:07:03 GMT
In-Reply-To: <bug-36172-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=36172


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz




--- Comment #2 from Jan Kara <jack@suse.cz>  2011-05-31 19:07:00 ---
Sorry, the fix is wrong. The problem is that we set EXT4_SB(sb)->s_journal in
ext4_fill_super() but we don't change it appropriately in ext4_remount() when
journal feature could have changed. I'm actually not sure if this is even
supposed to work - whether it isn't bug in tune2fs that it allows changing of
has_journal feature on mounted filesystem. Because when tune2fs removes the
feature and possibly other journal parameters from superblock, we really have
not any guarantee that the journal is still correct. In fact the journal space
could have been already reused for something else. So fixing this would need
some careful look... Ted?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
