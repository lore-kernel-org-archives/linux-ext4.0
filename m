From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Small change to the ext4 journal credits reservation patch
Date: Sat, 02 Aug 2008 01:34:52 -0400
Message-ID: <E1KP9lU-0002Ug-RL@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:41966 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751732AbYHBFey (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Aug 2008 01:34:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mingming,

FYI, I checked in a minor change to the ext4 journal credits reservation
patch into the ext4 patch queue.

I changed a printk in ext4_da_writepgaes() from:

                      printk(KERN_EMERG "%s: Not enough credits to flush %ld p
                              wbc->nr_to_write);

to this:

                      printk(KERN_EMERG "ext4_da_writepages: jbd2_start: "
                             "%ld pages, ino %d; err %d\n",
                             wbc->nr_to_write, inode->i_ino, ret)

As it turns out, the primary way this printk triggers is right after a
filesystem is remounted read-only.  My change provides a bit more useful
information.  

I'm not sure whether the read-only remount is failing to force changes
to disk, or the pages are erroneously left dirty; but this should help
us figure out exactly what is going on.  As I said earlier, I don't
think this is the fault of the journal credits patch, but it is exposing
this potential bug in a much more visible way.

						- Ted
