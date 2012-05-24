From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43260] ftruncate locks up when used with direct IO on ext4
Date: Thu, 24 May 2012 10:16:57 +0000 (UTC)
Message-ID: <20120524101657.DE4DC11FD1A@bugzilla.kernel.org>
References: <bug-43260-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45132 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab2EXKRB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 May 2012 06:17:01 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0E3A420590
	for <linux-ext4@vger.kernel.org>; Thu, 24 May 2012 10:17:00 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id DF6E520584
	for <linux-ext4@vger.kernel.org>; Thu, 24 May 2012 10:16:57 +0000 (UTC)
In-Reply-To: <bug-43260-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43260


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz




--- Comment #3 from Jan Kara <jack@suse.cz>  2012-05-24 10:16:57 ---
Hum, I see. So we are holding i_mutex and waiting for dio to finish and worker
thread cannot take i_mutex to finish the extent conversion and call
inode_dio_done(). Slightly subtle is that the worker tries to be clever and if
it cannot acquire i_mutex, it requeues the work item so it does not really
deadlock the system, it just eats up CPU cycling the work over and over...

I'm uncertain how to best fix this. If we just revert 266991b13, we reintroduce
the problem of AIO DIO completion racing with truncate (so extent conversion
would happen on already freed blocks). But I'm thinking that with DIO vs
truncate protection in VFS, we probably don't need i_mutex for extent
conversion: The only think in ext4_end_io_nolock() that can possibly need
i_mutex is ext4_convert_unwritten_extents(). That function just starts a
transaction (i_mutex not needed) and calls ext4_map_blocks() which takes
i_data_sem for protection.

I'll let this brew in my head for a while and if I (or anyone else - hint,
hint) does not find a problem with this, I'll write a patch to remove the
lock...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
