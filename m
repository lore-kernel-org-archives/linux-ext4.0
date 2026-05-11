Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D1B382F12;
	Mon, 11 May 2026 07:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778484515; cv=none; b=p2igSRejRPlTO1mnebC4oTRdogL2HZwcPuYbe8Up5q6IlzFyVak1QeQ1crDn1/l4U193LLr2fxdFutUfNem3FsIdIYEtqanm8YZvF1ViIj7Gm0pMSL8hIaUhaPNxFLVQABs6m/CPshMcHcjZt5b9naGNeKZfEuCZTSJkiEz2peo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778484515; c=relaxed/simple;
	bh=sC2PMkkRrNq9n4qZSxY2/rgPnKy2JdKz6pFNsx2pU7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Muhq43sVjHqznl90P5AT7f08yZI2bfZWUMVZAPnzPclzyPIXvrMDIrVo+Lg+FqOjPlSKNbZbF49NJtIw5VH66EzId+c3Tg61iPYqagMA0vnvPnnxvWiA/hWhvljmB+YiouZpPMFb7m7H5PhdESFS+BebaOtaVs8NS++TLTlWUnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gDWX572VBzKHMgF;
	Mon, 11 May 2026 15:27:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7F6C040561;
	Mon, 11 May 2026 15:28:24 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with SMTP id gCh0CgD3v1sKhQFqAy6MBw--.28537S27;
	Mon, 11 May 2026 15:28:24 +0800 (CST)
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
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v4 23/23] ext4: introduce a mount option for iomap buffered I/O path
Date: Mon, 11 May 2026 15:23:43 +0800
Message-ID: <20260511072344.191271-24-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3v1sKhQFqAy6MBw--.28537S27
X-Coremail-Antispam: 1UD129KBjvJXoWxWr47Kr15Gr1xZry3ZFy7KFg_yoWrGr1xpr
	WYgFyrGr1kXryF9w4xuFs5Xr1Yy3ZIka1UCrWFgr47Ga9rAryIqFyfKF15AFW2grW8X34I
	qF1rWw17Ga13CrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
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
index afba952abd28..33da8c1915a7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1290,6 +1290,7 @@ struct ext4_inode_info {
 						    * scanning in mballoc
 						    */
 #define EXT4_MOUNT2_ABORT		0x00000100 /* Abort filesystem */
+#define EXT4_MOUNT2_BUFFERED_IOMAP	0x00000200 /* Use iomap for buffered I/O */
 
 #define clear_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt &= \
 						~EXT4_MOUNT_##opt
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0407e7b54dcd..1432ef29748b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5907,11 +5907,17 @@ static int check_igot_inode(struct inode *inode, ext4_iget_flags flags,
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
index 9c0a00e716f3..2fc07739c9e8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1733,6 +1733,7 @@ enum {
 	Opt_discard, Opt_nodiscard, Opt_init_itable, Opt_noinit_itable,
 	Opt_max_dir_size_kb, Opt_nojournal_checksum, Opt_nombcache,
 	Opt_no_prefetch_block_bitmaps, Opt_mb_optimize_scan,
+	Opt_buffered_iomap, Opt_nobuffered_iomap,
 	Opt_errors, Opt_data, Opt_data_err, Opt_jqfmt, Opt_dax_type,
 #ifdef CONFIG_EXT4_DEBUG
 	Opt_fc_debug_max_replay, Opt_fc_debug_force
@@ -1871,6 +1872,8 @@ static const struct fs_parameter_spec ext4_param_specs[] = {
 	fsparam_flag	("no_prefetch_block_bitmaps",
 						Opt_no_prefetch_block_bitmaps),
 	fsparam_s32	("mb_optimize_scan",	Opt_mb_optimize_scan),
+	fsparam_flag	("buffered_iomap",	Opt_buffered_iomap),
+	fsparam_flag	("nobuffered_iomap",	Opt_nobuffered_iomap),
 	fsparam_string	("check",		Opt_removed),	/* mount option from ext2/3 */
 	fsparam_flag	("nocheck",		Opt_removed),	/* mount option from ext2/3 */
 	fsparam_flag	("reservation",		Opt_removed),	/* mount option from ext2/3 */
@@ -1964,6 +1967,10 @@ static const struct mount_opts {
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

