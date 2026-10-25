Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792959495;
	b=B+XJF/nEGsnOg1McMO1gP4zuF8yoclh22fAAFJmwVRuSIT6sFazoB1kocwVqcGjPwGSF
	 T37eY1r1mD+umGd4UBUV1Vf45rxkmUTO4dI0dFuSHtOC0jcCPqLFQ8kg90bX2OAW3EQvM
	 vHc1RWbePyuOuVqFwWPfGOrJcX9/NuiDgzsSKRgRboBanVlk2nJELSGhO97bvWxB1wATt
	 8USsx+ozf1R1wKSwJRPYKLpQeNe/+gHIocs7p7clKfTZW1zzPmxa3KfSGUgy5SGfhepfu
	 wcLOVXHP5NcDraiod8Z9N3jiUO7PgzAfdVy3GryU9VYiPrvjFQ4pTQ6U5yN81bl+mTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792959495;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=3bl//oRoLYKEC10MdpMzhYboP9vO6iYcqHHzxXxAXVs=;
	b=tX/oQLJ0vNjPYFjrASrN7VIhXZZNNPZYj8YeBG/bjqLEC1bPlLLiUS6llcm1/8FSzg5V
	 2iJL+mGnukJZoVa7ZUW+JERV87B0x0zPN4IdhDSXhLLy6Mj5druGo1utQ8Iw7hAi2v33Z
	 vSEo0YJDkLeTEO9iTsK9qz3q0U1qQneyffhrozxro1miUX10RfZr6VKpIqNBb0p5KAi2A
	 09FpMvy+lmvI54lqYA5BP1sSw4S/I5u/Cv+VK1MotXKvxllJbAgMpqhELRGpRvf3lRrx6
	 y48nlq+NOOuYZys/RtSRcS4Hbqcnt5nTMFgA2XmlRl5xoQk0XYuoOzfQS9O2RD174Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=czerner.cz;
	spf=pass smtp.mailfrom=czerner.cz;
	dkim=pass header.d=czerner.cz header.i=@czerner.cz header.a=rsa-sha256 header.s=protonmail3 header.b=T64qlvG+;
	arc=none smtp.remote-ip=79.135.106.111
