Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.159.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794262350;
	b=Q7UG/d/afISKMz9fM7I3IPvgOBo5N55LUDE/A2Y2bAy1UZ6mmna+eTpMG8idQyrtEwXe
	 SNT5yMg3VivD82fzP16lE7e5PtGCbi5ct1CMAXcp0eoy94uYxSCPS/mockWxOD52ZOkE9
	 iAl3VqOJim4Gwjz0uFRK8Y6Uvh16q2AsuvgrV4ouIx/I8lyv9hTHxyqCT2nQ+0rs96osm
	 8v/D70d1IDBnCHovTzSbQ3Qvc1b/+VhpvmrnvwiKa7rBlAj30YhAP7suHCaH6oiLf7zG+
	 rEwemn6lxtBUElzaFhLdjNl0Gyd0/rrNIx8SXOZ2Ecpc2ke1qWGko2mILbHBxagXvzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794262350;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-Get-Message-Sender-Via:
	 X-Authenticated-Sender:X-Source:X-Source-Args:X-Source-Dir;
	bh=xgvmP0yR+MtGh0RmcZ6t9qcDIy0KV5BDdf5DZR4AHIw=;
	b=d3FT5HrVJli0HQtS2X3NOdchhThtDIdkcvdhEoqXfj56DlF7b1JvkYd05keOP5aN+qhu
	 5KI/+g4I3ZQyhUtEa7PR+K/q+6NdeloRE614/PxYBjY0bccsKdl59QXsY3CdKHXhU4rcL
	 stqVmEjBiCHTYtlqiSejDFYh82whkdwL0JxvwTHJg8vUvYycgApd49w7orjBWTKEaQ5MO
	 PH2hdrxpipHGWtssiJANsRQ5Gdu8Yvj0Gsqgtfc1LuH5siDSH+xyxKkSkm5EVdSbCL+bm
	 jZVjmarZ80rmkJOx8K81ubRXwiGu9ZjJ3vCdIPn37NrBmYJLI7LIHY6nwepYX4LucQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.cyber.gouv.fr;
	spf=pass smtp.mailfrom=oss.cyber.gouv.fr;
	dkim=pass header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=kDuLzLVs;
	arc=none smtp.remote-ip=51.159.188.251
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AE4606A31C;
	Mon,  9 Nov 2026 22:12:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4AE4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=kDuLzLVs
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Sender:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References;
	bh=xgvmP0yR+MtGh0RmcZ6t9qcDIy0KV5BDdf5DZR4AHIw=; b=kDuLzLVsQ0SFzAPM9Ea2q4LIjk
	vOzPZU1P42riJ4bh3CEQzzhWqmWlE8C90zzmPuR94gS3HF3ctAWwG0oDsOunwVTvjd3pWBvVmkkdP
	9OZJPdERN+A31guqceVx7K/fMvGTgjIZkUEuMiDAKU6NCnCzM1U4hr9qK4TH3+oFJbEGbnJW14LLu
	AstqSGR/uqWDjLOiMqIqAAAewUhCUvDBWjEYJSO7EpoZsXnJ8wj2ROFpnXzSub82/kl7P68Z8Mphf
	7dyjl/DQpdHO6Fv23HNbPjTk2jb9cG0LLlrb3qsAf5LUfV/L7HGctBErU2fjrtd2rVgXOrC5o3Ksb
	ZNaLvvLw==;
Received: from [151.115.150.205] (port=59320 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1xQXbI-0000000GC1M-02Ej;
	Mon, 09 Nov 2026 23:12:27 +0100
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: tytso@mit.edu
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	stable@kernel.org
Subject: [PATCH v3] ext4: validate extent root during fast commit replay
Date: Mon,  9 Nov 2026 22:12:11 +0000
Message-ID: <20261109221211.1793790-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

Fast commit replay skips extent tree validation in ext4_iget(). The
replay code then reads and updates the extent root stored in i_data
without validating its header.

The root has space for four extents. A corrupt header with eh_entries
set to 4 and eh_max set to 5 lets replay insert a fifth extent past
the end of i_data, which overwrites other fields in struct
ext4_inode_info.

Check the root in ext4_find_extent() during fast commit replay. Skip
extent replay helpers for non-extent inodes and clear the replay state
before loading the root inode.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Cc: stable@kernel.org
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---

Changes in v3:
- Skip extent replay helpers for non-extent inodes.
- Clear EXT4_FC_REPLAY before loading the root inode.

Changes in v2:
- Validate replay roots regardless of EXT4_INODE_EXTENTS.
- Rebase on fa4ad798f6f6.

v2: https://lore.kernel.org/all/20261108201906.1417129-2-Jeremy.Jean@oss.cyber.gouv.fr/
v1: https://lore.kernel.org/all/20260821100559.3612643-2-Jeremy.Jean@oss.cyber.gouv.fr/

 fs/ext4/extents.c     | 8 +++++++-
 fs/ext4/fast_commit.c | 4 ++--
 fs/ext4/super.c       | 3 +--
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ad0d80e33f609..aec75a680bcc7 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -905,6 +905,12 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t block,
 		ret = -EFSCORRUPTED;
 		goto err;
 	}
+	/* ext4_iget() skips extent validation during fast commit replay. */
+	if (unlikely(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_FC_REPLAY)) {
+		ret = ext4_ext_check(inode, eh, depth, 0);
+		if (ret)
+			goto err;
+	}
 
 	if (path) {
 		ext4_ext_drop_refs(path);
@@ -6391,7 +6397,7 @@ int ext4_ext_clear_bb(struct inode *inode)
 	int j, ret = 0;
 	struct ext4_map_blocks map;
 
-	if (ext4_test_inode_flag(inode, EXT4_INODE_INLINE_DATA))
+	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		return 0;
 
 	/* Determin the size of the file first */
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 0cac890cf3702..b883ce015c303 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -2002,7 +2002,7 @@ static int ext4_fc_replay_inode(struct super_block *sb,
 	 * crashing. This should be fixed but until then, we calculate
 	 * the number of blocks the inode.
 	 */
-	if (!ext4_test_inode_flag(inode, EXT4_INODE_INLINE_DATA))
+	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		ext4_ext_replay_set_iblocks(inode);
 
 	inode->i_generation = le32_to_cpu(ext4_raw_inode(&iloc)->i_generation);
@@ -2334,7 +2334,7 @@ static void ext4_fc_set_bitmaps_and_counters(struct super_block *sb)
 		}
 		cur = 0;
 		end = EXT_MAX_BLOCKS;
-		if (ext4_test_inode_flag(inode, EXT4_INODE_INLINE_DATA)) {
+		if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
 			iput(inode);
 			continue;
 		}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9cae52471dee9..8dac2c1cea78a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5660,6 +5660,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	 * The jbd2_journal_load will have done any necessary log recovery,
 	 * so we can safely mount the rest of the filesystem now.
 	 */
+	ext4_fc_replay_cleanup(sb);
 
 	root = ext4_iget(sb, EXT4_ROOT_INO, EXT4_IGET_SPECIAL);
 	if (IS_ERR(root)) {
@@ -5699,8 +5700,6 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 			goto failed_mount4a;
 		}
 	}
-	ext4_fc_replay_cleanup(sb);
-
 	ext4_ext_init(sb);
 
 	/*
-- 
2.47.3

