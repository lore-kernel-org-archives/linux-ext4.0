Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC0A277026;
	Sat,  4 Apr 2026 15:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775316025; cv=none; b=J9B3jlSqnpuCzRntBQ2uumsqkRY48Cbi7meXE2VErwpUOmM0VX6IosZkoV20NAkZ/BTkXTbzErD74rtVQps8aeAMw+iegBWJgCj6+RYynM8DnRNUBiwqdDjGu/vo97Tkdy66BsOQPwSa6GBIeWAWsCb6GsJTnhAXLeDoPWsOesk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775316025; c=relaxed/simple;
	bh=tYSMBNByKr+z9h6uIYZ2DGG1o9YGIs77Rau0MOUuVpw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nNLRQuiZ5IA+JyHQa7RRzC8wMMfw/IbDU99UPE/7NgDyK1EPkOGdzjRpuqS46OGOu23sxh5tt+2uguEZSUJhBhSnlcNO0tk5L9RCG4cw0QSLvr8S/XQbJrJaa/AgRCZ8deUiNiV2lXSLJb/AfQw+oFTd5zOnKlcrLGNDeHjnwT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from altlinux.ipa.basealt.ru (unknown [193.43.11.2])
	(Authenticated sender: kovalevvv)
	by air.basealt.ru (Postfix) with ESMTPSA id F2FA123372;
	Sat,  4 Apr 2026 18:20:12 +0300 (MSK)
From: Vasiliy Kovalev <kovalev@altlinux.org>
To: Jan Kara <jack@suse.com>,
	linux-ext4@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	kovalev@altlinux.org
Subject: [PATCH] ext2: reject inodes with zero i_nlink and valid mode in ext2_iget()
Date: Sat,  4 Apr 2026 18:20:11 +0300
Message-Id: <20260404152011.2590197-1-kovalev@altlinux.org>
X-Mailer: git-send-email 2.33.8
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext2_iget() already rejects inodes with i_nlink == 0 when i_mode is
zero or i_dtime is set, treating them as deleted. However, the case of
i_nlink == 0 with a non-zero mode and zero dtime slips through. Since
ext2 has no orphan list, such a combination can only result from
filesystem corruption - a legitimate inode deletion always sets either
i_dtime or clears i_mode before freeing the inode.

A crafted image can exploit this gap to present such an inode to the
VFS, which then triggers WARN_ON inside drop_nlink() (fs/inode.c) via
ext2_unlink(), ext2_rename() and ext2_rmdir():

WARNING: CPU: 3 PID: 609 at fs/inode.c:336 drop_nlink+0xad/0xd0 fs/inode.c:336
CPU: 3 UID: 0 PID: 609 Comm: syz-executor Not tainted 6.12.77+ #1
Call Trace:
 <TASK>
 inode_dec_link_count include/linux/fs.h:2518 [inline]
 ext2_unlink+0x26c/0x300 fs/ext2/namei.c:295
 vfs_unlink+0x2fc/0x9b0 fs/namei.c:4477
 do_unlinkat+0x53e/0x730 fs/namei.c:4541
 __x64_sys_unlink+0xc6/0x110 fs/namei.c:4587
 do_syscall_64+0xf5/0x220 arch/x86/entry/common.c:78
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

WARNING: CPU: 0 PID: 646 at fs/inode.c:336 drop_nlink+0xad/0xd0 fs/inode.c:336
CPU: 0 UID: 0 PID: 646 Comm: syz.0.17 Not tainted 6.12.77+ #1
Call Trace:
 <TASK>
 inode_dec_link_count include/linux/fs.h:2518 [inline]
 ext2_rename+0x35e/0x850 fs/ext2/namei.c:374
 vfs_rename+0xf2f/0x2060 fs/namei.c:5021
 do_renameat2+0xbe2/0xd50 fs/namei.c:5178
 __x64_sys_rename+0x7e/0xa0 fs/namei.c:5223
 do_syscall_64+0xf5/0x220 arch/x86/entry/common.c:78
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

WARNING: CPU: 0 PID: 634 at fs/inode.c:336 drop_nlink+0xad/0xd0 fs/inode.c:336
CPU: 0 UID: 0 PID: 634 Comm: syz-executor Not tainted 6.12.77+ #1
Call Trace:
 <TASK>
 inode_dec_link_count include/linux/fs.h:2518 [inline]
 ext2_rmdir+0xca/0x110 fs/ext2/namei.c:311
 vfs_rmdir+0x204/0x690 fs/namei.c:4348
 do_rmdir+0x372/0x3e0 fs/namei.c:4407
 __x64_sys_unlinkat+0xf0/0x130 fs/namei.c:4577
 do_syscall_64+0xf5/0x220 arch/x86/entry/common.c:78
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Extend the existing i_nlink == 0 check to also catch this case,
reporting the corruption via ext2_error() and returning -EFSCORRUPTED.
This rejects the inode at load time and prevents it from reaching any
of the namei.c paths.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
---
 fs/ext2/inode.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index dbfe9098a124..39d972722f5f 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1430,9 +1430,17 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
 	 * the test is that same one that e2fsck uses
 	 * NeilBrown 1999oct15
 	 */
-	if (inode->i_nlink == 0 && (inode->i_mode == 0 || ei->i_dtime)) {
-		/* this inode is deleted */
-		ret = -ESTALE;
+	if (inode->i_nlink == 0) {
+		if (inode->i_mode == 0 || ei->i_dtime) {
+			/* this inode is deleted */
+			ret = -ESTALE;
+		} else {
+			ext2_error(sb, __func__,
+				   "inode %lu has zero i_nlink with mode 0%o and no dtime, "
+				   "filesystem may be corrupt",
+				   ino, inode->i_mode);
+			ret = -EFSCORRUPTED;
+		}
 		goto bad_inode;
 	}
 	inode->i_blocks = le32_to_cpu(raw_inode->i_blocks);
-- 
2.50.1

