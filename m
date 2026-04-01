Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77399317159;
	Wed,  1 Apr 2026 22:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775081329; cv=none; b=K3QtAxiM+NDE2443gW7FOFkPOwVn+P1U9hbQUusqBB05K76Ov+gd7lLxw2oyqcxjA0fYmOoVzltuZx4TqrpaRhg3Pi4r/ztSZXU18fWB6vHMRo4vB9/vv/WEEGkgVTX33WvjcF7tfnjR6u4/gHUpcBqEyZYAdOHZUGyOu+Sq6R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775081329; c=relaxed/simple;
	bh=MQ6mMLeRVVCpGziZCG9YUYpdmIkZPgjaOuM7eD6LjDM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z6yajuoPMcnhEAmUmp3HXZweoby6nhEiyuZauI/zfOX3O1h17RC/TSqSJkpC2/zJ1IzjxsR81Faa+z/FLXddNlU7cEKzVOsVm0eTGIlWKCOxDhiNnENcayoQ9FsT2Bc7Czmg03jCSdbq/j0RVtig9PYSnVQo0jyNW+aYBiJU3Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from altlinux.ipa.basealt.ru (unknown [193.43.11.2])
	(Authenticated sender: kovalevvv)
	by air.basealt.ru (Postfix) with ESMTPSA id 242FA233AF;
	Thu,  2 Apr 2026 01:08:40 +0300 (MSK)
From: Vasiliy Kovalev <kovalev@altlinux.org>
To: Jan Kara <jack@suse.com>,
	Andrew Morton <akpm@osdl.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	kovalev@altlinux.org
Subject: [PATCH 2/2] ext2: guard against zero i_nlink on new_inode in ext2_rename()
Date: Thu,  2 Apr 2026 01:08:37 +0300
Message-Id: <20260401220837.2424925-3-kovalev@altlinux.org>
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

A crafted ext2 image can provide a target inode with i_links_count == 0
on disk. When rename() resolves to an existing target, ext2_rename()
calls drop_nlink(new_inode) for the directory case and
inode_dec_link_count(new_inode) unconditionally. Both reach
drop_nlink(), which triggers WARN_ON:

WARNING: CPU: 0 PID: 646 at fs/inode.c:336 drop_nlink+0xad/0xd0 fs/inode.c:336
CPU: 0 UID: 0 PID: 646 Comm: syz.0.17 Not tainted 6.12.77+ #1
Call Trace:
 <TASK>
 inode_dec_link_count include/linux/fs.h:2518 [inline]
 ext2_rename+0x35e/0x850 fs/ext2/namei.c:374
 vfs_rename+0xf2f/0x2060 fs/namei.c:5021
 do_renameat2+0xbe2/0xd50 fs/namei.c:5178
 __do_sys_rename fs/namei.c:5225 [inline]
 __se_sys_rename fs/namei.c:5223 [inline]
 __x64_sys_rename+0x7e/0xa0 fs/namei.c:5223
 do_syscall_x64 arch/x86/entry/common.c:47 [inline]
 do_syscall_64+0xf5/0x220 arch/x86/entry/common.c:78
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

No disk state has been modified at this point in the function, so
return -EFSCORRUPTED after reporting the corruption via ext2_error().

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Cc: stable@vger.kernel.org
Fixes: 9a53c3a783c2 ("[PATCH] r/o bind mounts: unlink: monitor i_nlink")
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
---
 fs/ext2/namei.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index ea49e8f2b292..419e844f2e54 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -334,6 +334,13 @@ static int ext2_rename (struct mnt_idmap * idmap,
 	bool old_is_dir = S_ISDIR(old_inode->i_mode);
 	int err;
 
+	if (new_inode && new_inode->i_nlink == 0) {
+		ext2_error(old_dir->i_sb, __func__,
+			   "target inode %lu has zero i_nlink, filesystem may be corrupt",
+			   new_inode->i_ino);
+		return -EFSCORRUPTED;
+	}
+
 	if (flags & ~RENAME_NOREPLACE)
 		return -EINVAL;
 
-- 
2.50.1

