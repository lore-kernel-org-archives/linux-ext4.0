Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794401575;
	b=HuTidgxqjqe2KtOq76+GW6dM2Cmf1SBu4QOOVZbt/s3QaM2ONhRjJ6YyNi7Kz4Tn7egJ
	 BCAiCM9bSk5ljN2Pso6CHsind+q0E30A0wcC07jnAHdFJg8LAiNhqtzLrxA1Ga9Icq3ms
	 t921ejCc8OPTP5oWyvkTAxmnwGgMycF/4jqFtszb7S4AqPnuCJDY44GJEfscQyB4i+Mtd
	 niQ97eToy2mHh0i84JQzyzvXVpWCFwDexpc3MzIVMxuhThAsbxVlrYl7fh8ZdaiwyW5R6
	 Vk20Mn7GWZUiiI6Ips7auMEx7EEgMZNEgflbrNO7wWLJGMvmhKN01gPA5TVVOsL6d0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794401575;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mjSax9Scw9JbRi4irnRJ6sjYTX5W3TTH23xySR7QQ9s=;
	b=g4AqJ9BKWvIG2k3TDG0AuT+/XjpCTDOnp/7cveDo2gG97TwyjXXzrXSReEJen3Rsv8Ur
	 vLHIF/AP4H3e/CXqS47vlCTzQv4KYjHQvFkGyoiYhLT0JkgWYm+snLnNhTBLKKBH3rkly
	 ymNfr7elEnYRkeW7GK4tEdeExhvryARZ1yvV0O+6YkAuxparCXonPkDsuUZ8MVHmqkP0+
	 7lWgCZvcy3pMlTyNKMjF0S+7D5x4qerKXhpp5deGimkKMVYExjsNrdecpTOcMjv615k0B
	 of1HhMUda4OfkbohcjhIyj0DOG4wUW1/0W7jbAH1euKvytddedOgcj5SXJ1PD89TJTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=JnpLYkVb;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCFD606A324
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 12:52:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BFCFD606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=JnpLYkVb
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a5087a5348so27352575e9.0
        for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 04:52:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1794401573; x=1795006373; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mjSax9Scw9JbRi4irnRJ6sjYTX5W3TTH23xySR7QQ9s=;
        b=JnpLYkVbBbP2dGJd7xU9CvXyRDYjxTTdbqcuqotKrJ8wS0+//Z8mjkAbVRVn/yTCO0
         wkeVYIMS9c9bp84vC8ZjfYaSB0WyJbV0s/b+t56oEuxbAayNC3Hn3MatfvkORJZdvwEH
         jObnWLoQOEiPY5q1HG7T/RfgEmUFfPXP0jjfiSZXSqY+/demYdCAjTkGWwrJG84HJzGJ
         FB64uzVhLgwkbh3kgulV2XKufwrvK1DErARc/ebmeZXsIsxiWWMphk9JY1E1Xkqpt8Z3
         PVkF3Lxkks7ehaMrahq4GxxJhcm+yZ8kk/DruI7LC3ImXeNGJCs0efLJY7VlIROS9/Ix
         /i8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794401573; x=1795006373;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mjSax9Scw9JbRi4irnRJ6sjYTX5W3TTH23xySR7QQ9s=;
        b=QZFuIL6nR/bvADgWa0yMiVy7THPtV3fY4p1BMIh8qzhMNZeqVyJC2qXCRdoDTgjQEO
         R6Ir5BT+cH/+P0I5eS5x+pvg2Wdg0N0O4a9QIua1CKL5kPoIheq832AffIaYBgRZbLb0
         xAOrQ3unOfdstUcOa1hjOCrwnUi5VQvk6s8GeG14i1M3KSkQPgD9T5YzNnvoVBxa6+AO
         6QpBvagA+NmgibpDak9iO1aNLX5/QheMy+ept3uipQvTT7MvvrWpQNKKmFU71J6gsL1/
         rOMTZmHiUsyekxU9BFo0qYas0+D+1fb8SZl+nc6fKm+QNQ3jKoya4CI5dPn42sS0rfoY
         25uA==
X-Forwarded-Encrypted: i=1; AL+hErF085zBibvwCmUn0zK1X4F9Jq5q2rnHePCOufg0ijPOfZc/x3Fr7zjy5gmkulcDuHfNgV/PByRLCEVb@vger.kernel.org
X-Gm-Message-State: APuU4Z+4d3eNk24fifKO5573DVmlxuZLBwffCWaOhDVb7PovfcuXwmmu
	HfbjckOl4PAY+qo4/Zld8BFfbI9ilcTOfOWnc+KA3vvLUNAG6KpQUSZfT8D+7aw4Tcg=