Received: from mail-106111.protonmail.ch (mail-106111.protonmail.ch [79.135.106.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB465606A322
	for <linux-ext4@vger.kernel.org>; Sun, 25 Oct 2026 20:18:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB465606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=czerner.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=czerner.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=czerner.cz header.i=@czerner.cz header.a=rsa-sha256 header.s=protonmail3 header.b=T64qlvG+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=czerner.cz;
	s=protonmail3; t=1792959492; x=1793218692;
	bh=3bl//oRoLYKEC10MdpMzhYboP9vO6iYcqHHzxXxAXVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=T64qlvG+6gaE/+n496N3DT/XpY3+Qmm9potsPMC7PLyamioQOZ7O9zz7H8/KRl2C4
	 joefJf4phpZkS6esTrdb9b/3CpjxbaOWL86fvABuhh+th76qz14Ug2NTV5VABtD/1l
	 bfkE4FBCj9elWbnwsUfzqj8rbQwLVGUjB1nOT4c3D3LtIP7gKTXUqNH14rE+CsOnxZ
	 qZc162FAhmErIFWYwGkJ86p2RCYdlb4JqCO9y/RIOCf2ME3Gs4iKWC0tYajfSaipVC
	 UM011rjNy30ZwSQyCw51i65QX6iebl+A6E6k+Qotha+YgdScp+82ivcNoVbkEeQzOa
	 utFwjWuywhc3Q==
X-Pm-Submission-Id: 4jCSkC0Gc4z2Sd2t
From: Lukas Czerner <lukas@czerner.cz>
To: linux-ext4@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Lukas Czerner <lukas@czerner.cz>
Subject: [PATCH 1/2] ext4: fix failed migrate freeing extent tree blocks
Date: Sun, 25 Oct 2026 21:18:02 +0100
Message-ID: <20261025201803.3043712-2-lukas@czerner.cz>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261025201803.3043712-1-lukas@czerner.cz>
References: <20261025201803.3043712-1-lukas@czerner.cz>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case ext4_ext_swap_inode_data() fails it will clean up a failed
migration by freeing the extent tree in the tmp_inode. However, in
case we already copied the temporary inode's extent tree root into
the original inode, the process has been functionally finished.
The error case clean up calls free_ext_block() which will free those
extent tree blocks while the original inode already points at them and
the filesystem ends up with multiply claimed blocks.

Fix it by resetting the temporary inode's root to an empty tree right
after copying i_data to the original inode, so free_ext_block() won't
free the original inode extent tree blocks. Move temporary inode's
i_blocks as well so eviction won't try to truncate metadata blocks the
tmp_inode no longer owns.

Signed-off-by: Lukas Czerner <lukas@czerner.cz>
---
 fs/ext4/ext4.h    |  1 +
 fs/ext4/extents.c | 11 ++++++++++-
 fs/ext4/migrate.c | 13 ++++++++++++-
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1ee5733e2b31..915476d4d089 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3903,6 +3903,7 @@ struct ext4_extent;
  */
 #define EXT_MAX_BLOCKS	0xffffffff
 
+extern void ext4_ext_init_root(struct inode *inode);
 extern void ext4_ext_tree_init(handle_t *handle, struct inode *inode);
 extern int ext4_ext_index_trans_blocks(struct inode *inode, int extents);
 extern int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3bf0a6cdbec2..ada059f83295 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -869,7 +869,11 @@ ext4_ext_binsearch(struct inode *inode,
 
 }
 
-void ext4_ext_tree_init(handle_t *handle, struct inode *inode)
+/*
+ * Initialize the extent tree of inode. This only changes the in-memory
+ * inode, the caller has to mark the inode dirty.
+ */
+void ext4_ext_init_root(struct inode *inode)
 {
 	struct ext4_extent_header *eh;
 
@@ -879,6 +883,11 @@ void ext4_ext_tree_init(handle_t *handle, struct inode *inode)
 	eh->eh_magic = EXT4_EXT_MAGIC;
 	eh->eh_max = cpu_to_le16(ext4_ext_space_root(inode, 0));
 	eh->eh_generation = 0;
+}
+
+void ext4_ext_tree_init(handle_t *handle, struct inode *inode)
+{
+	ext4_ext_init_root(inode);
 	ext4_mark_inode_dirty(handle, inode);
 }
 
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 5d60ef10fe11..0d32cfa55785 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -322,6 +322,12 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
 	 */
 	ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
 	memcpy(ei->i_data, tmp_ei->i_data, sizeof(ei->i_data));
+	/*
+	 * The extent tree belongs to the inode now. Make tmp_inode's extent
+	 * tree empty, so that cleaning up tmp_inode can't free the tree
+	 * blocks, if we fail to finish the migration.
+	 */
+	ext4_ext_init_root(tmp_inode);
 
 	/*
 	 * Update i_blocks with the new blocks that got
@@ -331,10 +337,13 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
 	 * While converting to extents we need not
 	 * update the original inode i_blocks for extent blocks
 	 * via quota APIs. The quota update happened via tmp_inode already.
+	 * Clear tmp_inode i_blocks to avoid truncating original data blocks
+	 * in case we fail to finish the migration.
 	 */
 	spin_lock(&inode->i_lock);
 	inode->i_blocks += tmp_inode->i_blocks;
 	spin_unlock(&inode->i_lock);
+	tmp_inode->i_blocks = 0;
 	up_write(&EXT4_I(inode)->i_data_sem);
 
 	/*
@@ -561,7 +570,9 @@ int ext4_ext_migrate(struct inode *inode)
 		if (retval)
 			/*
 			 * if we fail to swap inode data free the extent
-			 * details of the tmp inode
+			 * details of the tmp inode.  If the tree was already
+			 * moved to the original inode, the tmp_inode has an
+			 * empty tree and there is nothing to free.
 			 */
 			free_ext_block(handle, tmp_inode);
 	}
-- 
2.56.0

