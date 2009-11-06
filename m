From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Fri, 6 Nov 2009 20:49:35 GMT
Message-ID: <200911062049.nA6KnZNI029393@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47366 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759392AbZKFUta (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Nov 2009 15:49:30 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA6KnZch029395
	for <linux-ext4@vger.kernel.org>; Fri, 6 Nov 2009 20:49:35 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #177 from Chris Mason <chris.mason@oracle.com>  2009-11-06 20:49:25 ---
Created an attachment (id=23685)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23685)
Horrible horrible debugging hack

I started reading this because I was afraid the writeback changes were broken,
but tracking down crc errors is really interesting as well.  I started with the
assumption someone was changing the buffer after we crc but before it hits
disk, which in ext4 terms means that someone is probably changing data that has
been sent to the log without properly diving into the jdb2
do_get_write_access()

Eric helped prove this is the case by testing a patch that always crcs and
writes a stable duplicate of the metadata buffer instead of the metadata buffer
itself (a one liner since the log code was already setup for this).

This attachment is a hack but the basic idea is to set the page for a buffer
head readonly before we crc the page, and then set it read/write again when
we're done with it.  It will only work when the pagesize and the blocksize are
the same.

It probably has some false positives lurking, but so far it has found a number
of places where ext4 is changing a buffer without properly calling into the
jdb2 do_get_write_access() func.

Eric hit a few easy ones:

ext4_statfs():
        /* why is statfs changing the super? */
        ext4_free_blocks_count_set(es, buf->f_bfree);

ext4_setxattr_set_handle()
                memset(raw_inode, 0, EXT4_SB(inode->i_sb)->s_inode_size);

But I hit a much harder case to fix.  ext4_symlink will log the data blocks
that hold the symlink name (well ext4_write_begin will log them).

ext4 uses the generic symlink read helpers, so when we read the link we dive
into page_getlink() which uses nd_terminate_link to stuff a NULL into the end
of the link's name.  Since the null goes directly into the page cache page and
the page was logged, we're changing things that could affect the log crcs.

I think a more generic and less hacky form of this patch would be a really good
thing...maybe it already exists and I just don't know about it yet ;)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