X-Gm-Gg: AYBFou3nza1eMK/h/CvIxdRQs0HDssiughae76LmEUlSVdiJI4Kr0tei8Y0uD7zuBhC
	3JnxjLSBEwXnkzZ5f2t7k25vcw8HJxNItU8vJYIel+0oNeI36GuE+YqV9Q/BhnIlQOzSERu7jOK
	AhAVlbMHmKtrupxJlLd8QS6eS3oHtq5sTe1yZH4OXJhMz9alrekC24lNbG8xuHIXCLlEP/aPwa4
	cY4VdNcIFWH1brJcVGsiTH5nY6pY4Igl33a4qlhUFwsYoI+u3aRzFX9cAXWM2nZ22xnoY9HRY3S
	vVFrQTRAQAk5HXtbt8QxzCXcN0++uGkc+HWJ5/iWtttgg+I564Shryj7mJBLFIU9ceUoomA1Gk1
	DNADs7lAhBdrbCXEZc52CS+23KZotGTRt/U/SMJ3UpnrxHi3uEicWE6dPPNYms3mWXi5Yokid4f
	4BlVE4OydBzQGZxtEfuJdvmkjhB4MyMibUrcGhw7Gx/X7x/OpZ5Rjdr2M9NKnbZcZsJoqZAaBSY
	Ljc0h1GsZ4edJyLXFLHv2MOzff4stQp7pia5k6ZxIHDeNY8wO6Do8OSD12TKI1hRKsPTLRqguzZ
	sdB32Yw7itBdN2y+bvw/LlPBeJxZ2CvjG7XS3jh/Cp/ySJ0ubfcV+AvP0DdDu71yIryLSN4XreH
	OwAs2jsUtuz/IpQEakGWMy1vVCH1jxw==
X-Received: by 2002:a05:600c:8708:b0:4a7:c366:d791 with SMTP id 5b1f17b1804b1-4ba0931c364mr38104595e9.1.1794401573077;
        Wed, 11 Nov 2026 04:52:53 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f4cbe00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f4c:be00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba020433casm132712185e9.7.2026.11.11.04.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 04:52:52 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 2/3] ext4: make bigalloc support optional
Date: Wed, 11 Nov 2026 13:52:41 +0100
Message-ID: <20261111125242.1078620-3-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261111125242.1078620-1-max.kellermann@ionos.com>
References: <20261111125242.1078620-1-max.kellermann@ionos.com>
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

Add CONFIG_EXT4_FS_BIGALLOC, enabled by default.  Disabling it omits
pending cluster reservation tracking and saves 8 bytes per inode.

Reject bigalloc filesystems before journal recovery, including on
read-only mounts.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 Documentation/filesystems/ext4/bigalloc.rst |  6 +++
 fs/ext4/Kconfig                             | 15 +++++++
 fs/ext4/ext4.h                              |  2 +
 fs/ext4/extents_status.c                    | 44 +++++++++++++++++++--
 fs/ext4/extents_status.h                    | 15 +++++++
 fs/ext4/super.c                             | 10 +++++
 6 files changed, 89 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/ext4/bigalloc.rst b/Documentation/filesystems/ext4/bigalloc.rst
index 976a180b209c..51aee018ec6d 100644
--- a/Documentation/filesystems/ext4/bigalloc.rst
+++ b/Documentation/filesystems/ext4/bigalloc.rst
@@ -3,6 +3,12 @@
 Bigalloc
 --------
 
+Bigalloc support is enabled by default with ``CONFIG_EXT4_FS_BIGALLOC``.
+Disabling this option removes the per-inode pending cluster reservation
+tree and its tracking code. Such kernels reject filesystems with the
+``bigalloc`` feature, including read-only mounts, before journal recovery.
+Filesystems without this feature remain supported.
+
 At the moment, the default size of a block is 4KiB, which is a commonly
 supported page size on most MMU-capable hardware. This is fortunate, as
 ext4 code is not prepared to handle the case where the block size
diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 0f3e702cd5e1..518bd68ed167 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -43,6 +43,21 @@ config EXT4_USE_FOR_EXT2
 	  compiled kernel size by using one file system driver for
 	  ext2, ext3, and ext4 file systems.
 
