Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3A8385521;
	Tue, 17 Mar 2026 22:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773787633; cv=none; b=h6pXJ71hKNm6qLtfnVbGKGHkRbtofCtaNWXOKZQWSTNoT1NigNSzqEjM++VxkvZjEJ9hR72eoG4saiRfqJkWM1gVi+cPgl7LAA7vqXmVtcZatc6gK+QyyiumSNOZMAfNFB7DMc4ID188q+WWCEswlYwFMrAGO9stHFQTpj8whIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773787633; c=relaxed/simple;
	bh=7uCrkEfVh3jKSyeXWT2eqN5YUBCGRWEAwVdTHM4SBw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ip+aycmjGYuwciJkm/9d/p5SDRXMXB87ctXNzcSzjmf6WiAO0fN/7i1bmRnXYno5gfcZ62kaEEdvttGlEIvJFOdaxBLjwuRyqywIKMt/s46KhVotjRW5Ind8I9j/hQti4VFm+Q6iVWVTCMObWp7Kk9++OBlf8B6n1KCL2vJ7xi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=a3OqhTVV; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=NCVLtQor; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="a3OqhTVV";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="NCVLtQor"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id C7FD9EC0110;
	Tue, 17 Mar 2026 18:47:11 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Tue, 17 Mar 2026 18:47:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773787631;
	 x=1773874031; bh=M08o3yrYCfIMK1eXLxlmu6lq3fEzkhTY/ywOT6g4Fa8=; b=
	a3OqhTVVjWK75EKRKycU2XK+Raij9gLz7KtFstAWJfq/EUHI/2jBHbUnKTLxRVXz
	eCG28ctb5up/AwJyfk3G35e4CFBLs5bEkxxPPXOk4JtJtAP2se3rbSGYuST5eY0Q
	xTCZEVcSd3z6po1NRzFFViF+LPfjemuIfIR/eVeBFIjkiJ+xL+TcdSxryk83mqsB
	uW0YcWO7VnvbkYHH12JEi7c4O4iZE/sYQKN9PErWZLVzHWiHoCp9BPkXVR2uQZSH
	qnc2SEBmsWQmwMPHyA0aIL7Ze5nOEs/jhv/4xrNF9Q2dB3m1nKEcW10DlNFd5WHu
	Qg9plmLSCSrt1n4zcywPXQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773787631; x=1773874031; bh=M
	08o3yrYCfIMK1eXLxlmu6lq3fEzkhTY/ywOT6g4Fa8=; b=NCVLtQor8Jhkjw2qF
	3iS3eOYS1/3vBJkELIUx9Xn5aE79VCopE14YgZJ6Bwnghu6TRdBvCSg85JurV4Bc
	VP8Fk4DMlEvTGd9XfhGOLFM+F1J8v7UCpNS/GA+NHUb5WRqVpxitukOuC8eXo/X6
	lXN4ygC6SrQ+0vdJtxJQAtqFY72ZhQhPZxa3rLeisvv5FyuRv2AFfZFg36kkYY3w
	mcuIUFw+IhUwqZNV3/NEOc8px/fLNcjMyF+EKGyxb+W9xUq3uxIOenNj5ZT6i456
	e0liURClHIR0T+e9JV7hVGysSjqzFm0apcK2mr+myOi8kQocX4c0gVCNtno0bdcW
	T+RGg==
X-ME-Sender: <xms:79m5aar45IsdIBPa6AwkbCZaZdVKuho0z2niFaqfx9o4CLmgZVrpSg>
    <xme:79m5aaLGP3YL3oUe_yzohOOoPAQaG1eosQLNMtuFL5h1jIVrGF4uWcj8gPnqS1ZVf
    h8cBMo9FzZR2yPbuSPpzQRU5Idb6qP3ygoOVMX7KKZIkutiRQ>
