Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7878D390C82;
	Tue, 17 Mar 2026 22:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773787629; cv=none; b=o6AuZUL7h/lk3EgrbIySe9y8HeArZwRNGtsnxfTSzDwlRG/HFihxL7aOUpbqgn4ITEhqs1hqV2x62OCQQx2DVZ/e6pAsUUPRrUEflf9yY3NT4hiMExDPDnUrd5OtnSsDPdqsOnHgf3q+k+N7LZRBRatbjdUVytvSGdvbNVMqzeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773787629; c=relaxed/simple;
	bh=lzGLkPj6EIBLoDDopH08vW3/dirj64/jYYyJLJRu1gA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0KOd9VC9LYRrMOU7S3TV4PYOSKr+pRw4qUHaovGjMeu6uXs6pSiktX8aCWFPcXcei/4bIgpiXAgX449/DSRgzw0XcYjjSEgQ0/imNFMStwKAXgQPLtifCdFJu3QaF/OzPCNCQ89IX/exCd1voxI1Cbtq3hEv5+a+NxQspV4kXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=Qw4eSO5z; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=w9zHTQzo; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="Qw4eSO5z";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="w9zHTQzo"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id ADF57140006F;
	Tue, 17 Mar 2026 18:47:07 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Tue, 17 Mar 2026 18:47:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773787627;
	 x=1773874027; bh=EAYMGZKardNes1EaIXLEhSqvdlm62ri72cqVgOVatjo=; b=
	Qw4eSO5zEcCe9oLnNo/gakwjR8c3i4ZRpRo6xW1vDW/YFgjD3RQOlalyO9XsqP/f
	n8CtImAhItW2jEFWdovEmCF9VYGjUu7pHdKw6Vp3rGx4XuyqBaF8jqbJeb2nG55J
	Bf3UZ49vskUtpDCIBG7WSPIyP1PTt8xg9cbDlWtjKSLqBe34D15Z3iY55TAOsZ54
	oSMgxu3xuplLyqvohjIoG//2Al9Hh13TEqJMr/BfPno3YplrV471i9+NZ0TxJGxg
	IaUUB3Rh8Df0+XAxc7InZw5Jayff9VZs7Xkc4CD1tZs7leis7wUZ8d5FVcn7DDcQ
	M8P8mrMXw0VYVk6ANXzH8Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773787627; x=1773874027; bh=E
	AYMGZKardNes1EaIXLEhSqvdlm62ri72cqVgOVatjo=; b=w9zHTQzoiualyn+KY
	+JxSb3biFR5bthTttFbvF7wJpW576OFa60NL7xtqo0LSFrKs0WJ4ax+l9kf16oOJ
	pVKuNOoM5j9TyFGKbt3bzF3oc8UaWgbxCpIljSCyyTUbZinowOAEAMueiXmmZ0dE
	59mjkOM9vJKjbJUWrciABe2VCPpbWFnkuwmVEijgF40aCwOW4hYA552X6v8hCPV5
	7rrC2NPCqWn1uef5Dg0Bmxd6w4bh/FF5Gz0ZpKgq0Qydl22TZi3nD44Kf+UE/8yV
	TiZW0+89Eq1p9rFpjd5OoXRjGy71dGzgx1z3m3wTiY3Mid774HVqiHJyWYKrILH4
	W4hgg==
X-ME-Sender: <xms:69m5aaat0kAyiS76Q5cc1CPfcT9v7MpExyNVZEdBcxszc0AiLksEpg>
    <xme:69m5ae49YHB6zVbHtUEad1sQLYQ7enWjwSivsIFgW8TKjcDsNMpgOYP6TWeC2WqyO
    ruYReA_Nn1mLyrACpZtOW1B7EwvwsdUv-iadf3H7smX4D1dA7I>
X-ME-Received: <xmr:69m5aVDvGwHbu0IkwHrjfXeVGqQSVqq8oDRGMOWfsN7xvpMQIgqSalFDPduNerhhY3pdstGf5LZL9i1pbuJRsQgcMi5GTYg3h1v4fFdelbDW>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftddvgeekucetufdoteggodetrf
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
X-ME-Proxy: <xmx:69m5acceo5OlKa0PDuVGNAvsHgRIsEQL5tEbTHH9U4gW5JKP961Z8Q>
    <xmx:69m5acIsyLFbvkaEVD_amS5IIFA7EZ9biu7lypzlqFpXEj9WevpNpA>
    <xmx:69m5af2bugDqRhAY39HPSXP7bmtVJmM-GGrh7RIwe2QRFpnxEyzosw>
    <xmx:69m5aWgTmXODl6uy_m7EGblMl9bAViqBF-ar-bdQm7r7DBxqyJFzZA>
    <xmx:69m5aZAN-4qIRbJitP91ni2USw4gwcoodyR226CV2_AcnTb8kBODlVxG>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Mar 2026 18:47:05 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/3] ext4: add ext4_fc_eligible()
