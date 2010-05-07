From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15906] performance regression in "umount" of filesystems using
 barriers
Date: Fri, 7 May 2010 09:47:17 GMT
Message-ID: <201005070947.o479lHcD017128@demeter.kernel.org>
References: <bug-15906-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57566 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab0EGJrZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 May 2010 05:47:25 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o479lKpb017141
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 7 May 2010 09:47:20 GMT
In-Reply-To: <bug-15906-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15906





--- Comment #20 from Dmitry Monakhov <dmonakhov@openvz.org>  2010-05-07 09:45:32 ---
I can confirm that Jens's fix the original regression for me,
so IMHO first part well done.

About second one.
(In reply to comment #13)
> A delalloc option. In fact dirty inode is still dirty even after first
> call of writeback_single_inode which is called from __sync_filesystem(0)
> due to delalloc allocation happen during inode write. So it takes second
> __sync_filesystem call to clear dirty flags. Currently i'm working on that
> issue. I hope i'll post a solution today.

Proposed patch was posted may be found here: 
http://marc.info/?l=linux-fsdevel&m=127322500915287&w=2

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
