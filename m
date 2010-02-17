From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15025] Oops in ext4 driver
Date: Wed, 17 Feb 2010 13:48:11 GMT
Message-ID: <201002171348.o1HDmBTW031193@demeter.kernel.org>
References: <bug-15025-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36784 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934203Ab0BQNsO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Feb 2010 08:48:14 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1HDmBkv031194
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 17 Feb 2010 13:48:11 GMT
In-Reply-To: <bug-15025-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15025





--- Comment #11 from Dmitry Monakhov <dmonakhov@openvz.org>  2010-02-17 13:47:27 ---
After the patch i can not trigger the bug (In reply to comment #10)
> On Tue, Feb 16, 2010 at 02:08:33PM +0000, bugzilla-daemon@bugzilla.kernel.org
> wrote:
> > The issue was fixed by following commit
> > http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commit;h=1db913823c0f8360fccbd24ca67eb073966a5ffd
> 
> This cannot be, as I don't use quota.
It i is posible to triger the bug without quota.
Untill the patch it we have following code
fs/ext4/inode.c:
1850         if (ext4_claim_free_blocks(sbi, md_needed + 1)) {
1851                 vfs_dq_release_reservation_block(inode, md_needed + 1);
1852                 if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
1853                 retry:
1854                         if (md_reserved)
1855                                 write_inode_now(inode, (retries == 3));
^^^^^^^^^^ Here we goes in to lack of journal credits. ^^^^^^^^^^^^^^^^^^^^^^
1856                         yield();
1857                         goto repeat;
1858                 }
1859                 return -ENOSPC;
1860         }
You have failed exactly here.
So the bug happens even in case of ENOSPC (try following testase):
dd if=/dev/zero /mnt/BIG_FILE bs=1M 
But it takes longer if partition is really huge.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
