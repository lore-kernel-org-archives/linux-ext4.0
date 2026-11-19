Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795124996;
	b=bnyB+YwRxf3DtRXKFjiNcSFblhWkkemilimJOUJTIIuR/KZp9bUpcSdOkjQVeei1naSP
	 /FHLG8Qf0jzu1XW1JkNWjc4RlxxUHmU1L2kBjQQ2aE3KY9VqbA5ujAznBPkJlGVpOcZyA
	 HVUllZoDci9/LNncwYBmul1QMJ72Dbrbk9WsEVu0wOmmv5y9KHdnC1GN0qMu7h1sFT99q
	 E9BtKLj6/wyrjeYWeFSRFGy6aqtlYL9KYmS252v9Yx+odvqgoWaAVsb8JK0XjYG6Ha5em
	 XGdEpw/yAoYQNtnVCcEJud/8RsgzxSptWwo/xJcOLh5c7BSwPUTNtZe60uaToh+MqAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795124996;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=HIkGPbX/VCKnugEE3DStk2KmzUd3683NSoxPl+Lp+b8=;
	b=WxsrTDHd2ixnlpxDHCtsLXfnd48FRyCmsphzAIEliv+nD5B/U14AXAWsxIzEUajNCPcM
	 2tTZ1JNbQd9ZQZiXZYjvLxRSt3eGaToF7oowOIP6sfPZ0Xhv3s9Pzno0ziLNL7pR6QnYB
	 urw3/S6G0eO3Lptaxm7fnYhEILnHKVsV9b2hwglABDvexUqvzkkwC/eudRidq2x9jPOyL
	 YXDJU0xSXWW0a/dwmKCspEjr5ofulEoFD2msfWD4a566/XCmMKPJzz1q+AUbmPmRS7dDd
	 kmLATxTTFj2d/y7DVSUqszw87eXjys09Wn5PHLdAiDf49aa5C80evXmX6c3tatUX8BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--sarthakkukreti.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Js8zvPHU;
	arc=none smtp.remote-ip=74.125.82.198
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFDB606A33E
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 21:49:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5CFDB606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sarthakkukreti.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Js8zvPHU
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-370230d93efso561523eec.1
        for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 13:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795124994; x=1795729794; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HIkGPbX/VCKnugEE3DStk2KmzUd3683NSoxPl+Lp+b8=;
        b=Js8zvPHUM/gNjoHtAK0cr+ky3h8uO2vQq3QY+V17brPhkIZ4J2v1M2UkS8FfG0ATeM
         0vXrEHSsyfCfkTwcjCqHxNjDMH16cj6nwllYtoW5hBr9WXD/RJXaC8dZzjCM/nwZtaLy
         YOvu8K+sqxoc4mvT81QQfOX8HFXHXJh/S2tEte1Lzf8bwLFJwhks1Xuu31tsz43GbZuq
         EjQt1rWFgE/iwAhmBzXqlMwC2ihTp07lnoKzOjsLAcfisUl5AYXnHDe9RKHyvKoXJil4
         np1Afqsp81sSOy+c1FGncg6gqG3Bq0NtP8Gb1hsRMvf6RGpnqpcOo2C9mjFYsxzG4W/0
         zIeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795124994; x=1795729794;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HIkGPbX/VCKnugEE3DStk2KmzUd3683NSoxPl+Lp+b8=;
        b=gVs3PZEc1QxIpKFVNtvU1upH1dO4DK+8k8f1JrLRxqE045mVW/b7ffUb67mxlx5oua
         WbIvIzky9+5n7rBj6BksFP5vpRaeul/0JYxyD+2m/mwTT+xdJLhSdR3GQjFVhe9eMMbo
         cL2UkFIYamaxmKMOnT1PbBkiMwNwEqcePvyMEiFfbgs72zPCxa9gfaRPeAufb3Nnl3Ke
         8IF+BXRa43cZi4aHizBRnMZ3RS6a66vTd0+jEs5CVv1jsk7YM91nlUxw2iNiOqBcphkG
         0Nt0TF+p2sh6Q+0ZM5Y6RTLEASfwgLcIIquN1JMwErwB52/7Y8P4EPrnckVMNvCfXabu
         rYYg==
X-Forwarded-Encrypted: i=1; AL+hErGtrtah87GBZo3fLBEH0LGKH8yFU1E6/p9asC39Qwqac8cSrQh2j6I4lyujJ2KEZuSMJxZ6W0xKG09O@vger.kernel.org
X-Gm-Message-State: APuU4Z/PYJIEN57MkwZGkG7Iyfw7hLmnwKRC32zkRdoPjzPniLvP1v8Z
	meVzGI+ssFowoMugsg85Z7C/vQZKBm+rpAwbgT6rSYl8kqRbEEpPQE1FNlhvUpFUQJTQr4BpwMD
	SqZbuilzYAA/Wh/UazQTYX+wMp/oJQAtPRILTYA==
