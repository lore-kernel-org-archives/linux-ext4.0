Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F48340DFBB;
	Tue, 26 May 2026 15:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779808176; cv=none; b=Mq8E9kMO7ggWmRT8UyWF2RCPezWzsosn22a9L7vGzQEMSxDUyCPEwmkix8EZD4oUh3VrVCzWAOzVJizWE36q2TDx/ILBBW/AgXJsYK7Sm+iNs4Ws+cTVNyJevMI031IJ3G4Oiq1SdaMrDvRnnX7drtqH+Jbq4ZYYwmNECI2c13g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779808176; c=relaxed/simple;
	bh=RrUvH7sDOwntil6w79GeO/v3T6RBm+ssGDxTaTQbEtI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JcssVoLTH4L0R+FkuZCi4xV20HPSCROveN+kWWiFI3meQSAiM5iFAo6P16hFBoqRkW5J8MN/PagJvdD9+EfsxbxqF+/FAqOSlXkFUNDgxSms17PACvcd8S+SBgGtADutRD40/0EIcQvmOnP1wzL1LPgnWD9hq6632cmwxsWVfF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PShnNDYe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PShnNDYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011151F000E9;
	Tue, 26 May 2026 15:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779808175;
	bh=MDX8oTrV+GX4sU8JMgNFdB/McTfEGr2W/sWXBLBnIGM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PShnNDYedPDDKt754nPE3i/lYGuh2RjMM3MTLUisLe0hMUhIG8lnVdiFywjcUIIwn
	 nOHlsz9tTN1qOzMwLoqrvWxxf72LFrOCxuSz5VnBsbSj5sadYMagFqtxYXnvn9RIr1
	 8nqAyL9nAW1VOrVtPR5bau3KlqehXeG00DW1jDqMl9Q8m5oJX+9KBnYL7RpWie+uS2
	 /m0eCN5s/w+WhYjtZFEHyxSjMcHkuTvLwT4pcgVyP9e0RCs2k2FdXXCZM1Sgfm33JK
	 QUCk1ktpWx3SFKDMKzlpZ14wAkNTM3qzI+uDuXzhr1ytA0qypJh2kTBHnnjRH7eqMG
	 4xmhG+ityHpiQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 26 May 2026 17:09:09 +0200
Subject: [PATCH 7/8] super: switch list manipulation to _rcu primitives
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-work-sget-v1-7-263f7025cedd@kernel.org>
References: <20260526-work-sget-v1-0-263f7025cedd@kernel.org>
In-Reply-To: <20260526-work-sget-v1-0-263f7025cedd@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, 
 linux-cifs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-fffa9
X-Developer-Signature: v=1; a=openpgp-sha256; l=3005; i=brauner@kernel.org;
 h=from:subject:message-id; bh=RrUvH7sDOwntil6w79GeO/v3T6RBm+ssGDxTaTQbEtI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSJbp8tfOmswJamTIbtdj+tcnq+WmaqLr16ii3de35Jq
 1FXRm5vRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwER6DjP8FYjx71uaq9+77mZb
 yHX/efM1vFgCHJdk9P32610lofH8KyPD/Q7jY5qtzH/bq6vnCUz23xQbYjCb78Wi3f8NErvVfCY
 zAgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Swap the list/hlist write-side operations on @super_blocks and
@fs_type->fs_supers over to their _rcu variants. All three call sites
still hold sb_lock; this is a purely mechanical change that
establishes the writer-side memory ordering lockless RCU readers can
rely on in the next patch.

The affected sites are sget_fc() (list_add_tail() and
hlist_add_head() at the publish step), __put_super()
(list_del_init() -> list_bidir_del_rcu() of s_list when the last
temporary reference is dropped) and kill_super_notify()
(hlist_del_init() -> hlist_del_rcu() of s_instances).

@super_blocks gets list_bidir_del_rcu() rather than list_del_rcu()
because the next patch walks the list backward for
filesystems_freeze() and do_emergency_remount(). list_del_rcu()
preserves the unlinked entry's ->next pointer but poisons ->prev with
LIST_POISON2, which would crash any concurrent reverse traversal that
landed on the just-unlinked entry between the SB_DYING check and the
cursor advance. list_bidir_del_rcu() preserves both ->next and
->prev so reverse traversal stays safe. See kernel/nstree.c for the
canonical bidirectional-RCU list pattern.

The "_init" half of the deletions is not used elsewhere on these list
nodes after removal so dropping it is fine. The entry is about to be
freed via call_rcu(destroy_super_rcu) (for s_list) or to disappear
with the superblock (for s_instances, once the list has done its job
notifying SB_DEAD waiters).

Iterators keep using plain list_for_each_entry() and
hlist_for_each_entry() under sb_lock. Their conversion to lockless
RCU traversal with refcount_inc_not_zero() is the next patch.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/super.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 2fa7023010ec..8c01b95be717 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -407,7 +407,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
 static void __put_super(struct super_block *s)
 {
 	if (refcount_dec_and_test(&s->s_count)) {
-		list_del_init(&s->s_list);
+		list_bidir_del_rcu(&s->s_list);
 		WARN_ON(s->s_dentry_lru.node);
 		WARN_ON(s->s_inode_lru.node);
 		WARN_ON(s->s_mounts);
@@ -445,7 +445,7 @@ static void kill_super_notify(struct super_block *sb)
 	 * SB_DEAD.
 	 */
 	spin_lock(&sb_lock);
-	hlist_del_init(&sb->s_instances);
+	hlist_del_rcu(&sb->s_instances);
 	spin_unlock(&sb_lock);
 
 	/*
@@ -784,8 +784,8 @@ struct super_block *sget_fc(struct fs_context *fc,
 	 * It's in a nascent state and users should wait on SB_BORN or
 	 * SB_DYING to be set.
 	 */
-	list_add_tail(&s->s_list, &super_blocks);
-	hlist_add_head(&s->s_instances, &s->s_type->fs_supers);
+	list_add_tail_rcu(&s->s_list, &super_blocks);
+	hlist_add_head_rcu(&s->s_instances, &s->s_type->fs_supers);
 	spin_unlock(&sb_lock);
 	get_filesystem(s->s_type);
 	shrinker_register(s->s_shrink);

-- 
2.47.3

