From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16583] ext4: delayed block allocation failed and application
 not respond any more
Date: Thu, 24 May 2012 13:13:00 +0000 (UTC)
Message-ID: <20120524131300.7E58611FD1B@bugzilla.kernel.org>
References: <bug-16583-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50371 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab2EXNND (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 May 2012 09:13:03 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2D293205AA
	for <linux-ext4@vger.kernel.org>; Thu, 24 May 2012 13:13:02 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 7FF9F205A7
	for <linux-ext4@vger.kernel.org>; Thu, 24 May 2012 13:13:00 +0000 (UTC)
In-Reply-To: <bug-16583-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16583


Loredan Stancu <salecss@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |salecss@gmail.com




--- Comment #1 from Loredan Stancu <salecss@gmail.com>  2012-05-24 13:13:00 ---
Hi guys,

Any new on this? I just had the same problem with the ext4 file system after
resizing it from a LVM.

I'm using RHEL 6.3, kernel 2.6.32-262.el6.x86_64.

What I did was to:

1. Umount the LVM partion
2. check it with fsck.ext4 tool (no errors reported)
3. resize the file system using resize2fs tool (no errors reported)
4. resize the LVM using lvresize tool (no error reported)
5. run fsck.ext4 for the resulted file system and no errors was reported.

I was able to mount the new file system but when trying to use db2 database
from that partition I received the following file system error and db2 instance
crashed suddenly:

EXT4-fs error (device dm-2): ext4_ext_search_left: inode #716: (comm db2sysc)
ix (3714852) != EXT_FIRST_INDEX

A fix for me was to create a new LVM and rsync all the files from bad
filesystem to the new one. And worked perfectly. A hadn't any problem to access
the files from the bad file system.

I this a well known problem? 

Regards,
Loredan

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
