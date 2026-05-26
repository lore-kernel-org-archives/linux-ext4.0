Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB347409634;
	Tue, 26 May 2026 15:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779808169; cv=none; b=VaA3cPTF6pL0p5eo4P9JwwBdkpnty7DBShkefSqONWHDzNTHqGXifSp12hnLT4X4AdURqAmT0vUlp9TioSV1J6K4glyr8amQeFUjRaetv0X2II3LeT+f4VYs/C0+thuuINxMiv11IFsMHcwVwrn/SYNy5P3Q5CihkLWOEvKLlFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779808169; c=relaxed/simple;
	bh=e7wKMKr+HsU/JnqET2ePDgdpli5v5VhqWtSSBsarBiA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nbOJlpXopHcVfcnDLB9DTC6q5i/34l2YZ0ionJ2lK8NEiWRMBmiVN2j7fqTq4m85bujespxGlKMZXJGG+bJrk5nYC1jYtlkv3AuSk+WFmGuD1WtAW/1aKagz41hVvQs76XFtK6oOTOJ8cOcwWFAizHaY/8V8TcP6+CVG14yWt6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T3Q9oOFp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T3Q9oOFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A876A1F00A3A;
	Tue, 26 May 2026 15:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779808167;
	bh=MN6sCcOU8pQHv4qRImohzFWvar0iO7Uv/wwPJx7ADng=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=T3Q9oOFprFDt7vq8CDd4x6UlBpk+D7TcGch0tJJ9uFez6pmuwTZwOr5DzKnVyRQRO
	 7ibEspEBvcX9fZ6Nk437IJYN/qtfIhaf0slQLpKNWKzvg6u76ahSQtH/kRXk6az0jj
	 eheZ23uU8OWEQGPvKrJcoai3M5ctcx7odCu/53MSw7cpMjVuYeRxldIgHC/2XIOjxJ
	 YyKK61zzK2Oi1d98jHmE+Afw/3UQGQkuAyO0Ac0U5CVZKFIL4F/aG9UAeT6L4K8x4k
	 t1G8iv6hec5Ldvgy1Lks3MvgHEQW5beVQbfXDOAizBKjOdz7YPrwxUl7W5ePlM+dOA
	 hbd1PCTrSCP7w==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 26 May 2026 17:09:06 +0200
Subject: [PATCH 4/8] fs: retire sget()
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-work-sget-v1-4-263f7025cedd@kernel.org>
References: <20260526-work-sget-v1-0-263f7025cedd@kernel.org>
In-Reply-To: <20260526-work-sget-v1-0-263f7025cedd@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, 
 linux-cifs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-fffa9
X-Developer-Signature: v=1; a=openpgp-sha256; l=5936; i=brauner@kernel.org;
 h=from:subject:message-id; bh=e7wKMKr+HsU/JnqET2ePDgdpli5v5VhqWtSSBsarBiA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSJbp89jbNe+cHGp9XJ86pLOgX3hbBY7Xi5qT7aXi/Dp
 2ODb2Z8RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwER2tjAyzLX89r9I92PJneK6
 he1rV3x5duRnz+vlqadnHXc+0y7w+j/DP+Vrnl94VM0nqBhz3ef6Hyq1/La86cGHu3VeG8Vecmo
 IZAUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

sget() and sget_fc() have lived side by side as near-duplicate
find-or-create-and-publish helpers for the legacy and fs_context mount
APIs. The three remaining in-tree callers (CIFS plus the ext4 extents
and mballoc KUnit tests) have all been moved to sget_fc(). Nothing
calls sget() anymore.

Delete sget() from fs/super.c and the prototype in <linux/fs.h>.
Update the two comments that referred to "sget()" or "sget{_fc}()" to
just say "sget_fc()".

This removes ~60 lines of code that only existed to be kept in
lockstep with sget_fc() on every superblock publish-path change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/btrfs/super.c   |  2 +-
 fs/super.c         | 71 ++++--------------------------------------------------
 include/linux/fs.h |  4 ---
 3 files changed, 6 insertions(+), 71 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b26aa9169e83..636154861d7c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2052,7 +2052,7 @@ static int btrfs_get_tree_subvol(struct fs_context *fc)
 	 * then open_ctree will properly initialize the file system specific
 	 * settings later.  btrfs_init_fs_info initializes the static elements
 	 * of the fs_info (locks and such) to make cleanup easier if we find a
-	 * superblock with our given fs_devices later on at sget() time.
+	 * superblock with our given fs_devices later on at sget_fc() time.
 	 */
 	fs_info = kvzalloc_obj(struct btrfs_fs_info);
 	if (!fs_info)
