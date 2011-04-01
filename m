From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32482] "htree_dirblock_to_tree:586: inode 260099: block
 1056737" message after every boot
Date: Fri, 1 Apr 2011 23:24:12 GMT
Message-ID: <201104012324.p31NOChK001774@demeter2.kernel.org>
References: <bug-32482-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:50933 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab1DAXYN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Apr 2011 19:24:13 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p31NOCgE001846
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 1 Apr 2011 23:24:12 GMT
In-Reply-To: <bug-32482-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32482


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #5 from Eric Sandeen <sandeen@redhat.com>  2011-04-01 23:24:10 ---
ext4 now has the helpful feature of reminding you about errors it encountered
in the past, and doing so on a regular basis.

Isn't that a helpful message?  ;)  I think it gets truncated.

I think it came out of:
584                 if (ext4_check_dir_entry(dir, NULL, de, bh,
585                                 (block<<EXT4_BLOCK_SIZE_BITS(dir->i_sb))
586                                          + ((char *)de - bh->b_data))) {


have you tried running e2fsck -f on the filesystem?  Looks like you have a
problem in a directory.

-Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
