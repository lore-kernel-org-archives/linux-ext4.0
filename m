From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 19212] kernel BUG at
 /build/buildd/linux-2.6.32/fs/ext4/extents.c:1716
Date: Sun, 26 Jun 2011 12:20:20 GMT
Message-ID: <201106261220.p5QCKKW5029435@demeter2.kernel.org>
References: <bug-19212-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:43005 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab1FZMUV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 26 Jun 2011 08:20:21 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p5QCKKEf029436
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 26 Jun 2011 12:20:20 GMT
In-Reply-To: <bug-19212-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=19212


Mikhail Vorozhtsov <mikhail.vorozhtsov@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mikhail.vorozhtsov@gmail.co
                   |                            |m




--- Comment #1 from Mikhail Vorozhtsov <mikhail.vorozhtsov@gmail.com>  2011-06-26 12:20:18 ---
Seems like it hit me. A few days ago a regular fsck run detected
multiply-claimed blocks on my /home and asked me to clone them. I answered
"yes". After that my kernel started oopsing 3-4 times a day. The process is
either transmission-gtk or flush-XYZ (with slightly different call traces, but
with the same code location). The message is (transmission-gtk variant, the
exact message is not in the logs, I'm posting the lines I wrote down on a
paper):

kernel BUG at fs/ext4/extents.c:1784
RIP: ext4_ext_insert_extent
Call trace:
  ext4_ext_map_blocks
? pagevec_lookup_tag
  ext4_map_blocks
  mpage_da_map_and_submit
? jbd2_journal_start
? ext4_da_writepages
  __filemap_fdatawrite_range
  filemap_write_and_wait_range
  vfs_fsync_range
  vfs_fsync
  sys_fsync
  system_call_fastpath

After rebooting fsck -f doesn't find any errors.

Kernel version is 2.6.39.1, e2fsprogs version is 1.41.14.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
