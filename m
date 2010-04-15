From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15792] ext4_inode_inode->i_flags modification is racy
Date: Thu, 15 Apr 2010 22:31:58 GMT
Message-ID: <201004152231.o3FMVwAT001332@demeter.kernel.org>
References: <bug-15792-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36757 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523Ab0DOWcA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Apr 2010 18:32:00 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3FMVwXU001333
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 15 Apr 2010 22:31:58 GMT
In-Reply-To: <bug-15792-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15792





--- Comment #2 from Dmitry Monakhov <dmonakhov@openvz.org>  2010-04-15 22:31:55 ---
The oops happens because non tested branch was triggered.
./fs/ext4/extents.c
3477:    if (unlikely(EXT4_I(inode)->i_flags & EXT4_EOFBLOCKS_FL)) {
                if (unlikely(!eh->eh_entries)) {
                        EXT4_ERROR_INODE(inode,
                                         "eh->eh_entries == 0 ee_block %d",
                                         ex->ee_block);
### OOPS here because ex == NULL ^^^^^^^^^^^^^^^^^^^^^^^^
                        err = -EIO;
                        goto out2;
                }

Bug was introduced by following commit:
commit 273df556b6ee2065bfe96edab5888d3dc9b108d8
Author: Frank Mayhar <fmayhar@google.com>
Date:   Tue Mar 2 11:46:09 2010 -0500

And in fact it is rather trivial to fix.
But most interesting question what the hell we are doing on that error path?
inode has EXT4_EOFBLOCKS_FL flag enabled but eh->eh_entries, and in fact
after adding more debug information i've found that inode is simply blockless.
i_blocks == 0, i_size == 0.

I've collected per-inode i_flag modification history (see an attachment)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
