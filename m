From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sun, 8 Nov 2009 19:12:36 GMT
Message-ID: <200911081912.nA8JCaXW012400@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50817 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963AbZKHTMb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 8 Nov 2009 14:12:31 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA8JCaFw012401
	for <linux-ext4@vger.kernel.org>; Sun, 8 Nov 2009 19:12:36 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #182 from Theodore Tso <tytso@mit.edu>  2009-11-08 19:12:34 ---
On Fri, Nov 06, 2009 at 10:07:15PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> For ext4, one thing I would suggest is to simply always put the NUL at the 
> end of the name, even if the filesystem might not need it. Then 
> nd_terminate_link() will still write the NUL, but it won't change any data 
> (and thus no CRC's).

It's pretty simple to do this; in fact it's a one-line change in
ext4_symlink() in fs/ext4/inode.c:

        /* clear the extent format for fast symlink */
        EXT4_I(inode)->i_flags &= ~EXT4_EXTENTS_FL;
        inode->i_op = &ext4_fast_symlink_inode_operations;
-        memcpy((char *)&EXT4_I(inode)->i_data, symname, l);
+        strcpy((char *)&EXT4_I(inode)->i_data, symname);
        inode->i_size = l-1;

                    - Ted

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
