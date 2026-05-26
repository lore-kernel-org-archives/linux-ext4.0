Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E867B409639;
	Tue, 26 May 2026 15:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779808174; cv=none; b=fOywqXHY+w+41ssOBxw8VUufgeG+oVHgPYMHSK5IgnpOPDwOd0tdiSOmnYKaMgVQFUt4oESxlQiXhh5zP1rSbm+dFoYptVVofAhsvS3QvPkqT4MBJAGZXBmU5KEm3JQig7U+389vjQ0RMofX26Kcd0bvkeIjKzmIeQS8qofC6vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779808174; c=relaxed/simple;
	bh=r9IPhTb1VSrKZy8nlyrjm8fNViLs/xyLlgVPkbr9O0s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fkCOe2ReJtxY/ECNXuEY35w6d0QIc0XgfquO3e+rii/Yrz8LRMkZmFPC538AKIqXNdYBvNN+7zO+oT71HyfVAmj3hrWt+ZjDRwfGuS+NYBGiYwx3IrV1dgWCimpJrnUW4757hGWyuMJMt4+UfcoPDjaV+x0YZDJy3Lobzd2SIlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hnm2t70v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hnm2t70v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EEE91F00A3D;
	Tue, 26 May 2026 15:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779808172;
	bh=Ezymggp0OTj4QOeQMwXIZkfOw9k4QgKIXLViQJQX6m0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hnm2t70vs6lpJ9wCYlGP6ZrJBq3C0zgE5DHY21DldiK63LUkiClU02EdzoniA2lp9
	 TCJrzQGqcZHs5QeuidzyLsAYXLx28l0kCGG7SgoGcNvJIEcY2Oiczgmt47ofZ2oWL2
	 NFueZo09xSX1ssrc0mw5rFtISyn8ymJxpiUln/SbnBOW8QvMjDf7s41bTGxSf1jmzO
	 DNwkrQ4FPhHs/1hN6fk2qvAFiwkH/op7L5waNMV2bOiZUOyXikUmD1l708rnYke4iz
	 fE21UeUI4QXLq7KbBOuTTIT7aMilmVW/99DbZZM723MRjG2YiUPf54fKudmRyv1Grr
	 riKg3MHMBW0Jw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 26 May 2026 17:09:08 +0200
Subject: [PATCH 6/8] super: convert sb->s_count to refcount_t
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-work-sget-v1-6-263f7025cedd@kernel.org>
References: <20260526-work-sget-v1-0-263f7025cedd@kernel.org>
In-Reply-To: <20260526-work-sget-v1-0-263f7025cedd@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, 
 linux-cifs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-fffa9
X-Developer-Signature: v=1; a=openpgp-sha256; l=3719; i=brauner@kernel.org;
 h=from:subject:message-id; bh=r9IPhTb1VSrKZy8nlyrjm8fNViLs/xyLlgVPkbr9O0s=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSJbp/9zfpNvKN5QkVFksOqk9o71pzujqib/33emt2Sa
 w3vfD74rKOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiU3sZ/ko2THnw3vPgjzlr
 47X0WNtubf95wPJr/qaHz3YlzInIvZvMyNCzad9TU9vfN+fu3/Ema9Ozz0efxcwX2/eno2ZXHct
 Fwd38AA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

s_count is the temporary-reference count used to pin a superblock
across the spinlock-to-rwsem hop in every iterator and in
grab_super(). It's a plain int incremented and decremented only under
sb_lock.

Convert it to refcount_t. No semantic change yet: every increment
still happens with sb_lock held, so observation of a live ref is
still serialised by the lock. The increments use refcount_inc()
rather than refcount_inc_not_zero() because every callsite is still
looking at an sb known to be live under sb_lock.

This prepares the ground for switching iterators to RCU readers in a
later patch, at which point refcount_inc_not_zero() becomes the right
primitive at the lockless pin sites.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/super.c                     | 14 +++++++-------
 include/linux/fs/super_types.h |  3 ++-
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index c451f689c7b3..2fa7023010ec 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -366,7 +366,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
 	spin_lock_init(&s->s_inode_wblist_lock);
 	fserror_mount(s);
 
-	s->s_count = 1;
+	refcount_set(&s->s_count, 1);
 	atomic_set(&s->s_active, 1);
 	mutex_init(&s->s_vfs_rename_mutex);
 	lockdep_set_class(&s->s_vfs_rename_mutex, &type->s_vfs_rename_key);
@@ -406,7 +406,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
  */
 static void __put_super(struct super_block *s)
 {
-	if (!--s->s_count) {
+	if (refcount_dec_and_test(&s->s_count)) {
 		list_del_init(&s->s_list);
 		WARN_ON(s->s_dentry_lru.node);
 		WARN_ON(s->s_inode_lru.node);
@@ -528,7 +528,7 @@ static bool grab_super(struct super_block *sb)
 {
 	bool locked;
 
-	sb->s_count++;
+	refcount_inc(&sb->s_count);
 	spin_unlock(&sb_lock);
 	locked = super_lock_excl(sb);
 	if (locked) {
@@ -857,7 +857,7 @@ static void __iterate_supers(void (*f)(struct super_block *, void *), void *arg,
 	     sb = next_super(sb, flags)) {
 		if (super_flags(sb, SB_DYING))
 			continue;
-		sb->s_count++;
+		refcount_inc(&sb->s_count);
 		spin_unlock(&sb_lock);
 
 		if (flags & SUPER_ITER_UNLOCKED) {
@@ -902,7 +902,7 @@ void iterate_supers_type(struct file_system_type *type,
 		if (super_flags(sb, SB_DYING))
 			continue;
 
-		sb->s_count++;
+		refcount_inc(&sb->s_count);
 		spin_unlock(&sb_lock);
 
 		locked = super_lock_shared(sb);
@@ -934,7 +934,7 @@ struct super_block *user_get_super(dev_t dev, bool excl)
 		if (sb->s_dev != dev)
 			continue;
 
-		sb->s_count++;
+		refcount_inc(&sb->s_count);
 		spin_unlock(&sb_lock);
 
 		locked = super_lock(sb, excl);
@@ -1368,7 +1368,7 @@ static struct super_block *bdev_super_lock(struct block_device *bdev, bool excl)
 
 	/* Make sure sb doesn't go away from under us */
 	spin_lock(&sb_lock);
-	sb->s_count++;
+	refcount_inc(&sb->s_count);
 	spin_unlock(&sb_lock);
 
 	mutex_unlock(&bdev->bd_holder_lock);
diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
index 383050e7fdf5..3a8cc0c723a8 100644
--- a/include/linux/fs/super_types.h
+++ b/include/linux/fs/super_types.h
@@ -11,6 +11,7 @@
 #include <linux/uidgid.h>
 #include <linux/uuid.h>
 #include <linux/percpu-rwsem.h>
+#include <linux/refcount.h>
 #include <linux/workqueue_types.h>
 #include <linux/quota.h>
 
@@ -145,7 +146,7 @@ struct super_block {
 	unsigned long				s_magic;
 	struct dentry				*s_root;
 	struct rw_semaphore			s_umount;
-	int					s_count;
+	refcount_t				s_count;
 	atomic_t				s_active;
 #ifdef CONFIG_SECURITY
 	void					*s_security;

-- 
2.47.3

