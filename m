From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13201] kernel BUG at fs/ext4/extents.c:2737
Date: Thu, 30 Apr 2009 09:39:22 GMT
Message-ID: <200904300939.n3U9dMaT003315@demeter.kernel.org>
References: <bug-13201-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47963 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbZD3JjW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Apr 2009 05:39:22 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n3U9dMrq003316
	for <linux-ext4@vger.kernel.org>; Thu, 30 Apr 2009 09:39:22 GMT
In-Reply-To: <bug-13201-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13201





--- Comment #5 from Franco Broi <franco@fugro-fsi.com.au>  2009-04-30 09:39:21 ---
I've now got filesystem corruption with 2.6.30-rc3-git5, looks pretty much the
same as before.

Apr 30 17:30:56 echo20 kernel: EXT4-fs error (device dm-3):
ext4_mb_generate_buddy: EXT4-fs: group 0: 32768 blocks in bitmap, 23495 in gd
Apr 30 17:30:56 echo20 kernel: EXT4-fs error (device dm-3):
ext4_mb_mark_diskspace_used: Allocating block 1024 in system zone of 0 group

When I do an ls in the test directory I get lots of Input/output errors

EXT4-fs error (device dm-3): ext4_lookup: deleted inode referenced: 127
EXT4-fs error (device dm-3): ext4_lookup: deleted inode referenced: 358
EXT4-fs error (device dm-3): ext4_lookup: deleted inode referenced: 196

Anything you want me to try?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
