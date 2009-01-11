From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12424] ext4_da_writepages error while downloading a file w/firefox
Date: Sat, 10 Jan 2009 20:02:20 -0800 (PST)
Message-ID: <20090111040220.9560210800E@picon.linux-foundation.org>
References: <bug-12424-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751474AbZAKECW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Jan 2009 23:02:22 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0B42Krp032689
	for <linux-ext4@vger.kernel.org>; Sat, 10 Jan 2009 20:02:21 -0800
In-Reply-To: <bug-12424-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12424





------- Comment #2 from sandeen@redhat.com  2009-01-10 20:02 -------
This is journal_start failing:

                /* start a new transaction*/
                handle = ext4_journal_start(inode, needed_blocks);
                if (IS_ERR(handle)) {
                        ret = PTR_ERR(handle);
                        printk(KERN_EMERG "%s: jbd2_start: "
                               "%ld pages, ino %lu; err %d\n", __func__,
                                wbc->nr_to_write, inode->i_ino, ret);
                        dump_stack();
                        goto out_writepages;
                }

with error -30, which is EROFS.

Were there other messages before this, maybe an errors=remount-readonly sort of
filesystem problem?  Did the filesystem go readonly?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
