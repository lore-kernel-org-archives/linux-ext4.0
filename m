Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1DE3A3E7A
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2026 03:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784519116; cv=none; b=ee5ejuo3ZyWSDNASVMFJtJX2I32fBaLk33clw4kkaqwEy9GjPU6kqDgcBUBva6ca9w5MDm1/hmtCNr+y4fjAyNnLueEXT38HQZBGLscdFXEpK0LLF1fDIRw8NQqY4G1naMrZJMuDDJ0iTuL57DrH8v0gJXnpWs5/VJ270d1IinA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784519116; c=relaxed/simple;
	bh=wzN0YVdZG4939ITrQ+W0KMy/BS1wti0ibEnXT0SQJ2s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZKI6/EANDadJVCr7I24LvwW5tihZWJXRQB3DHCAtNXbHsD1am6yeIsoDoKSH6/rFPtEhYoJRT+i7tVfVTwoCD3KwxWMXPumaaJE+y3dj8pmkm6o6DG0Q+gcZb1Kh3vBXcL/G5Z5kP1VjkH0d/at/8WFp/XPcX7iBEoHd1sUS/EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R551u0+P; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R551u0+P"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so9211048a91.0
        for <linux-ext4@vger.kernel.org>; Sun, 19 Jul 2026 20:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784519114; x=1785123914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=n62LYm8YCwIq7ZXyolWDnoF5TAnP8kdA/1JGORZYpL0=;
        b=R551u0+Pre4du8o+qp8ToaiN18l1zWj3KST0rTlYO76nmQSISPiCneQakbqCpPsLQt
         7i8qFsQPOylKW3wnLs3HSkubHJBcH5aIm1yQzlVoj+fF8zA8BAurumIPoIWymDjU/lyf
         cQGyxVdrM4Zs9zN/smVyS5Kh5O3ZTGmGXAhSTN5S6baXbhDW14ttBohzbG+RuYyERvGu
         gNocZczsVLj8f3YYvalIrg85TpJGZ/Hvfp9IziyGz9GbAA6bu+vBTki/16MRY3ubf6P6
         zuSazGGPupkSpSgvSsUaF1Y6cyMeG0R/WjY+EBDiSrHU3pTMEbANgatDMA6OGCKF90FQ
         7TqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784519114; x=1785123914;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n62LYm8YCwIq7ZXyolWDnoF5TAnP8kdA/1JGORZYpL0=;
        b=jydquQvG9ZdVuiVkftwcH+X1Xz1rMO+3oItGD1Wl9Zt5zTMV5AIseuZgjXhJdBG+h2
         ELpZ9vMOxqtLn07cwZu5iOlsK1Kst36GyWVEDXfVRz0Dv4r6VSpAMd+AtJQPLYo12kzu
         Dt1TNPr2aqExY+ZZE7tGxZ9y6v3t6oNZmaAy7Ry8tgBAJcB5i8BJBgZlyII1vzgpM+IC
         5HgbhnjnfvK71FyJ1Q641k90yHLHwipyAoEms22540VRO5Gae58SCIYtGAs6huSp94jt
         dZBlZYX4jwGQkOPYFFNl8Du0EmrIOwdZMOShnDnU9H/jb981q02VRiqZZukIHyZQIrEs
         O1dw==
X-Gm-Message-State: AOJu0YwZA15JGKmdaIIqH9UwGrldN4q6jEZM7tAOy6+ibibvBnzfSDxd
	BrEiFPgFBf9yrHv+XOGgTylXYucYNiIfnO1qoPfIdK6wu0JhbrrQI8CN
X-Gm-Gg: AfdE7cmNnb9yRzXDkRFUDjkRUXeVmtP6AAjIcY8doB2VUqHeDVOvTUJU22iYS4yVbQt
	OMwD0n4AH4mx1naGp1kMDsQnEvC2owJZxmW93xFaXBxiunrETInmHoQciJRIntig4qido+KNnen
	TMoSiW7O0C5iPyUE5N2SsJVYIbSzLODZ0eOUHWjKi/hpFuqktsrf/s9R6re5lEp94kvJmwc7dMx
	IgKjoijcrCuImuXehdLPz53DquIlRz9Vt2zWgVHaMd0fiXdze/UWChfeljSEgKIYrY/6BqozNDt
	dqQO6Uz54dgKzHseX3xBLzHet6DjEAZ9mf1vg7l0mRo2/10DQ1nALmM0ZPEv5GtBNfZ1U8JBJ9p
	WwINKXtgUXAZ4vBKsq5fvIGjOIsNQ84U/HL1UTX0COx5n1SNU8l3ylUPbYwO726NZEM6dfCEJ4D
	tHWA==
X-Received: by 2002:a05:6a21:4c0e:b0:3c3:89cf:f43 with SMTP id adf61e73a8af0-3c3ad7aa401mr13219211637.30.1784519113838;
        Sun, 19 Jul 2026 20:45:13 -0700 (PDT)
Received: from tradnomic.. ([2601:646:8300:7570:f139:f861:e318:4f58])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a20b037sm32893792eec.27.2026.07.19.20.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 20:45:13 -0700 (PDT)
From: rafad900 <rafad900@gmail.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rafad900 <rafad900@gmail.com>
Subject: [PATCH] ext4: convert pa_count from atomic_t to refcount_t
Date: Sun, 19 Jul 2026 20:44:41 -0700
Message-ID: <20260720034441.3900050-1-rafad900@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The pa_count field in struct ext4_prealloc_space is
reference counter for preallocation descriptors.
Converting it from atomic_t to refcount_t provides
underflow and overflow protection.