X-ME-Received: <xmr:79m5afTbCnQlo0mvMnEqZNoMqalltaZQATGC1uoR3iTZOAARPINwGzW_bar_tNhStWob8ow9D8YkAJLToOk4vj3qxNHj2yNNqI83l4BjR11b>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftddvgeelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfrhgggfestdekre
    dtredttdenucfhrhhomheppfgvihhluehrohifnhcuoehnvghilhgssehofihnmhgrihhl
    rdhnvghtqeenucggtffrrghtthgvrhhnpeevveekffduueevhfeigefhgfdukedtleekje
    eitdejudfgueekvdekffdvfedvudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehnvghilhgssehofihnmhgrihhlrdhnvghtpdhnsggprhgtph
    htthhopeehpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehlihhnuhigqdhfshgu
    vghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqvg
    igthegsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhgrtghksehsuhhs
    vgdrtgiipdhrtghpthhtohepthihthhsohesmhhithdrvgguuhdprhgtphhtthhopegrug
    hilhhgvghrrdhkvghrnhgvlhesughilhhgvghrrdgtrg
X-ME-Proxy: <xmx:79m5aZs4KYvEhYDCRpMSkWsNGONwMSFpQzaKYWwPTynp2iaZ3KYMwQ>
    <xmx:79m5aQakhThwIWn1m-f4bQ3a6K296oozeUCpt9ff2q2fNQ0PnvXWuA>
    <xmx:79m5afF7PYMM1O1eWreOOD_xreMUEjeZeDtmO12pQfw_F-09c7E6ag>
    <xmx:79m5aUymd6ft0biO7RdFmiO2xZMHk7G0RCaUFQZ1eThxtKNtM-XWTQ>
    <xmx:79m5aYTmZflG01SsSklgQ6DI2m7YkB5vwqei3uHX-us5ajvjL1FjbDvB>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Mar 2026 18:47:09 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/3] ext4: move dcache manipulation out of __ext4_link()
Date: Wed, 18 Mar 2026 09:39:51 +1100
Message-ID: <20260317224638.3809014-4-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260317224638.3809014-1-neilb@ownmail.net>
References: <20260317224638.3809014-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: NeilBrown <neil@brown.name>

__ext4_link() has two callers.

- ext4_link() calls it during normal handling of the link() system
  call or similar
- ext4_fc_replay_link_internal() calls it when replaying the journal
  at mount time.

The former needs changes to dcache - instaniating the dentry to the
inode on success.  The latter doesn't need or want any dcache
manipluation.

So move the manipulation out of __ext4_link() and do it in ext4_link()
only.

