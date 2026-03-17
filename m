Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D64385521;
	Tue, 17 Mar 2026 22:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773787625; cv=none; b=pi4AcTulZcpCJFZoH9g7Bs9U6cQpIesTBEKgvUzQuOPXC8WLqTzeh9JB9wW0dzfzGFo5qlxHOCbOKBbiLNwne7SkoelUNGphyfsP1NAStos456FbbzNK4jM2K62Q9OWAjMmAemi3NyCKvzImzkMvZVz0vTClz3S+EWE/n5Vn4Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773787625; c=relaxed/simple;
	bh=jKM8L+hxfEPDcARo6B/bIiqDFXv+5hV3k06XxE6wDak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dV/Nqu7veu2M4cTBtf+nYVp/mNneqSQEeWH2MZRN0/aSMtVVTtm+oXriBnf7WXNeJAHAGzvnJgkddOzT+OpXwjN7Ozl62KQRBjJAqfjHgtMe14NNkvkrdIYxTml5GW/9Tbj6BmCkmyzfm2r2wfeIHp1lTKDUXavSRU3RKqH5eg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=oGnNYy28; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Nw3xlt0B; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="oGnNYy28";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Nw3xlt0B"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id A0FB8EC0110;
	Tue, 17 Mar 2026 18:47:03 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 17 Mar 2026 18:47:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773787623;
	 x=1773874023; bh=aTesRul9bwLV+wr4DuUvo2sNVdMdmCH7abWqyNasGcc=; b=
	oGnNYy281X4hHAk04aMkUAKstWke9INInAP1fN6864mn0BH4/5X7ys7vtR18rrk3
	hORVNRn3Kteltjm08ct2gHFJeh7n5GYJ45ikqBjsZ+PkROLgNOHNa0Y1rFm0ktLf
	ldYf+Zvn3EfWYHq7pGYS9Lm6Ko523oGW4B3w23aWdhZapg8/hU2TReU/GjGDNW5u
	ETFrhuc69td1PCV6GjlVSbHZNu54FJwv98kElTOQ3vO9ZiCAlDq0uenV9ihNrszx
	IB9UIETvSa88eazDfZMe5t2yioMzLH0phYRh4r8n3MFksQVeh4nf+ugOaeG40NA0
	zM/2slS3+TRerev55a9BiA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773787623; x=1773874023; bh=a
	TesRul9bwLV+wr4DuUvo2sNVdMdmCH7abWqyNasGcc=; b=Nw3xlt0BwDgteuieq
	Jgl87TTW/bhIsWxUqdX4bq1xjABr4sasZ6QuTRlg5fa1G8193EHFWJcRLjVpNDpe
	Dc5I1bzBqUMD/eJv2F71f46//jN6fb8jViLCEBreASrhtTxUjEBeTX09F+8j/aA7
	juuAOhYJbA66CbMooBw6ticTDQibWwNWu4WDqF0owachsur4L4JpkRBUYkHrMZuy
	AqDrr3RtXxQYWIwGSMDxmz+BOIB9o0SU3O8LC2zx4P8Msmf5ylOojg1MVDv/sva2
	3zobheK859iAdsFlpP0pG0thl6d4OuL02yP4GlUQN1PF+x2OOtzVsCLJnxXsIShr
	bd4aw==
X-ME-Sender: <xms:59m5aQBKsGw7E2A-vxh35dBNmAPC3Aw0oZ9M7dT8DhPdeShwoEPffQ>
    <xme:59m5aUCsLGdfWB7V7gWDBPnMMgREv40zZsD0D9Fj_VJdq1UDkaTcUN8qHmRGFZf-b
    AyWs889oHQtA7EqyiVweFVzLTzd6lrQMjFACuljmD-sA7k>
X-ME-Received: <xmr:59m5aTqU3JBMH14jWDwvPW0AwDRdWEPwTi6Dnul8b2PDWAsnmAruVPCqJXFafBq-QL9A7kXtUyG3bal8cp8Uv0RO3HdgL5zPlRoXxMJBnzcG>
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
X-ME-Proxy: <xmx:59m5aWmSi9ADFlxFELTWy4sSdi-Detu-c2jZkVTex9fRBBbMf2-Ytw>
    <xmx:59m5abz0_I0RImPjzoqfR1P_NI9DCWqN8UKrQbFZRhwXJWz0KSx9Gw>
    <xmx:59m5aW9dVlV3RPM0knlY3hqVO1yAYpKFHV3CiiChMj9_HuLeRx14CQ>
    <xmx:59m5afLczppcSezlBCaXNkISwrU9tILEfD6o9fGI9_l2Znw6511l-A>
    <xmx:59m5aYJRmgK8yaC54xXwiiiMGQzDr7TDaFheosdmL5Itpw39RNpgg14->
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Mar 2026 18:47:01 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/3] ext4: split __ext4_add_entry() out of ext4_add_entry()
Date: Wed, 18 Mar 2026 09:39:49 +1100
Message-ID: <20260317224638.3809014-2-neilb@ownmail.net>
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

__ext4_add_entry() is not given a dentry - just inodes and name.
This will help the next patch which simplifies __ex4_link().

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/ext4/namei.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c4b5e252af0e..768036a109d7 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2353,10 +2353,10 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
  * may not sleep between calling this and putting something into
  * the entry, as someone else might have used it while you slept.
  */
-static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
+static int __ext4_add_entry(handle_t *handle, struct inode *dir,
+			  const struct qstr *d_name,
 			  struct inode *inode)
 {
-	struct inode *dir = d_inode(dentry->d_parent);
 	struct buffer_head *bh = NULL;
 	struct ext4_dir_entry_2 *de;
 	struct super_block *sb;
@@ -2373,13 +2373,10 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 	sb = dir->i_sb;
 	blocksize = sb->s_blocksize;
 
-	if (fscrypt_is_nokey_name(dentry))
-		return -ENOKEY;
-
-	if (!generic_ci_validate_strict_name(dir, &dentry->d_name))
+	if (!generic_ci_validate_strict_name(dir, d_name))
 		return -EINVAL;
 
-	retval = ext4_fname_setup_filename(dir, &dentry->d_name, 0, &fname);
+	retval = ext4_fname_setup_filename(dir, d_name, 0, &fname);
 	if (retval)
 		return retval;
 
@@ -2460,6 +2457,16 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 	return retval;
 }
 
+static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
+			  struct inode *inode)
+{
+	struct inode *dir = d_inode(dentry->d_parent);
+
+	if (fscrypt_is_nokey_name(dentry))
+		return -ENOKEY;
+	return __ext4_add_entry(handle, dir, &dentry->d_name, inode);
+}
+
 /*
  * Returns 0 for success, or a negative error value
  */
-- 
2.50.0.107.gf914562f5916.dirty