Date: Wed, 18 Mar 2026 09:39:50 +1100
Message-ID: <20260317224638.3809014-3-neilb@ownmail.net>
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

Testing EXT4_MF_FC_INELIGIBLE is almost always combined with testing
ext4_fc_disabled().  The code can be simplified by combining these two
in a new ext4_fc_eligible().

In ext4_fc_track_inode() this moves the ext4_fc_disabled() test after
ext4_fc_mark_ineligible(), but as that is a non-op when
ext4_fc_disabled() is true, this is no no consequence.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/ext4/fast_commit.c | 43 ++++++++++++++-----------------------------
 1 file changed, 14 insertions(+), 29 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index f575751f1cae..3ee302b73f45 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -224,6 +224,12 @@ static bool ext4_fc_disabled(struct super_block *sb)
 		(EXT4_SB(sb)->s_mount_state & EXT4_FC_REPLAY));
 }
 
+static bool ext4_fc_eligible(struct super_block *sb)
+{
+	return !ext4_fc_disabled(sb) &&
+		!(ext4_test_mount_flag(sb, EXT4_MF_FC_INELIGIBLE));
+}
+
 /*
  * Remove inode from fast commit list. If the inode is being committed
  * we wait until inode commit is done.
@@ -473,13 +479,8 @@ void ext4_fc_track_unlink(handle_t *handle, struct dentry *dentry)
 {
 	struct inode *inode = d_inode(dentry);
 
-	if (ext4_fc_disabled(inode->i_sb))
-		return;
-
-	if (ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_INELIGIBLE))
-		return;
-
-	__ext4_fc_track_unlink(handle, inode, dentry);
+	if (ext4_fc_eligible(inode->i_sb))
+		__ext4_fc_track_unlink(handle, inode, dentry);
 }
 
 void __ext4_fc_track_link(handle_t *handle,
@@ -500,13 +501,8 @@ void ext4_fc_track_link(handle_t *handle, struct dentry *dentry)
 {
 	struct inode *inode = d_inode(dentry);
 
-	if (ext4_fc_disabled(inode->i_sb))
-		return;
-
-	if (ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_INELIGIBLE))
-		return;
-
-	__ext4_fc_track_link(handle, inode, dentry);
+	if (ext4_fc_eligible(inode->i_sb))
+		__ext4_fc_track_link(handle, inode, dentry);
 }
 
 void __ext4_fc_track_create(handle_t *handle, struct inode *inode,
@@ -527,13 +523,8 @@ void ext4_fc_track_create(handle_t *handle, struct dentry *dentry)
 {
 	struct inode *inode = d_inode(dentry);
 
-	if (ext4_fc_disabled(inode->i_sb))
-		return;
-
-	if (ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_INELIGIBLE))
-		return;
-
-	__ext4_fc_track_create(handle, inode, dentry);
+	if (ext4_fc_eligible(inode->i_sb))
+		__ext4_fc_track_create(handle, inode, dentry);
 }
 
 /* __track_fn for inode tracking */
@@ -557,16 +548,13 @@ void ext4_fc_track_inode(handle_t *handle, struct inode *inode)
 	if (S_ISDIR(inode->i_mode))
 		return;
 
-	if (ext4_fc_disabled(inode->i_sb))
-		return;
-
 	if (ext4_should_journal_data(inode)) {
 		ext4_fc_mark_ineligible(inode->i_sb,
 					EXT4_FC_REASON_INODE_JOURNAL_DATA, handle);
 		return;
 	}
 
-	if (ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_INELIGIBLE))
+	if (!ext4_fc_eligible(inode->i_sb))
 		return;
 
 	/*
@@ -644,10 +632,7 @@ void ext4_fc_track_range(handle_t *handle, struct inode *inode, ext4_lblk_t star
 	if (S_ISDIR(inode->i_mode))
 		return;
 
-	if (ext4_fc_disabled(inode->i_sb))
-		return;
-
-	if (ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_INELIGIBLE))
+	if (!ext4_fc_eligible(inode->i_sb))
 		return;
 
 	if (ext4_has_inline_data(inode)) {
-- 
2.50.0.107.gf914562f5916.dirty

