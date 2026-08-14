Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438AC3C0A13;
	Fri, 14 Aug 2026 09:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786701171; cv=none; b=TvOI3KagaejfnoSM5KeWU5kkGYxxKJY1Fpng9VJuDYoGkSiUe5JirkWVk7TxsaLds4m5EXnOpS7Dnf89gs59INn/4QsKRBguJrWdN6tzPoJW4TMnwp4twrf0ZulKCN3F8OtZLO+0Fwv/PuYwZ2IjWXE855bTqWFlYPTxa9ZEMZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786701171; c=relaxed/simple;
	bh=CSqV7drS2LhKrxjqgy2PweyXzpaQs16hCrIFJeznxEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQyKUUuclWJG4sZ11QNL2zFPkJEvPSrAGqAoc1gGfhiAYEiy3y4M1TJ9pnYgYY7rt0Vq8TQEOP+9UjapRxd6CD14+TStwTlSBFnd0FVLzEPJd1Px1qPfrFu9qB/0JY6XwgFKlE+Qx7OovTq8tUH30NatwrKYDyeCDvcgstE5qgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hLyFS0YxgzYQvWv;
	Fri, 14 Aug 2026 17:52:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 4B8E14058D;
	Fri, 14 Aug 2026 17:52:36 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBXR0ZK5X5qbKAYCQ--.57632S5;
	Fri, 14 Aug 2026 17:52:36 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	djwong@kernel.org,
	hch@infradead.org,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	chengzhihao1@huawei.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH -next v5 32/32] ext4: introduce a mount option for iomap buffered I/O path
Date: Fri, 14 Aug 2026 17:46:16 +0800
Message-ID: <20260814094616.1710143-2-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgBXR0ZK5X5qbKAYCQ--.57632S5
X-Coremail-Antispam: 1UD129KBjvJXoWxWr47Kr15Gr1xZry3ZFy7KFg_yoWrGr1xpr
	W5KFyrKr1kXryF9w48uF4kXr1Yy3Zaka1UCrZYgr47Ga9rAryIqFyfKF13AFWagrW8X340
	qF1rWw17Wa13CrDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmlb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WxJr0_GcWl84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I
	0E8cxan2IY04v7MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCa
	FVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_Jr
	Wlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26ryj
	6F1UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWlIxAIcVCF04k26cxKx2IYs7xG6r
	1j6r1xMIIF0xvEx4A2jsIE14v26F4j6r4UJwCI42IY6I8E87Iv6xkF7I0E14v26F4UJVW0
	obIYCTnIWIevJa73UjIFyTuYvjTRvZXoUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Since the iomap buffered I/O path does not yet support all existing ext4
features, it cannot be enabled by default. Introduce the
'buffered_iomap' and 'nobuffered_iomap' mount options to explicitly
enable or disable the iomap buffered I/O path for regular files.

Toggling this option via remount is allowed. The change of I/O path will
not take effect immediately. It will be deferred. The new setting will
only take effect after the inode is re-initialized (i.e., after the last
reference is dropped and the inode is re-read from disk).

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h  | 1 +
 fs/ext4/inode.c | 6 ++++++
 fs/ext4/super.c | 7 +++++++
 3 files changed, 14 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 405e256a1802..8cfe77b45e21 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1321,6 +1321,7 @@ struct ext4_inode_info {
 						    * scanning in mballoc
 						    */
 #define EXT4_MOUNT2_ABORT		0x00000100 /* Abort filesystem */
+#define EXT4_MOUNT2_BUFFERED_IOMAP	0x00000200 /* Use iomap for buffered I/O */
 
 #define clear_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt &= \
 						~EXT4_MOUNT_##opt
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c9ee78fba4d0..c7466ecc44c2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6080,11 +6080,17 @@ static int check_igot_inode(struct inode *inode, ext4_iget_flags flags,
  * For extent-to-indirect block migration (via EXT4_IOC_SETFLAGS
  * clearing EXT4_EXTENTS_FL), this operation is directly rejected for
  * inodes using the iomap path.
+ *
+ * When remounting to toggle the buffered_iomap mount option, the change
+ * of I/O path is deferred as well, it will be available after the inode
+ * is re-initialized.
  */
 void ext4_enable_buffered_iomap(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 
+	if (!test_opt2(sb, BUFFERED_IOMAP))
+		return;
 	if (!S_ISREG(inode->i_mode))
 		return;
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EA_INODE))
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 86ed5228dbe9..0855f9801df4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1746,6 +1746,7 @@ enum {
 	Opt_discard, Opt_nodiscard, Opt_init_itable, Opt_noinit_itable,
 	Opt_max_dir_size_kb, Opt_nojournal_checksum, Opt_nombcache,
 	Opt_no_prefetch_block_bitmaps, Opt_mb_optimize_scan,
+	Opt_buffered_iomap, Opt_nobuffered_iomap,
 	Opt_errors, Opt_data, Opt_data_err, Opt_jqfmt, Opt_dax_type,
 #ifdef CONFIG_EXT4_DEBUG
 	Opt_fc_debug_max_replay, Opt_fc_debug_force
@@ -1884,6 +1885,8 @@ static const struct fs_parameter_spec ext4_param_specs[] = {
 	fsparam_flag	("no_prefetch_block_bitmaps",
 						Opt_no_prefetch_block_bitmaps),
 	fsparam_s32	("mb_optimize_scan",	Opt_mb_optimize_scan),
+	fsparam_flag	("buffered_iomap",	Opt_buffered_iomap),
+	fsparam_flag	("nobuffered_iomap",	Opt_nobuffered_iomap),
 	fsparam_string	("check",		Opt_removed),	/* mount option from ext2/3 */
 	fsparam_flag	("nocheck",		Opt_removed),	/* mount option from ext2/3 */
 	fsparam_flag	("reservation",		Opt_removed),	/* mount option from ext2/3 */
@@ -1977,6 +1980,10 @@ static const struct mount_opts {
 	{Opt_nombcache, EXT4_MOUNT_NO_MBCACHE, MOPT_SET},
 	{Opt_no_prefetch_block_bitmaps, EXT4_MOUNT_NO_PREFETCH_BLOCK_BITMAPS,
 	 MOPT_SET},
+	{Opt_buffered_iomap, EXT4_MOUNT2_BUFFERED_IOMAP,
+	 MOPT_SET | MOPT_2 | MOPT_EXT4_ONLY},
+	{Opt_nobuffered_iomap, EXT4_MOUNT2_BUFFERED_IOMAP,
+	 MOPT_CLEAR | MOPT_2 | MOPT_EXT4_ONLY},
 #ifdef CONFIG_EXT4_DEBUG
 	{Opt_fc_debug_force, EXT4_MOUNT2_JOURNAL_FAST_COMMIT,
 	 MOPT_SET | MOPT_2 | MOPT_EXT4_ONLY},
-- 
2.52.0