X-Received: from dycpq22.prod.google.com ([2002:a05:7301:fd16:b0:385:2e0b:4776])
 (user=sarthakkukreti job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:41cd:20b0:378:3227:b4dd with SMTP id 5a478bee46e88-3856f03cacfmr632641eec.18.1795124994000;
 Thu, 19 Nov 2026 13:49:54 -0800 (PST)
Date: Thu, 19 Nov 2026 13:49:43 -0800
In-Reply-To: <20261119214944.1480596-1-sarthakkukreti@google.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261119214944.1480596-1-sarthakkukreti@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261119214944.1480596-3-sarthakkukreti@google.com>
Subject: [PATCH v2 2/3] ext4: reject casefolded names that fold to ".", "..",
 or empty
From: Sarthak Kukreti <sarthakkukreti@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>, Eric Biggers <ebiggers@kernel.org>, 
	Dmitry Torokhov <dtor@google.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, 
	Sarthak Kukreti <sarthakkukreti@google.com>
Content-Type: text/plain; charset="UTF-8"

Filenames consisting solely of ignorable Unicode characters fold to
empty strings (causing the first such file to be created on disk and
subsequent distinct ignorable-only names to collide with it), while
names with leading dots and ignorable characters fold to "." or "..",
colliding with on-disk "." and ".." entries and triggering
EXT4_ERROR_INODE in ext4_lookup().

Skip casefolding when the lookup name is literally "." or "..", reject
any non-dot names that fold to "", ".", or ".." in
ext4_fname_setup_ci_filename(), and fall back to opaque byte hashing in
ext4fs_dirhash() when utf8_casefold() yields "", ".", or "..".

Fixes: b886ee3e778e ("ext4: Support case-insensitive file name lookups")
Co-developed-by: Dmitry Torokhov <dtor@google.com>
Signed-off-by: Dmitry Torokhov <dtor@google.com>
Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>
---
 fs/ext4/hash-test.c | 14 ++++++++++++++
 fs/ext4/hash.c      |  2 +-
 fs/ext4/namei.c     |  9 +++++++--
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/hash-test.c b/fs/ext4/hash-test.c
index 49b0d874c833..a8b206a6d751 100644
--- a/fs/ext4/hash-test.c
+++ b/fs/ext4/hash-test.c
@@ -541,6 +541,20 @@ static void test_ext4fs_dirhash_casefold_fallback(struct kunit *test)
 	KUNIT_ASSERT_EQ(test, ret_plain, 0);
 	KUNIT_EXPECT_EQ(test, folded_dir.hash, plain.hash);
 	KUNIT_EXPECT_EQ(test, folded_dir.minor_hash, plain.minor_hash);
+
+	ret_cf = ext4fs_dirhash(&ei->vfs_inode, ".\xe2\x80\xae", 4, &folded_dir);
+	ret_plain = ext4fs_dirhash(plain_dir, ".\xe2\x80\xae", 4, &plain);
+	KUNIT_ASSERT_EQ(test, ret_cf, 0);
+	KUNIT_ASSERT_EQ(test, ret_plain, 0);
+	KUNIT_EXPECT_EQ(test, folded_dir.hash, plain.hash);
+	KUNIT_EXPECT_EQ(test, folded_dir.minor_hash, plain.minor_hash);
+
+	ret_cf = ext4fs_dirhash(&ei->vfs_inode, "\xe2\x80\xae", 3, &folded_dir);
+	ret_plain = ext4fs_dirhash(plain_dir, "\xe2\x80\xae", 3, &plain);
+	KUNIT_ASSERT_EQ(test, ret_cf, 0);
+	KUNIT_ASSERT_EQ(test, ret_plain, 0);
+	KUNIT_EXPECT_EQ(test, folded_dir.hash, plain.hash);
+	KUNIT_EXPECT_EQ(test, folded_dir.minor_hash, plain.minor_hash);
 }
 #endif
 
diff --git a/fs/ext4/hash.c b/fs/ext4/hash.c
index 978bd92da0ad..65019de4af93 100644
--- a/fs/ext4/hash.c
+++ b/fs/ext4/hash.c
@@ -327,7 +327,7 @@ int ext4fs_dirhash(const struct inode *dir, const char *name, int len,
 			return -ENOMEM;
 
 		dlen = utf8_casefold(um, &qstr, buff, PATH_MAX);
-		if (dlen < 0) {
+		if (dlen <= 0 || name_is_dot_dotdot(buff, dlen)) {
 			kfree(buff);
 			goto opaque_seq;
 		}
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 354fc2d22df1..cd2c9b873cc6 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1368,7 +1368,8 @@ int ext4_fname_setup_ci_filename(struct inode *dir, const struct qstr *iname,
 	int len;
 
 	if (!IS_CASEFOLDED(dir) ||
-	    (IS_ENCRYPTED(dir) && !fscrypt_has_encryption_key(dir))) {
+	    (IS_ENCRYPTED(dir) && !fscrypt_has_encryption_key(dir)) ||
+	    name_is_dot_dotdot(iname->name, iname->len)) {
 		cf_name->name = NULL;
 		return 0;
 	}
@@ -1378,9 +1379,13 @@ int ext4_fname_setup_ci_filename(struct inode *dir, const struct qstr *iname,
 		return -ENOMEM;
 
 	len = utf8_casefold(dir->i_sb->s_encoding, iname, buf, EXT4_NAME_LEN);
-	if (len <= 0) {
+	if (len < 0) {
 		kfree(buf);
 		buf = NULL;
+	} else if (len == 0 || name_is_dot_dotdot(buf, len)) {
+		kfree(buf);
+		cf_name->name = NULL;
+		return -EINVAL;
 	}
 	cf_name->name = buf;
 	cf_name->len = (unsigned) len;
-- 
2.56.1.750.gf70dc682cf-goog