This requires:
 - passing the qname from the dentry explicitly to __ext4_link.
   The parent dir is already passed.  The dentry is still passed
   in the ext4_link() case purely for use by ext4_fc_track_link().
 - passing the inode separately to ext4_fc_track_link() as the
   dentry will not be instantiated yet.
 - using __ext4_add_entry() in ext4_link, which doesn't need a dentry.
 - moving ext4_inc_count(), ihold)(, d_instantiate(), drop_nlink() and
   iput() calls out of __ext4_link() into ext4_link().

This substantially simplifies ext4_fc_replay_link_internal(), and
removes a use of d_alloc() which, it is planned, will be removed.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/ext4/ext4.h        |  5 +++--
 fs/ext4/fast_commit.c | 32 ++++----------------------------
 fs/ext4/namei.c       | 25 ++++++++++++++-----------
 3 files changed, 21 insertions(+), 41 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 293f698b7042..e757e9cf9728 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2974,7 +2974,8 @@ void __ext4_fc_track_unlink(handle_t *handle, struct inode *inode,
 void __ext4_fc_track_link(handle_t *handle, struct inode *inode,
 	struct dentry *dentry);
 void ext4_fc_track_unlink(handle_t *handle, struct dentry *dentry);
-void ext4_fc_track_link(handle_t *handle, struct dentry *dentry);
+void ext4_fc_track_link(handle_t *handle, struct inode *inode,
+			struct dentry *dentry);
 void __ext4_fc_track_create(handle_t *handle, struct inode *inode,
 			    struct dentry *dentry);
 void ext4_fc_track_create(handle_t *handle, struct dentry *dentry);
@@ -3719,7 +3720,7 @@ extern int ext4_handle_dirty_dirblock(handle_t *handle, struct inode *inode,
 extern int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
 			 struct inode *inode, struct dentry *dentry);
 extern int __ext4_link(struct inode *dir, struct inode *inode,
-		       struct dentry *dentry);
+		       const struct qstr *d_name, struct dentry *dentry);
 
 #define S_SHIFT 12
 static const unsigned char ext4_type_by_mode[(S_IFMT >> S_SHIFT) + 1] = {
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 3ee302b73f45..175dda11f377 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -497,10 +497,9 @@ void __ext4_fc_track_link(handle_t *handle,
 	trace_ext4_fc_track_link(handle, inode, dentry, ret);
 }
 
-void ext4_fc_track_link(handle_t *handle, struct dentry *dentry)
+void ext4_fc_track_link(handle_t *handle, struct inode *inode,
+			struct dentry *dentry)
 {
-	struct inode *inode = d_inode(dentry);
-
 	if (ext4_fc_eligible(inode->i_sb))
 		__ext4_fc_track_link(handle, inode, dentry);
 }
@@ -1431,7 +1430,6 @@ static int ext4_fc_replay_link_internal(struct super_block *sb,
 				struct inode *inode)
 {
 	struct inode *dir = NULL;
-	struct dentry *dentry_dir = NULL, *dentry_inode = NULL;
 	struct qstr qstr_dname = QSTR_INIT(darg->dname, darg->dname_len);
 	int ret = 0;
 
@@ -1442,21 +1440,7 @@ static int ext4_fc_replay_link_internal(struct super_block *sb,
 		goto out;
 	}
 
-	dentry_dir = d_obtain_alias(dir);
-	if (IS_ERR(dentry_dir)) {
-		ext4_debug("Failed to obtain dentry");
-		dentry_dir = NULL;
-		goto out;
-	}
-
-	dentry_inode = d_alloc(dentry_dir, &qstr_dname);
-	if (!dentry_inode) {
-		ext4_debug("Inode dentry not created.");
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ret = __ext4_link(dir, inode, dentry_inode);
+	ret = __ext4_link(dir, inode, &qstr_dname, NULL);
 	/*
 	 * It's possible that link already existed since data blocks
 	 * for the dir in question got persisted before we crashed OR
@@ -1470,16 +1454,8 @@ static int ext4_fc_replay_link_internal(struct super_block *sb,
 
 	ret = 0;
 out:
-	if (dentry_dir) {
-		d_drop(dentry_dir);
-		dput(dentry_dir);
-	} else if (dir) {
+	if (dir)
 		iput(dir);
-	}
-	if (dentry_inode) {
-		d_drop(dentry_inode);
-		dput(dentry_inode);
-	}
 
 	return ret;
 }
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 768036a109d7..23942320c515 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3452,7 +3452,8 @@ static int ext4_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	return err;
 }
 
-int __ext4_link(struct inode *dir, struct inode *inode, struct dentry *dentry)
+int __ext4_link(struct inode *dir, struct inode *inode,
+		const struct qstr *d_name, struct dentry *dentry)
 {
 	handle_t *handle;
 	int err, retries = 0;
@@ -3467,10 +3468,8 @@ int __ext4_link(struct inode *dir, struct inode *inode, struct dentry *dentry)
 		ext4_handle_sync(handle);
 
 	inode_set_ctime_current(inode);
-	ext4_inc_count(inode);
-	ihold(inode);
 
-	err = ext4_add_entry(handle, dentry, inode);
+	err = __ext4_add_entry(handle, dir, d_name, inode);
 	if (!err) {
 		err = ext4_mark_inode_dirty(handle, inode);
 		/* this can happen only for tmpfile being
@@ -3478,11 +3477,8 @@ int __ext4_link(struct inode *dir, struct inode *inode, struct dentry *dentry)
 		 */
 		if (inode->i_nlink == 1)
 			ext4_orphan_del(handle, inode);
-		d_instantiate(dentry, inode);
-		ext4_fc_track_link(handle, dentry);
-	} else {
-		drop_nlink(inode);
-		iput(inode);
+		if (dentry)
+			ext4_fc_track_link(handle, inode, dentry);
 	}
 	ext4_journal_stop(handle);
 	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
@@ -3511,9 +3507,16 @@ static int ext4_link(struct dentry *old_dentry,
 	err = dquot_initialize(dir);
 	if (err)
 		return err;
-	return __ext4_link(dir, inode, dentry);
+	ext4_inc_count(inode);
+	err = __ext4_link(dir, inode, &dentry->d_name, dentry);
+	if (!err) {
+		ihold(inode);
+		d_instantiate(dentry, inode);
+	} else {
+		drop_nlink(inode);
+	}
+	return err;
 }
-
 /*
  * Try to find buffer head where contains the parent block.
  * It should be the inode block if it is inlined or the 1st block
-- 
2.50.0.107.gf914562f5916.dirty

