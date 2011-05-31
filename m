From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 36262] ext3 umount: BUG: unable to handle kernel paging request
Date: Tue, 31 May 2011 18:21:33 GMT
Message-ID: <201105311821.p4VILXip001879@demeter1.kernel.org>
References: <bug-36262-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:55288 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab1EaSVf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 May 2011 14:21:35 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p4VILYQ4001880
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 31 May 2011 18:21:34 GMT
In-Reply-To: <bug-36262-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=36262


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz, tj@kernel.org




--- Comment #1 from Jan Kara <jack@suse.cz>  2011-05-31 18:21:28 ---
Can you post here output of disassemble of __percpu_counter_add? You can get
that by running gdb on vmlinux and then doing 'disass __percpu_counter_add'.
Thanks.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
