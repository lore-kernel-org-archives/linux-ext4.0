From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25352] resizing ext4 will corrupt filesystem
Date: Tue, 21 Dec 2010 04:26:14 GMT
Message-ID: <201012210426.oBL4QE82004734@demeter1.kernel.org>
References: <bug-25352-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:36606 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933461Ab0LUE0P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Dec 2010 23:26:15 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oBL4QE8F004735
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 21 Dec 2010 04:26:14 GMT
In-Reply-To: <bug-25352-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25352





--- Comment #4 from Kees Cook <kees@outflux.net>  2010-12-21 04:26:12 ---
Thanks for tracking it down! After a fsck, I'm still seeing fs corruption,
unfortunately:

[177266.375628] EXT4-fs error (device dm-1): htree_dirblock_to_tree:586: inode
#12255304: block 88074025: comm rm: bad entry in directory: rec_len is smaller
than minimal - offset=0(4096), inode=0, rec_len=0, name_len=0
[177266.375872] EXT4-fs error (device dm-1): htree_dirblock_to_tree:586: inode
#12255304: block 88074026: comm rm: bad entry in directory: rec_len is smaller
than minimal - offset=0(8192), inode=0, rec_len=0, name_len=0
[177266.376135] EXT4-fs error (device dm-1): empty_dir:1922: inode #12255304:
block 88074025: comm rm: bad entry in directory: rec_len is smaller than
minimal - offset=0(4096), inode=0, rec_len=0, name_len=0
[177266.376360] EXT4-fs error (device dm-1): empty_dir:1922: inode #12255304:
block 88074026: comm rm: bad entry in directory: rec_len is smaller than
minimal - offset=0(8192), inode=0, rec_len=0, name_len=0

fsck didn't notice this problem, but walking the tree seems to trigger it. I've
been trying to clean it up by just removing the offending directory, but it I
figured I'd mention it since it seems to be a problem that fsck -f didn't see.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