+config EXT4_FS_BIGALLOC
+	bool "Ext4 bigalloc support"
+	depends on EXT4_FS
+	default y
+	help
+	  Support filesystems with the bigalloc feature, which allocate space
+	  in clusters of multiple blocks to reduce allocation overhead for
+	  large files.
+
+	  Say N to omit pending cluster reservation tracking and reduce memory
+	  usage per inode. Filesystems with the bigalloc feature cannot be
+	  mounted, including read-only mounts, when this option is disabled.
+
+	  If unsure, say Y.
+
 config EXT4_FS_FAST_COMMIT
 	bool "Ext4 fast commit support"
 	depends on EXT4_FS
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1aedbfbcb101..c2c242f60700 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1194,8 +1194,10 @@ struct ext4_inode_info {
 	/* ialloc */
 	ext4_group_t	i_last_alloc_group;
 
+#ifdef CONFIG_EXT4_FS_BIGALLOC
 	/* pending cluster reservations for bigalloc file systems */
 	struct ext4_pending_tree i_pending_tree;
+#endif
 
 	/* on-disk additional length */
 	__u16 i_extra_isize;
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 018b6146b9d8..68630b32720c 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -174,7 +174,9 @@
  */
 
 static struct kmem_cache *ext4_es_cachep;
+#ifdef CONFIG_EXT4_FS_BIGALLOC
 static struct kmem_cache *ext4_pending_cachep;
+#endif
 
 static int __es_insert_extent(struct inode *inode, struct extent_status *newes,
 			      struct extent_status *prealloc);
@@ -185,9 +187,18 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 static int es_reclaim_extents(struct ext4_inode_info *ei, int *nr_to_scan);
 static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
 		       struct ext4_inode_info *locked_ei);
+#ifdef CONFIG_EXT4_FS_BIGALLOC
 static int __revise_pending(struct inode *inode, ext4_lblk_t lblk,
 			    ext4_lblk_t len,
 			    struct pending_reservation **prealloc);
+#else
+static inline int __revise_pending(struct inode *inode, ext4_lblk_t lblk,
+				   ext4_lblk_t len,
+				   struct pending_reservation **prealloc)
+{
+	return 0;
+}
+#endif
 
 int __init ext4_init_es(void)
 {
@@ -506,6 +517,7 @@ static void ext4_es_list_del(struct inode *inode)
 	spin_unlock(&sbi->s_es_lock);
 }
 
