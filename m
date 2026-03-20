Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6FA40DFB6;
	Fri, 20 Mar 2026 00:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773965341; cv=none; b=Q7PDa7cdvNa/e/U9ZB7yh2YIlo3bt19E9lfRrOXg+MbNlwH6+GbYJv3v6ANT+9JStP+wnt1lBU3ewpL9zilGPOnJx57LaQZ8+tqLxFe4tJGGWzE/fu5xNbx4fnb8P3Bc6J6WM6ewX9NaR+JtSfHoekvqQ8+YiCwlb1pic1+s8OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773965341; c=relaxed/simple;
	bh=AWSCDqznb/lYKKV7P3N9VTU06awWLFlUAzQlVK/w7CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqV8ExXemee2YgQYrw9ON/cm5BLVSJn6RCQkJp6Dz8vwu2TRFnWfFwYIe3veDkkHc7wpWXGIqnMlC7+2P/kB/nf1R5YjrM0EnwUvgMVfz2kmByRZlFtL8Nzg+kpmdIG9wPWGlz64upgRIdKRJrVIs24zCjmFMEIK9UM9S2c1zjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=iD5YDNBc; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=2zsKRp4z; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="iD5YDNBc";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="2zsKRp4z"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id CF4EC1D001C5;
	Thu, 19 Mar 2026 20:08:59 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 19 Mar 2026 20:09:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773965339;
	 x=1774051739; bh=PlkSBc6kw5jERRl8A4GR5qIL721JqqZ0PsEXTMKKvI4=; b=
	iD5YDNBcyq9RTrQGDCINID7d2A1JPgc7JwhMP8g3Hp0jMal5rxUSpLZ+wiZxq68T
	gh1rHwaCVxdFH44biCJYr7nukFAIMCa0waUayeT/TcN3UUTo30GM1jgx0j8LyUtZ
	L9+4pb+BVMZe2vAIVQACh2LTZR8G94NYOQzv0hNQrH51wxTI8olR5I4F+m+tTqjs
	2OSqdVVJ4bXGI2uipCB0+XfsMsKAFtjIoJDLtbQTkk5jVA/Nyfbex3/zQRg2meAv
	6IhkaFQ00HXsqI0ncMaVa4VQHFk6jncjHeIddO1KVCXfkX1uCWP7SigegjAUOg2K
	LNfo6kh5U1IVJxgEIKnDfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773965339; x=1774051739; bh=P
	lkSBc6kw5jERRl8A4GR5qIL721JqqZ0PsEXTMKKvI4=; b=2zsKRp4zOVWYdBTtW
	z6CFdHHXN1bBkstpIgKmh0JxXy9aRKLJPuUpH7N0ZUUu76IyRSNrlVVcEbE8fMO7
	FTKFLZopdUXUQ9DFWETky8WBlR3Za5mi4cH1KvJoE7YopqPtQajsxmZ3+LHX9GpH
	pg1TvRxZWM9MTCnVLHDmJjOCyO+BidAqPtvTO8qHrGXKJP7OO9qbaRxNWyb11vGY
	BnZMYrDkV4R10GFXItP3j6/yKgKp8VlWUKYrw27FKJpXBt5NZY4aTaoNnt/Viq0y
	rloohat9Vpwv2Th1ALh0v1Rw6wPiCZvZaPX6M02NG+N18EuaWnWMJEGxA683u2X9
	UPbGg==
X-ME-Sender: <xms:G5C8adINpdc8xyy1Bgc_RnUHQzY2kHtC1iNGa856hF4cS5qtEF-0hg>
    <xme:G5C8aSf-NtndgFo_ehg_0gQNdI8368XGtwDR3xLXw0_xWPsbIbQx5IiNX7yRHpFZq
    b2K7Cp0FrwlFO2aI_85N2BtoMoKNN_X8WFdcDFjWYoW8Wkt7w>
X-ME-Received: <xmr:G5C8ac8PK2nTBCJ1vDlwjipyXQJQHBHXpWbmuPwcsZa5C-rKa5BSgtjylWuaMuOmakqd3Q>
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
X-ME-Proxy: <xmx:G5C8afrTjRtyqSNywx5OD9r61781vx2BV04foRGTCYU_mN5MtdEH_w>
    <xmx:G5C8aRBUVmyX75_gSEwgjoMN31muKNNlh6qlSQn0GOhfEySDldzD5w>
    <xmx:G5C8aRwv1g0oGkff_R0gYvE75wl6PUpl3TNIdjec9BE1Udbx314gOA>
    <xmx:G5C8ae0SmfMvLSW9ssJ-X25_wOi03ziGVbNW0P8Lb8QHg_AIgPWeMw>
    <xmx:G5C8aVgQtVo-vXb3ew1nEN0zruodm4q6x3dpyOYZQJ8u9P21CAj5Ug4j>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Mar 2026 20:08:57 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Cc: linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 1/3] ext4: split __ext4_add_entry() out of ext4_add_entry()
Date: Fri, 20 Mar 2026 11:03:16 +1100
Message-ID: <20260320000838.3797494-2-neilb@ownmail.net>
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

__ext4_add_entry() is not given a dentry - just inodes and name.
This will help the next patch which simplifies __ex4_link().

Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reviewed-by: Jan Kara <jack@suse.cz>
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

