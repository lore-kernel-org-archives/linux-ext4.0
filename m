From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12697] MAINLINE
Date: Thu, 12 Feb 2009 11:49:40 -0800 (PST)
Message-ID: <20090212194940.A4926108040@picon.linux-foundation.org>
References: <bug-12697-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896AbZBLTu3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Feb 2009 14:50:29 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1CJneiY025156
	for <linux-ext4@vger.kernel.org>; Thu, 12 Feb 2009 11:49:41 -0800
In-Reply-To: <bug-12697-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12697


sandeen@redhat.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|fs_ext4@kernel-bugs.osdl.org|sandeen@redhat.com
             Status|NEW                         |ASSIGNED




------- Comment #1 from sandeen@redhat.com  2009-02-12 11:49 -------
-30 is EROFS

I assume you've had some error that shut down the filesystem previously, can
you look?

This seems to ring a bell for me but can't remember for sure if it's fixed,
yet.

                /* start a new transaction*/
                handle = ext4_journal_start(inode, needed_blocks);
                if (IS_ERR(handle)) {
                        ret = PTR_ERR(handle);
                        printk(KERN_CRIT "%s: jbd2_start: "
                               "%ld pages, ino %lu; err %d\n", __func__,
                                wbc->nr_to_write, inode->i_ino, ret);
                        dump_stack();
                        goto out_writepages;
                }

we should maybe check for a shutdown fs here before we generate all these
messages.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
You are the assignee for the bug, or are watching the assignee.
