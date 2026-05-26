Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7C0403E93;
	Tue, 26 May 2026 15:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779808178; cv=none; b=uVZAocdq8OhhC1BgPUj8EpRxLE6LRY/R6wIo2yf2tjKKDavh1Q73zv4ZDbTdNSKzlOnvQ/BLjd4WHaDsCwoEexOkHevcsvMFXS0K6+ecjjcpyUVT6I9dblNvor9XmXuEdBE+cAzfBlPs50Hiw7EkTYu33h/jBQf7WZLJ3zdWVeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779808178; c=relaxed/simple;
	bh=Pm/3nYKji1k7vkWEne2WpXcwxjzW9fiBWyC9hAh/ehc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UGt33DP1w6R5qzOJGkvdxUVhXhLUdZZfEeJ9X0mkqgM4v6M9/E+nklfcOrg71Gcg0M0b5xnbppzukr/HQ+H6lMJaHTwnUZ94qOgph7HvUzi92hRnBgJSXGhgzaToiBrVSnVAiR/ib4ETk9MbgoEYbU0x6mibOQp3+8Gbm70Dspo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=osFPn8kX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="osFPn8kX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977231F00A3A;
	Tue, 26 May 2026 15:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779808177;
	bh=OYYZcK1TdwY85DshlEc6tQLHPx/HC7Fyn1GnzZvcskg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=osFPn8kXSAj0eBm37CBh3Y8xGzKeW0q4ByXhpEUN0JUe+U90C3AMShoRVVdALQygA
	 4DGBq9XmG0Xi5h5417AaNg1d0IBICsvadFe3aZEM70tzhr+tHp4sq61K8VkwsJfzRJ
	 /yRVA2n0ilRmzUKQ9Cg833C8SsW5ugSWaPce9Hj8VSZ6HBTScISq03HtYkalb3DW1a
	 GlEMCBDVnZb9OMgueihTbSebPhvNG7iVuWH8QR8bHuBqGww4/xg9O81LBkTUKYQNdt
	 do0/t5CVRO28TgQn6IVoXvZlzP41ja1h2aXRO24LwFLL4f5STNbpV34lnAWgIYGJ3j
	 l6jiYpnaAGu5w==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 26 May 2026 17:09:10 +0200
Subject: [PATCH 8/8] super: convert iterators to RCU readers +
 refcount_inc_not_zero
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-work-sget-v1-8-263f7025cedd@kernel.org>
References: <20260526-work-sget-v1-0-263f7025cedd@kernel.org>
In-Reply-To: <20260526-work-sget-v1-0-263f7025cedd@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, 
 linux-cifs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-fffa9
X-Developer-Signature: v=1; a=openpgp-sha256; l=6639; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Pm/3nYKji1k7vkWEne2WpXcwxjzW9fiBWyC9hAh/ehc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSJbp/9o2PbYtNrU6V+z8p4kJp29H3NwzsxIbZRZw5oX
 RdhVltS11HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARTi9Ghv7/DCci9v5dphfN
 s/3jn+xTiomp+Q/SUz2m380z5Ypsdmb47/xm2c7Fu1c3vm2wMAx6ve9+Xxhz9JPVK7r02dZW2ln
 dYQIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Walk @super_blocks and @fs_supers under rcu_read_lock() and pin the
current entry with refcount_inc_not_zero() instead of holding sb_lock
across the cursor advance. sb_lock was only there to keep the
cursor's ->next / ->prev pointer from being mutated by concurrent
list_del / list_add. RCU semantics give us that guarantee directly:
list_bidir_del_rcu() preserves both ->next and ->prev on the
unlinked entry and list_add_tail_rcu() publishes new entries with
the release barrier set up by the previous patch.

The pattern at each iterator is:

    rcu_read_lock();
    list_for_each_entry_rcu(sb, ...) {
            if (SB_DYING)                             continue;
            if (!refcount_inc_not_zero(&sb->s_count)) continue;
            rcu_read_unlock();

            ...                       /* may sleep on s_umount */

            if (prev)
                    put_super(prev);
            prev = sb;
            rcu_read_lock();          /* prev pinned: prev->{next,prev} valid */
    }
    rcu_read_unlock();
    if (prev)
            put_super(prev);

While we hold a pin on @prev, __put_super() cannot reach the
refcount_dec_and_test() transition that drives list_bidir_del_rcu().
So @prev stays on the list and concurrent list_bidir_del_rcu() of
other entries keeps @prev->s_list.{next,prev} pointing at the still-
live neighbour (or the head sentinel). The cursor advance after
re-acquiring rcu_read_lock() is therefore always against a live
chain in whichever direction we're walking.

put_super() now appears in the middle of the loop where __put_super()
used to be called with sb_lock held. It briefly takes sb_lock for
the trailing-ref drop; in the common case dec_and_test() returns
false and the lock is held for only a handful of cycles.

first_super() and next_super() switch the forward arm to READ_ONCE()
on the head and cursor ->next pointers and the reverse arm to
rcu_dereference(list_bidir_prev_rcu(...)). The forward arm matches
the semantics of list_entry_rcu() used internally by
list_for_each_entry_rcu(); the reverse arm is the canonical
bidirectional-RCU traversal pattern (see kernel/nstree.c) and is
needed because filesystems_freeze() and do_emergency_remount() pass
SUPER_ITER_REVERSE.

