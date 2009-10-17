From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sat, 17 Oct 2009 15:23:22 GMT
Message-ID: <200910171523.n9HFNMqn028738@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56492 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbZJQPXR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 Oct 2009 11:23:17 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9HFNMbN028739
	for <linux-ext4@vger.kernel.org>; Sat, 17 Oct 2009 15:23:22 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #82 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-17 15:23:20 ---
I double checking it now, but is seems to be this patch:

commit 91ac6f43317c0bf99969665f98016548011dfa38
Author: Frank Mayhar <fmayhar@google.com>
Date:   Wed Sep 9 22:33:47 2009 -0400

    ext4: Make non-journal fsync work properly

    Teach ext4_write_inode() and ext4_do_update_inode() about non-journal
    mode:  If we're not using a journal, ext4_write_inode() now calls
    ext4_do_update_inode() (after getting the iloc via ext4_get_inode_loc())
    with a new "do_sync" parameter.  If that parameter is nonzero _and_ we're
    not using a journal, ext4_do_update_inode() calls sync_dirty_buffer()
    instead of ext4_handle_dirty_metadata().

    This problem was found in power-fail testing, checking the amount of
    loss of files and blocks after a power failure when using fsync() and
    when not using fsync().  It turned out that using fsync() was actually
    worse than not doing so, possibly because it increased the likelihood
    that the inodes would remain unflushed and would therefore be lost at
    the power failure.

    Signed-off-by: Frank Mayhar <fmayhar@google.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