This was found using Coccinelle script
atomic_as_refcounter.cocci

Testing was done on a QEMU x86 VM revealing a
pre-existing race condition leading to a
use-after-free.

Signed-off-by: rafad900 <rafad900@gmail.com>
---
 fs/ext4/mballoc.c | 22 +++++++++++-----------
 fs/ext4/mballoc.h |  2 +-
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ed1bd00e11cd..59b3d4abaab0 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4823,7 +4823,7 @@ ext4_mb_check_group_pa(ext4_fsblk_t goal_block,
 	ext4_fsblk_t cur_distance, new_distance;
 
 	if (cpa == NULL) {
-		atomic_inc(&pa->pa_count);
+		refcount_inc(&pa->pa_count);
 		return pa;
 	}
 	cur_distance = abs(goal_block - cpa->pa_pstart);
@@ -4833,8 +4833,8 @@ ext4_mb_check_group_pa(ext4_fsblk_t goal_block,
 		return cpa;
 
 	/* drop the previous reference */
-	atomic_dec(&cpa->pa_count);
-	atomic_inc(&pa->pa_count);
+	refcount_dec(&cpa->pa_count);
+	refcount_inc(&pa->pa_count);
 	return pa;
 }
 
@@ -4993,7 +4993,7 @@ ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 	}
 
 	if (tmp_pa->pa_free && likely(ext4_mb_pa_goal_check(ac, tmp_pa))) {
-		atomic_inc(&tmp_pa->pa_count);
+		refcount_inc(&tmp_pa->pa_count);
 		ext4_mb_use_inode_pa(ac, tmp_pa);
 		spin_unlock(&tmp_pa->pa_lock);
 		read_unlock(&ei->i_prealloc_lock);
@@ -5139,7 +5139,7 @@ static void ext4_mb_mark_pa_deleted(struct super_block *sb,
 static inline void ext4_mb_pa_free(struct ext4_prealloc_space *pa)
 {
 	BUG_ON(!pa);
-	BUG_ON(atomic_read(&pa->pa_count));
+	BUG_ON(refcount_read(&pa->pa_count));
 	BUG_ON(pa->pa_deleted == 0);
 	kmem_cache_free(ext4_pspace_cachep, pa);
 }
@@ -5165,7 +5165,7 @@ static void ext4_mb_put_pa(struct ext4_allocation_context *ac,
 
 	/* in this short window concurrent discard can set pa_deleted */
 	spin_lock(&pa->pa_lock);
-	if (!atomic_dec_and_test(&pa->pa_count) || pa->pa_free != 0) {
+	if (!refcount_dec_and_test(&pa->pa_count) || pa->pa_free != 0) {
 		spin_unlock(&pa->pa_lock);
 		return;
 	}
@@ -5535,7 +5535,7 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
 	list_for_each_entry_safe(pa, tmp,
 				&grp->bb_prealloc_list, pa_group_list) {
 		spin_lock(&pa->pa_lock);
-		if (atomic_read(&pa->pa_count)) {
+		if (refcount_read(&pa->pa_count)) {
 			spin_unlock(&pa->pa_lock);
 			*busy = 1;
 			continue;
@@ -5637,7 +5637,7 @@ void ext4_discard_preallocations(struct inode *inode)
 		BUG_ON(pa->pa_node_lock.inode_lock != &ei->i_prealloc_lock);
 
 		spin_lock(&pa->pa_lock);
-		if (atomic_read(&pa->pa_count)) {
+		if (refcount_read(&pa->pa_count)) {
 			/* this shouldn't happen often - nobody should
 			 * use preallocation while we're discarding it */
 			spin_unlock(&pa->pa_lock);
@@ -5720,7 +5720,7 @@ static int ext4_mb_pa_alloc(struct ext4_allocation_context *ac)
 	pa = kmem_cache_zalloc(ext4_pspace_cachep, GFP_NOFS);
 	if (!pa)
 		return -ENOMEM;
-	atomic_set(&pa->pa_count, 1);
+	refcount_set(&pa->pa_count, 1);
 	ac->ac_pa = pa;
 	return 0;
 }
@@ -5731,7 +5731,7 @@ static void ext4_mb_pa_put_free(struct ext4_allocation_context *ac)
 
 	BUG_ON(!pa);
 	ac->ac_pa = NULL;
-	WARN_ON(!atomic_dec_and_test(&pa->pa_count));
+	WARN_ON(!refcount_dec_and_test(&pa->pa_count));
 	/*
 	 * current function is only called due to an error or due to
 	 * len of found blocks < len of requested blocks hence the PA has not
@@ -5948,7 +5948,7 @@ ext4_mb_discard_lg_preallocations(struct super_block *sb,
 				pa_node.lg_list,
 				lockdep_is_held(&lg->lg_prealloc_lock)) {
 		spin_lock(&pa->pa_lock);
-		if (atomic_read(&pa->pa_count)) {
+		if (refcount_read(&pa->pa_count)) {
 			/*
 			 * This is the pa that we just used
 			 * for block allocation. So don't
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 39333ce72cbd..f708d303228e 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -126,7 +126,7 @@ struct ext4_prealloc_space {
 		struct rcu_head	pa_rcu;
 	} u;
 	spinlock_t		pa_lock;
-	atomic_t		pa_count;
+	refcount_t		pa_count;
 	unsigned		pa_deleted;
 	ext4_fsblk_t		pa_pstart;	/* phys. block */
 	ext4_lblk_t		pa_lstart;	/* log. block */
-- 
2.43.0

