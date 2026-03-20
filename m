Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54C02A1BF;
	Fri, 20 Mar 2026 00:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773965353; cv=none; b=c03oNQpUb0I9JKJ4apFNQq5lLGrcZqhP1sXmilylaUx7KRoJkxQ/UQ947PxjKaI42PUQoxRlbhqvoDxaqgit3cnjdbmYAyo92TDN7ARYeC5c1IDZLLAu9tR7Ph8nHZqLtc4ezKJiyCpIH6j+REX/yqEwh9y2Xb4BUWTlMM97a5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773965353; c=relaxed/simple;
	bh=qEW+hhgoHTCyqPJ4+pi0q19745A6/zYvSEHUbtutXC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qdKemRgIjvhU4kkuQQLcUw5X23vATAPfVnG753PeqCWJa2aJbHTyY17nFYtbOmAVPaLDqqlinxr2uKFXNqmXEAF9IjR6E4aJhXMsv4RuQfk6ChkDA/xcaOT+BfeZgCrDxtHT8HN2FtDME084Xxw0bPr2og39/RjZ/RZ1vqOdA3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=XL4oGTDa; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=F5YtDC6j; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="XL4oGTDa";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="F5YtDC6j"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 4014C1D001C5;
	Thu, 19 Mar 2026 20:09:11 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 19 Mar 2026 20:09:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773965351;
	 x=1774051751; bh=Jdxs8DAMfvHPQiSovwBqpWv/pa4pnhOezyO1/ayissY=; b=
	XL4oGTDamSr9iRduZCOnTLN0wrMmygWutMz02Jp/LBvRn8630mleRqEjyXx5iRPY
	RSe92yxKd3HYj8OpKaK5Q5/O2LaXh3jpbxKf8T6Kml7cdF+gc3yjuW4kRmXOvTdC
	h0/OHw7Bwff+BmJ79A+D7j3tLqXPj2a8use674sB+ficd2u5oSW+E65efmjvLhso
	KSWOprUNB+/iKZ3iuEA/ZoFt8vXNRr4SQcWZwuBg0Bal0XC3lIt7lsPoG2+DTNhu
	y7OpPddG+8dA/JmA2gx63xA0Q5EXqPAwC3NRIEabDW2R4QQtaDRrVk0JyEXYrLku
	beiXEy/uswO29KY1CqjLPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773965351; x=1774051751; bh=J
	dxs8DAMfvHPQiSovwBqpWv/pa4pnhOezyO1/ayissY=; b=F5YtDC6j4UhbfoJlb
	3+M5VbO6mEvj9c+M327HQM0NlKtPFl2uxUZEjjjU27P74rW62Y/3ovMbT8mqZqyK
	SE63LOePdvT1v7+dx4xGk9cytwJuQltDThcnWXpwhMXNsG18ATF6/6YtJf37U38c
	7kFV/fCXBbBBzYqq+mK4YbjiCzRREysW4HmHARxad7ExCaGk56G7cf1jnB03d/j/
	9MnJpYFH2plDSdXpHZnuQaXv7uq4EIuGmKC2NG1qC9hbuUC6NuXLdJaX9Tx82wnx
	iVmODW2ZwxAKopzM+IDx0neFI761kE/Hl//N4mQdi13lTlbP5bHLd025qrrJFJID
	zLwdg==
X-ME-Sender: <xms:JpC8aSJfzh4LYBr86S_Wfn8d2DINEhCW0SkOVptkW8L-Em2h8jQn_A>
    <xme:JpC8aTd9nJoSa31nhAjCOR4e34l0NOAHwhiGd2fLPVOUF-ST5IKJPJ10uc7OJbYfw
    xJPKcEO2XIw5J2MflQGCbQKiDlut2n9oN-P-bUmmqTPyjRe>
X-ME-Received: <xmr:JpC8aZ-JSvQNcu1xZOx2VkkXRCsC3GyOI8afrc3w2rt8n3NnqXu1AXy4eafAa-gQlXrL_hnceoGyX3URQVKNHCrXc6UK5qZDiv8N4kGKp8RO>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdekgeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhhrggfgsedtkeertdertddtnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epveevkeffudeuvefhieeghffgudektdelkeejiedtjedugfeukedvkeffvdefvddunecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepnhgvihhlsg
    esohifnhhmrghilhdrnhgvthdpnhgspghrtghpthhtohepiedpmhhouggvpehsmhhtphho
    uhhtpdhrtghpthhtoheplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlihhnuhigqdgvgihtgeesvhhgvghrrdhkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehjrggtkhesshhushgvrdgtiidprhgtphhtthhopehthihtsh
    hosehmihhtrdgvughupdhrtghpthhtohephhgrrhhshhgrughshhhirhifrggukhgrrhes
    ghhmrghilhdrtghomhdprhgtphhtthhopegrughilhhgvghrrdhkvghrnhgvlhesughilh
    hgvghrrdgtrg
