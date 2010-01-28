From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Thu, 28 Jan 2010 17:55:55 GMT
Message-ID: <201001281755.o0SHttxZ002434@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40642 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab0A1Rz5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Jan 2010 12:55:57 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o0SHttnY002435
	for <linux-ext4@vger.kernel.org>; Thu, 28 Jan 2010 17:55:55 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #48 from Jan Kara <jack@suse.cz>  2010-01-28 17:55:53 ---
Thanks for debugging Carlos! Note, that in the 'bad' case, the files are
deleted... When there are still open but deleted files, we cannot remount the
filesystem read-only because that would make deleting the file at closing of
the last file descriptor impossible. So what you see is an expected behavior...

Mikael, will you take care of pushing your fix to vanilla kernel and possibly
also -stable releases? Thanks.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
