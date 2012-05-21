From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43260] ftruncate locks up when used with direct IO on ext4
Date: Mon, 21 May 2012 23:08:04 +0000 (UTC)
Message-ID: <20120521230804.CA44911FD11@bugzilla.kernel.org>
References: <bug-43260-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38710 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab2EUXIJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 May 2012 19:08:09 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9464B204D2
	for <linux-ext4@vger.kernel.org>; Mon, 21 May 2012 23:08:07 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id D45D4204C8
	for <linux-ext4@vger.kernel.org>; Mon, 21 May 2012 23:08:04 +0000 (UTC)
In-Reply-To: <bug-43260-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43260





--- Comment #2 from Ivan Tarasov <ivan@rethinkdb.com>  2012-05-21 23:08:04 ---
Created an attachment (id=73345)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=73345)
Output of SysRq-w at lock up

Eric,

You are correct that 3.2.10 does not exhibit the problem (both on
RedHat-patched and vanilla kernel versions). That means that the bug was fixed
between 8c0bec21 and v3.2.10 and then reappeared again between the v3.2.10 and
v3.2.14.

I repeated the bisect, this time between v3.2.10 and v3.2.14, and found this
commit which exhibited the problem again:

commit 8608fb78b2cbf9eb8794e592bf43a8b1884c5a85
Author: Jeff Moyer <jmoyer@redhat.com>
Date:   Mon Feb 20 17:59:24 2012 -0500

    ext4: fix race between unwritten extent conversion and truncate

    commit 266991b13890049ee1a6bb95b9817f06339ee3d7 upstream.

    The following comment in ext4_end_io_dio caught my attention:

        /* XXX: probably should move into the real I/O completion handler */
            inode_dio_done(inode);

    The truncate code takes i_mutex, then calls inode_dio_wait.  Because the
    ext4 code path above will end up dropping the mutex before it is
    reacquired by the worker thread that does the extent conversion, it
    seems to me that the truncate can happen out of order.  Jan Kara
    mentioned that this might result in error messages in the system logs,
    but that should be the extent of the "damage."

    The fix is pretty straight-forward: don't call inode_dio_done until the
    extent conversion is complete.

    Reviewed-by: Jan Kara <jack@suse.cz>
    Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

The output of sysrq-w during the lock up on this commit is attached.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