X-ME-Proxy: <xmx:JpC8aYqRJUspExEoUUJ_gGjYgkInyPa6u0jNo-wGNh6bblYihqogEA>
    <xmx:JpC8aWBqAaVkXwVO7WYjUBK4c_mne51U13Y0g68iaCoXwSeKxPpHJw>
    <xmx:JpC8aSyPetbeyd80Ku_2HH6rsR09duHMklzN8uDEnJl1t0c4qT8MMw>
    <xmx:JpC8ab1ZpH7NWPGjCP0-qxwfP77y2V9ktdlooGIy6rq9kawVIPrIhg>
    <xmx:J5C8aSj3Zr7xVhS0KQgblOISoCFzg2QFCG3pKLREQ8WI1FuEr-_wqrL_>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Mar 2026 20:09:08 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Cc: linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 3/3] ext4: move dcache manipulation out of __ext4_link()
Date: Fri, 20 Mar 2026 11:03:18 +1100
Message-ID: <20260320000838.3797494-4-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260320000838.3797494-1-neilb@ownmail.net>
References: <20260320000838.3797494-1-neilb@ownmail.net>
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

The former needs changes to dcache - instantiating the dentry to the
inode on success.  The latter doesn't need or want any dcache
manipulation.

So move the manipulation out of __ext4_link() and do it in ext4_link()
only.

This requires:
 - passing the qname from the dentry explicitly to __ext4_link.
   The parent dir is already passed.  The dentry is still passed
   in the ext4_link() case purely for use by ext4_fc_track_link().
 - passing the inode separately to ext4_fc_track_link() as the
   dentry will not be instantiated yet.
 - using __ext4_add_entry() in ext4_link, which doesn't need a dentry.
 - moving ihold(), d_instantiate(), drop_nlink() and iput() calls out
   of __ext4_link() into ext4_link().

Note that ext4_inc_count() and drop_nlink() remain in __ext4_link()
as both callers need them and they are not related to the dentry.

This substantially simplifies ext4_fc_replay_link_internal(), and
removes a use of d_alloc() which, it is planned, will be removed.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/ext4/ext4.h        |  5 +++--
 fs/ext4/fast_commit.c | 32 ++++----------------------------
 fs/ext4/namei.c       | 19 +++++++++++--------
 3 files changed, 18 insertions(+), 38 deletions(-)

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
index 768036a109d7..20ec5674e64b 100644
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
@@ -3468,9 +3469,8 @@ int __ext4_link(struct inode *dir, struct inode *inode, struct dentry *dentry)
 
 	inode_set_ctime_current(inode);
 	ext4_inc_count(inode);
-	ihold(inode);
 
-	err = ext4_add_entry(handle, dentry, inode);
+	err = __ext4_add_entry(handle, dir, d_name, inode);
 	if (!err) {
 		err = ext4_mark_inode_dirty(handle, inode);
 		/* this can happen only for tmpfile being
@@ -3478,11 +3478,10 @@ int __ext4_link(struct inode *dir, struct inode *inode, struct dentry *dentry)
 		 */
 		if (inode->i_nlink == 1)
 			ext4_orphan_del(handle, inode);
-		d_instantiate(dentry, inode);
-		ext4_fc_track_link(handle, dentry);
+		if (dentry)
+			ext4_fc_track_link(handle, inode, dentry);
 	} else {
 		drop_nlink(inode);
-		iput(inode);
 	}
 	ext4_journal_stop(handle);
 	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
@@ -3511,9 +3510,13 @@ static int ext4_link(struct dentry *old_dentry,
 	err = dquot_initialize(dir);
 	if (err)
 		return err;
-	return __ext4_link(dir, inode, dentry);
+	err = __ext4_link(dir, inode, &dentry->d_name, dentry);
+	if (!err) {
+		ihold(inode);
+		d_instantiate(dentry, inode);
+	}
+	return err;
 }
-
 /*
  * Try to find buffer head where contains the parent block.
  * It should be the inode block if it is inlined or the 1st block
-- 
2.50.0.107.gf914562f5916.dirty