diff --git a/fs/super.c b/fs/super.c
index 378e81efe643..5fe8cea9f8fe 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -328,7 +328,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
 	init_rwsem(&s->s_umount);
 	lockdep_set_class(&s->s_umount, &type->s_umount_key);
 	/*
-	 * sget() can have s_umount recursion.
+	 * sget_fc() can have s_umount recursion.
 	 *
 	 * When it cannot find a suitable sb, it allocates a new
 	 * one (this one), and tries again to find a suitable old
@@ -439,7 +439,7 @@ static void kill_super_notify(struct super_block *sb)
 
 	/*
 	 * Remove it from @fs_supers so it isn't found by new
-	 * sget{_fc}() walkers anymore. Any concurrent mounter still
+	 * sget_fc() walkers anymore. Any concurrent mounter still
 	 * managing to grab a temporary reference is guaranteed to
 	 * already see SB_DYING and will wait until we notify them about
 	 * SB_DEAD.
@@ -517,7 +517,7 @@ EXPORT_SYMBOL(deactivate_super);
  * @sb: superblock to acquire
  *
  * Acquire a temporary reference on a superblock and try to trade it for
- * an active reference. This is used in sget{_fc}() to wait for a
+ * an active reference. This is used in sget_fc() to wait for a
  * superblock to either become SB_BORN or for it to pass through
  * sb->kill() and be marked as SB_DEAD.
  *
@@ -673,11 +673,11 @@ void generic_shutdown_super(struct super_block *sb)
 	/*
 	 * Broadcast to everyone that grabbed a temporary reference to this
 	 * superblock before we removed it from @fs_supers that the superblock
-	 * is dying. Every walker of @fs_supers outside of sget{_fc}() will now
+	 * is dying. Every walker of @fs_supers outside of sget_fc() will now
 	 * discard this superblock and treat it as dead.
 	 *
 	 * We leave the superblock on @fs_supers so it can be found by
-	 * sget{_fc}() until we passed sb->kill_sb().
+	 * sget_fc() until we passed sb->kill_sb().
 	 */
 	super_wake(sb, SB_DYING);
 	super_unlock_excl(sb);
@@ -808,67 +808,6 @@ struct super_block *sget_fc(struct fs_context *fc,
 }
 EXPORT_SYMBOL(sget_fc);
 
-/**
- *	sget	-	find or create a superblock
- *	@type:	  filesystem type superblock should belong to
- *	@test:	  comparison callback
- *	@set:	  setup callback
- *	@flags:	  mount flags
- *	@data:	  argument to each of them
- */
-struct super_block *sget(struct file_system_type *type,
-			int (*test)(struct super_block *,void *),
-			int (*set)(struct super_block *,void *),
-			int flags,
-			void *data)
-{
-	struct user_namespace *user_ns = current_user_ns();
-	struct super_block *s = NULL;
-	struct super_block *old;
-	int err;
-
-retry:
-	spin_lock(&sb_lock);
-	if (test) {
-		hlist_for_each_entry(old, &type->fs_supers, s_instances) {
-			if (!test(old, data))
-				continue;
-			if (user_ns != old->s_user_ns) {
-				spin_unlock(&sb_lock);
-				destroy_unused_super(s);
-				return ERR_PTR(-EBUSY);
-			}
-			if (!grab_super(old))
-				goto retry;
-			destroy_unused_super(s);
-			return old;
-		}
-	}
-	if (!s) {
-		spin_unlock(&sb_lock);
-		s = alloc_super(type, flags, user_ns);
-		if (!s)
-			return ERR_PTR(-ENOMEM);
-		goto retry;
-	}
-
-	err = set(s, data);
-	if (err) {
-		spin_unlock(&sb_lock);
-		destroy_unused_super(s);
-		return ERR_PTR(err);
-	}
-	s->s_type = type;
-	strscpy(s->s_id, type->name, sizeof(s->s_id));
-	list_add_tail(&s->s_list, &super_blocks);
-	hlist_add_head(&s->s_instances, &type->fs_supers);
-	spin_unlock(&sb_lock);
-	get_filesystem(type);
-	shrinker_register(s->s_shrink);
-	return s;
-}
-EXPORT_SYMBOL(sget);
-
 void drop_super(struct super_block *sb)
 {
 	super_unlock_shared(sb);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 11559c513dfb..6dbe3218dc1e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2327,10 +2327,6 @@ void free_anon_bdev(dev_t);
 struct super_block *sget_fc(struct fs_context *fc,
 			    int (*test)(struct super_block *, struct fs_context *),
 			    int (*set)(struct super_block *, struct fs_context *));
-struct super_block *sget(struct file_system_type *type,
-			int (*test)(struct super_block *,void *),
-			int (*set)(struct super_block *,void *),
-			int flags, void *data);
 struct super_block *sget_dev(struct fs_context *fc, dev_t dev);
 
 /* Alas, no aliases. Too much hassle with bringing module.h everywhere */

-- 
2.47.3

