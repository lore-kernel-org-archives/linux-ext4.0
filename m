Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774203446DE;
	Wed,  1 Apr 2026 22:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775081331; cv=none; b=o67KHcn4ahua4uyYfWiLWnzbSS4INoI61nQATZlirc2BxLrWEs/4xYMyza05MAXgGtuUhf+UpRYMsrJbR/XdBZ2D4ThoHZu1XDC/y7J7LFskduaPjVU7Ef6KcJI0MyK/fRDoF/ykVGdRsrPbjXO3VzG0Jkn7eSn7bvTnsqHHOsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775081331; c=relaxed/simple;
	bh=Z9K8w6s7V5HknpBmPPcvfXamNo3gWLvI6pJ1a5aaw2c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iyHmiXYxLhETBXEaqKUPLyfj0TLutXhQlwE+kcCii/n44bg/VFScb735LoUB4nEbebateIiMmlI3zrLr0/HXYyw0ETb9o/pupGw9TfVfQyQpu1zS1Wl8i2Yztjy3z7VS3Byh0GUMGP0nL8BnbiAumQICCFdKBIG6KW1ZNA0ieB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from altlinux.ipa.basealt.ru (unknown [193.43.11.2])
	(Authenticated sender: kovalevvv)
	by air.basealt.ru (Postfix) with ESMTPSA id 3DBA1233AE;
	Thu,  2 Apr 2026 01:08:39 +0300 (MSK)
From: Vasiliy Kovalev <kovalev@altlinux.org>
To: Jan Kara <jack@suse.com>,
	Andrew Morton <akpm@osdl.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	kovalev@altlinux.org
Subject: [PATCH 1/2] ext2: validate i_nlink before decrement in ext2_unlink()
Date: Thu,  2 Apr 2026 01:08:36 +0300
Message-Id: <20260401220837.2424925-2-kovalev@altlinux.org>
X-Mailer: git-send-email 2.33.8
In-Reply-To: <20260401220837.2424925-1-kovalev@altlinux.org>
References: <20260401220837.2424925-1-kovalev@altlinux.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A crafted ext2 image can provide a directory entry pointing to an inode
with i_links_count == 0 on disk. Calling unlink() on such an entry
triggers WARN_ON inside drop_nlink():

WARNING: CPU: 3 PID: 609 at fs/inode.c:336 drop_nlink+0xad/0xd0 fs/inode.c:336
CPU: 3 UID: 0 PID: 609 Comm: syz-executor Not tainted 6.12.77+ #1
Call Trace:
 <TASK>
 inode_dec_link_count include/linux/fs.h:2518 [inline]
 ext2_unlink+0x26c/0x300 fs/ext2/namei.c:295
 vfs_unlink+0x2fc/0x9b0 fs/namei.c:4477
 do_unlinkat+0x53e/0x730 fs/namei.c:4541
 __do_sys_unlink fs/namei.c:4589 [inline]
 __se_sys_unlink fs/namei.c:4587 [inline]
 __x64_sys_unlink+0xc6/0x110 fs/namei.c:4587
 do_syscall_x64 arch/x86/entry/common.c:47 [inline]
 do_syscall_64+0xf5/0x220 arch/x86/entry/common.c:78
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

At the point of the crash, ext2_delete_entry() has already committed
the removal of the directory entry to disk, so returning an error is
not an option. Instead, skip the decrement and report the corruption
via ext2_error(), which marks the superblock as having errors. The
inode will be reclaimed when its last reference is dropped.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Cc: stable@vger.kernel.org
Fixes: a513b035eadf ("[PATCH] ext2: switch to inode_inc_count, inode_dec_count")
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
---
 fs/ext2/namei.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index bde617a66cec..ea49e8f2b292 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -293,7 +293,12 @@ static int ext2_unlink(struct inode *dir, struct dentry *dentry)
 		goto out;
 
 	inode_set_ctime_to_ts(inode, inode_get_ctime(dir));
-	inode_dec_link_count(inode);
+	if (!inode->i_nlink)
+		ext2_error(inode->i_sb, __func__,
+			   "inode %lu has zero i_nlink on unlink, fs may be corrupt",
+			   inode->i_ino);
+	else
+		inode_dec_link_count(inode);
 	err = 0;
 out:
 	return err;
-- 
2.50.1

