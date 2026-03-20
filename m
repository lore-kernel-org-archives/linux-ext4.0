Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CAE26AE5;
	Fri, 20 Mar 2026 00:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773965347; cv=none; b=ic0TiFXLD6t0GcTGi+2Hcl5Ou72nicT7jXB3Al0ZQULexUtOV8GDdg908JQY0ECEUFEelJjfqXLIziAEhp1OcWk5J/6W2pFll8h2I4M0gIi6dDj4xI1NDQTz8BvdMwp9cAjcGKFhYv//Wr+eyaJY704zyot4/GGXzSjtSoVUhoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773965347; c=relaxed/simple;
	bh=y0cripqIJXR82AgfrBOq460/soZKKdIa6GsJTNDMCHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7NFEaPAi0Lp8oDcCYiDstpXvVVG2/bD9CO4cPzCKVZ3H0XRWS/5bvpBASvN66ahJOcJYC7uFmSn6Wq3YWf5Do79YoCLk5X8SEgM6DRdQyJC5q+gHcBPOy2OIKTezs3otdUC4Zptr18rNmiZXeo2x6aJ25Z+Oi1sbiX9aUM+cjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=Lc6inBIM; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=qqknEK3N; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="Lc6inBIM";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="qqknEK3N"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 7A0E51D001C5;
	Thu, 19 Mar 2026 20:09:05 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Thu, 19 Mar 2026 20:09:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773965345;
	 x=1774051745; bh=BnfsS7ZS4IuBePXBuQ9sSjzR/qkUUYoN+caEpWzHwNs=; b=
	Lc6inBIMcyHKVtaqGf3W1WAeGYhLoo9Ta4AIHV2fU2gNk8reBB56KiifVntiYRCK
	tLRjc3+M9tDptqilTszyKuHIyvwslSbz+q9kqJcFItbMk7+IjIoZSzTWmJ+KQng3
	yJdyyXYgC09WWAmX9/V/SGtrCTD9SpeD4uDWeSDF0G5SRXsL2rfXQ/BC/x1Hyn1q
	W4wbrvKV+5aculVKIcM/LuElvYCYavmxGADbEagxaj3hZV9C9DgQaKXEInhIqQqB
	EyMOakxtkcheCOUZVKT09qSOTDpRmOp1srqc50s4tb58YKQ30k+92pLLrsircRYT
	4rCb4eIQ0n+bgOrJn79aKg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773965345; x=1774051745; bh=B
	nfsS7ZS4IuBePXBuQ9sSjzR/qkUUYoN+caEpWzHwNs=; b=qqknEK3N6iZy5IANi
	xKaBjX9PERW3+5xy/GATatbD9ps9h+pdRpB0GZLrMo4eiSnGo5Vcp5a+fGH7i7gF
	NSKLKQvKlQSDh8Tje6n/qS+zwceKbszi84pI9FKcZvwPNeK99nnYY8AEifUdejt6
	paddjLRdP6lDYY9gIvygdSGUUrzjxucLfcXeeXfPCsisdw9vGxMSAE+MtTI+SbX4
	+Fh3JdNRTcaIk3vhuO8/aNKENuIWlBrsz0LdDm/c4B5hhB2E6p/AxyDpDLulVnYs
	DCpdUxIH7P5mr9ilt2SRB58zCJiwn0DcGrLeCGWEemaVuwefV11zgSBeII0mQOw6
	Sckpg==
X-ME-Sender: <xms:IZC8aVGWJp_9ULxfXG4U8hkgxbWe0JOC4-cGULuaKlro8aJHh6rJWA>
    <xme:IZC8aTo2FCMwdzTY-YU796WOARgyUvB4Vnr_V6643KbBFyzMeP5ZoKigvWiQlreIw
    jrvuV1rOK1NWGVD0ngiW8dS1PQTThFTAG9Z-0croshLydHM>
X-ME-Received: <xmr:IZC8aeYBQciSe2R3LX4ele2smvx7kl34yN3pABcNANYc5rvvwTyV4TEdw-nD3DSXP5BaGRs32DgREepE2kOpuWI5Xwsxc7yxypa6l4LlHSO8>
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
X-ME-Proxy: <xmx:IZC8acWRmm68WAi1EtHCfJ01cOJTHSOAKBtaLLaLi3bQpae_NFVjfQ>
    <xmx:IZC8aX-FazzcfNeDcRA0oIIjPwzYuuv6QbEvE_9MbMwvz1bDxD9DNQ>
    <xmx:IZC8aV_1mYXCHUEYpGm8Mf9SIGVaDIb9Q5yd4lf9FyCEWr6tnkaO6A>
    <xmx:IZC8aXSv2LXEGqblHljR_rwpfPGCgnwN25_Co6_s4iLK5YrBFStgZg>
    <xmx:IZC8aTU602zvoBMiyvAyxXAt7kSA2TMMo5xI9AFirWWPFUV_HlLUcECa>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Mar 2026 20:09:02 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Cc: linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 2/3] ext4: add ext4_fc_eligible()
Date: Fri, 20 Mar 2026 11:03:17 +1100
Message-ID: <20260320000838.3797494-3-neilb@ownmail.net>
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

Testing EXT4_MF_FC_INELIGIBLE is almost always combined with testing
ext4_fc_disabled().  The code can be simplified by combining these two
in a new ext4_fc_eligible().

In ext4_fc_track_inode() this moves the ext4_fc_disabled() test after
ext4_fc_mark_ineligible(), but as that is a non-op when
ext4_fc_disabled() is true, this is no no consequence.

Note that it is important to still call ext4_fc_mark_ineligible() in
ext4_fc_track_inode() even when ext4_fc_eligible() would return true.
ext4_fc_mark_ineligible() does not ONLY set the "INELIGIBLE" flag but
also updates ->s_fc_ineligible_tid to make sure that the flag remains
set until all ineligible transactions have been committed.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reviewed-by: Jan Kara <jack@suse.cz>
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