iterate_supers_type() and user_get_super() get the same treatment.
user_get_super() simplifies further: on lookup hit we return with
the pin; on lookup miss followed by SB_DYING discovery we put_super()
and return NULL.

sget_fc() and grab_super() are not touched here.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/super.c | 71 +++++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 38 insertions(+), 33 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 8c01b95be717..d9b1148f7030 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -831,17 +831,25 @@ enum super_iter_flags_t {
 
 static inline struct super_block *first_super(enum super_iter_flags_t flags)
 {
+	struct list_head *next;
+
 	if (flags & SUPER_ITER_REVERSE)
-		return list_last_entry(&super_blocks, struct super_block, s_list);
-	return list_first_entry(&super_blocks, struct super_block, s_list);
+		next = rcu_dereference(list_bidir_prev_rcu(&super_blocks));
+	else
+		next = READ_ONCE(super_blocks.next);
+	return list_entry(next, struct super_block, s_list);
 }
 
 static inline struct super_block *next_super(struct super_block *sb,
 					     enum super_iter_flags_t flags)
 {
+	struct list_head *next;
+
 	if (flags & SUPER_ITER_REVERSE)
-		return list_prev_entry(sb, s_list);
-	return list_next_entry(sb, s_list);
+		next = rcu_dereference(list_bidir_prev_rcu(&sb->s_list));
+	else
+		next = READ_ONCE(sb->s_list.next);
+	return list_entry(next, struct super_block, s_list);
 }
 
 static void __iterate_supers(void (*f)(struct super_block *, void *), void *arg,
@@ -850,15 +858,15 @@ static void __iterate_supers(void (*f)(struct super_block *, void *), void *arg,
 	struct super_block *sb, *p = NULL;
 	bool excl = flags & SUPER_ITER_EXCL;
 
-	guard(spinlock)(&sb_lock);
-
+	rcu_read_lock();
 	for (sb = first_super(flags);
 	     !list_entry_is_head(sb, &super_blocks, s_list);
 	     sb = next_super(sb, flags)) {
 		if (super_flags(sb, SB_DYING))
 			continue;
-		refcount_inc(&sb->s_count);
-		spin_unlock(&sb_lock);
+		if (!refcount_inc_not_zero(&sb->s_count))
+			continue;
+		rcu_read_unlock();
 
 		if (flags & SUPER_ITER_UNLOCKED) {
 			f(sb, arg);
@@ -867,13 +875,14 @@ static void __iterate_supers(void (*f)(struct super_block *, void *), void *arg,
 			super_unlock(sb, excl);
 		}
 
-		spin_lock(&sb_lock);
 		if (p)
-			__put_super(p);
+			put_super(p);
 		p = sb;
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 	if (p)
-		__put_super(p);
+		put_super(p);
 }
 
 void iterate_supers(void (*f)(struct super_block *, void *), void *arg)
@@ -895,15 +904,15 @@ void iterate_supers_type(struct file_system_type *type,
 {
 	struct super_block *sb, *p = NULL;
 
-	spin_lock(&sb_lock);
-	hlist_for_each_entry(sb, &type->fs_supers, s_instances) {
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(sb, &type->fs_supers, s_instances) {
 		bool locked;
 
 		if (super_flags(sb, SB_DYING))
 			continue;
-
-		refcount_inc(&sb->s_count);
-		spin_unlock(&sb_lock);
+		if (!refcount_inc_not_zero(&sb->s_count))
+			continue;
+		rcu_read_unlock();
 
 		locked = super_lock_shared(sb);
 		if (locked) {
@@ -911,14 +920,14 @@ void iterate_supers_type(struct file_system_type *type,
 			super_unlock_shared(sb);
 		}
 
-		spin_lock(&sb_lock);
 		if (p)
-			__put_super(p);
+			put_super(p);
 		p = sb;
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 	if (p)
-		__put_super(p);
-	spin_unlock(&sb_lock);
+		put_super(p);
 }
 
 EXPORT_SYMBOL(iterate_supers_type);
@@ -927,25 +936,21 @@ struct super_block *user_get_super(dev_t dev, bool excl)
 {
 	struct super_block *sb;
 
-	spin_lock(&sb_lock);
-	list_for_each_entry(sb, &super_blocks, s_list) {
-		bool locked;
-
+	rcu_read_lock();
+	list_for_each_entry_rcu(sb, &super_blocks, s_list) {
 		if (sb->s_dev != dev)
 			continue;
+		if (!refcount_inc_not_zero(&sb->s_count))
+			continue;
+		rcu_read_unlock();
 
-		refcount_inc(&sb->s_count);
-		spin_unlock(&sb_lock);
-
-		locked = super_lock(sb, excl);
-		if (locked)
+		if (super_lock(sb, excl))
 			return sb;
 
-		spin_lock(&sb_lock);
-		__put_super(sb);
-		break;
+		put_super(sb);
+		return NULL;
 	}
-	spin_unlock(&sb_lock);
+	rcu_read_unlock();
 	return NULL;
 }
 

-- 
2.47.3