+#ifdef CONFIG_EXT4_FS_BIGALLOC
 static inline struct pending_reservation *__alloc_pending(bool nofail)
 {
 	if (!nofail)
@@ -518,6 +530,14 @@ static inline void __free_pending(struct pending_reservation *pr)
 {
 	kmem_cache_free(ext4_pending_cachep, pr);
 }
+#else
+static inline struct pending_reservation *__alloc_pending(bool nofail)
+{
+	return NULL;
+}
+
+static inline void __free_pending(struct pending_reservation *pr) {}
+#endif
 
 /*
  * Returns true if we cannot fail to allocate memory for this extent_status
@@ -934,7 +954,8 @@ void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 
 	ext4_es_insert_extent_check(inode, &newes);
 
-	revise_pending = sbi->s_cluster_ratio > 1 &&
+	revise_pending = IS_ENABLED(CONFIG_EXT4_FS_BIGALLOC) &&
+			 sbi->s_cluster_ratio > 1 &&
 			 test_opt(inode->i_sb, DELALLOC) &&
 			 (status & (EXTENT_STATUS_WRITTEN |
 				    EXTENT_STATUS_UNWRITTEN));
@@ -1197,7 +1218,7 @@ static void init_rsvd(struct inode *inode, ext4_lblk_t lblk,
 	 * the region to be removed, if any, and note that there's no partial
 	 * cluster to track
 	 */
-	if (sbi->s_cluster_ratio > 1) {
+	if (IS_ENABLED(CONFIG_EXT4_FS_BIGALLOC) && sbi->s_cluster_ratio > 1) {
 		rc->first_do_lblk_found = false;
 		if (lblk > es->es_lblk) {
 			rc->left_es = es;
@@ -1235,7 +1256,7 @@ static void count_rsvd(struct inode *inode, ext4_lblk_t lblk, long len,
 
 	WARN_ON(len <= 0);
 
-	if (sbi->s_cluster_ratio == 1) {
+	if (!IS_ENABLED(CONFIG_EXT4_FS_BIGALLOC) || sbi->s_cluster_ratio == 1) {
 		rc->ndelayed += (int) len;
 		return;
 	}
@@ -1296,6 +1317,7 @@ static void count_rsvd(struct inode *inode, ext4_lblk_t lblk, long len,
 	}
 }
 
+#ifdef CONFIG_EXT4_FS_BIGALLOC
 /*
  * __pr_tree_search - search for a pending cluster reservation
  *
@@ -1330,6 +1352,7 @@ static struct pending_reservation *__pr_tree_search(struct rb_root *root,
 	}
 	return NULL;
 }
+#endif
 
 /*
  * get_rsvd - calculates and returns the number of cluster reservations to be
@@ -1350,6 +1373,7 @@ static unsigned int get_rsvd(struct inode *inode, ext4_lblk_t end,
 			     struct extent_status *right_es,
 			     struct rsvd_count *rc)
 {
+#ifdef CONFIG_EXT4_FS_BIGALLOC
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	struct pending_reservation *pr;
 	struct ext4_pending_tree *tree = &EXT4_I(inode)->i_pending_tree;
@@ -1457,6 +1481,7 @@ static unsigned int get_rsvd(struct inode *inode, ext4_lblk_t end,
 			}
 		}
 	}
+#endif
 	return rc->ndelayed;
 }
 
@@ -1996,6 +2021,7 @@ void ext4_clear_inode_es(struct inode *inode)
 	write_unlock(&ei->i_es_lock);
 }
 
+#ifdef CONFIG_EXT4_FS_BIGALLOC
 #ifdef ES_DEBUG__
 static void ext4_print_pending_tree(struct inode *inode)
 {
@@ -2188,6 +2214,16 @@ bool ext4_is_pending(struct inode *inode, ext4_lblk_t lblk)
 	return ret;
 }
 
+#else
+#define ext4_print_pending_tree(inode)
+
+static inline int __insert_pending(struct inode *inode, ext4_lblk_t lblk,
+				   struct pending_reservation **prealloc)
+{
+	return 0;
+}
+#endif
+
 /*
  * ext4_es_insert_delayed_extent - adds some delayed blocks to the extents
  *                                 status tree, adding a pending reservation
@@ -2297,6 +2333,7 @@ void ext4_es_insert_delayed_extent(struct inode *inode, ext4_lblk_t lblk,
 	return;
 }
 
+#ifdef CONFIG_EXT4_FS_BIGALLOC
 /*
  * __revise_pending - makes, cancels, or leaves unchanged pending cluster
  *                    reservations for a specified block range depending
@@ -2395,3 +2432,4 @@ static int __revise_pending(struct inode *inode, ext4_lblk_t lblk,
 out:
 	return (ret < 0) ? ret : pendings;
 }
+#endif /* CONFIG_EXT4_FS_BIGALLOC */
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index 01cddcaaa68e..67d5059061a4 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -242,11 +242,26 @@ extern void ext4_es_destroy_stats(struct ext4_sb_info *sbi);
 
 extern int ext4_seq_es_shrinker_info_show(struct seq_file *seq, void *v);
 
+#ifdef CONFIG_EXT4_FS_BIGALLOC
 extern int __init ext4_init_pending(void);
 extern void ext4_exit_pending(void);
 extern void ext4_init_pending_tree(struct ext4_pending_tree *tree);
 extern void ext4_remove_pending(struct inode *inode, ext4_lblk_t lblk);
 extern bool ext4_is_pending(struct inode *inode, ext4_lblk_t lblk);
+#else
+static inline int ext4_init_pending(void)
+{
+	return 0;
+}
+
+static inline void ext4_exit_pending(void) {}
+static inline void ext4_remove_pending(struct inode *inode, ext4_lblk_t lblk) {}
+static inline bool ext4_is_pending(struct inode *inode, ext4_lblk_t lblk)
+{
+	return false;
+}
+#endif
+
 extern void ext4_es_insert_delayed_extent(struct inode *inode, ext4_lblk_t lblk,
 					  ext4_lblk_t len, bool lclu_allocated,
 					  bool end_allocated);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index aced1a67a554..a319077fb3ec 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1438,7 +1438,9 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei->i_es_seq = 0;
 	ei->i_reserved_data_blocks = 0;
 	spin_lock_init(&(ei->i_block_reservation_lock));
+#ifdef CONFIG_EXT4_FS_BIGALLOC
 	ext4_init_pending_tree(&ei->i_pending_tree);
+#endif
 #ifdef CONFIG_QUOTA
 	ei->i_reserved_quota = 0;
 	memset(&ei->i_dquot, 0, sizeof(ei->i_dquot));
@@ -3698,6 +3700,14 @@ int ext4_feature_set_ok(struct super_block *sb, int readonly)
 		return 0;
 	}
 
+	/* Read-only mounts can still replay the journal. */
+	if (!IS_ENABLED(CONFIG_EXT4_FS_BIGALLOC) &&
+	    ext4_has_feature_bigalloc(sb)) {
+		ext4_msg(sb, KERN_ERR,
+			 "Filesystem with bigalloc feature cannot be mounted without CONFIG_EXT4_FS_BIGALLOC");
+		return 0;
+	}
+
 	if (readonly)
 		return 1;
 
-- 
2.53.0

