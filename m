Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6628C4B405F;
	Fri,  9 Oct 2026 10:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542738; cv=none; b=baj8ZkfNNvQKFSkEtAuWELqQfHjljFBx9eep8+RQuLBe2MS5JO9spaDiY4KI89rLFpkVEcQsy+JmHk0pEz+triqGlP4/QJXnBiQag5SLT3h+DNRbuvDK+rLwAjh27vCOoYySHwqn8lvICmvbzruwV9clY2CaSWQOTfyC17xvYVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542738; c=relaxed/simple;
	bh=lTVQNSVZmr5VglOCV+yaDMFr6zJ3wIqghKj5lOCLz9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxexiZ5NW1UYzGy7U9hY+COxFpxWYGL8DewbcMXB/hNLQFx0UoVbHqyU9fHldroYQ42KXRblRVeCIjg4UlpIujWKB7JbpVeOqd9nxUpKLefOmvkrSmvMs1+IxpJlwcUEPTL4H+tQ6+KZhyQVrBbb/W0PksJM7fP7bPoz92iWX3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4j1Nlc1xkzzKHMnP;
	Fri,  9 Oct 2026 18:44:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 374B04056F;
	Fri,  9 Oct 2026 18:45:20 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgD3xim0xchqcxdfDQ--.55186S6;
	Fri, 09 Oct 2026 18:45:19 +0800 (CST)
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
	wangkefeng.wang@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v7 31/31] ext4: introduce a mount option for iomap buffered I/O path
Date: Fri,  9 Oct 2026 18:38:31 +0800
Message-ID: <20261009103831.2978767-3-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3xim0xchqcxdfDQ--.55186S6
X-Coremail-Antispam: 1UD129KBjvJXoWxWr47Kr15Gr1xZry3ZFy7KFg_yoWrGr48pr
	Z8KFyrGr1kXryF9w48uF4kXr1Fy3Waka1UCrWFgrnrGa9rAryIqFyxKF15AF4agrW8X340
	qF1rWw17Wa17CrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6rxdM2
	8EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr1j6rxdMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26F4UJVW0obIYCTnIWIev
	Ja73UjIFyTuYvjTR_3kZDUUUU
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
index 405e256a1802b..8cfe77b45e21b 100644
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
index a07ce368e6e82..1853fbdc2a5af 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6125,11 +6125,17 @@ static int check_igot_inode(struct inode *inode, ext4_iget_flags flags,
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
index 73735fd336b91..7db34ba0ea593 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1747,6 +1747,7 @@ enum {
 	Opt_discard, Opt_nodiscard, Opt_init_itable, Opt_noinit_itable,
 	Opt_max_dir_size_kb, Opt_nojournal_checksum, Opt_nombcache,
 	Opt_no_prefetch_block_bitmaps, Opt_mb_optimize_scan,
+	Opt_buffered_iomap, Opt_nobuffered_iomap,
 	Opt_errors, Opt_data, Opt_data_err, Opt_jqfmt, Opt_dax_type,
 #ifdef CONFIG_EXT4_DEBUG
 	Opt_fc_debug_max_replay, Opt_fc_debug_force
@@ -1885,6 +1886,8 @@ static const struct fs_parameter_spec ext4_param_specs[] = {
 	fsparam_flag	("no_prefetch_block_bitmaps",
 						Opt_no_prefetch_block_bitmaps),
 	fsparam_s32	("mb_optimize_scan",	Opt_mb_optimize_scan),
+	fsparam_flag	("buffered_iomap",	Opt_buffered_iomap),
+	fsparam_flag	("nobuffered_iomap",	Opt_nobuffered_iomap),
 	fsparam_string	("check",		Opt_removed),	/* mount option from ext2/3 */
 	fsparam_flag	("nocheck",		Opt_removed),	/* mount option from ext2/3 */
 	fsparam_flag	("reservation",		Opt_removed),	/* mount option from ext2/3 */
@@ -1978,6 +1981,10 @@ static const struct mount_opts {
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

