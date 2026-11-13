Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794552824;
	b=S0MY3WeP9i/RYiNpmhaSwqwD45hpfpylGMUr6IuTkfbNJ0jJSPXxcMDTpwySHXwzwPQv
	 ktvTyixPutdP3qzoyoOhWqp9D7/8y2fM+0MO2+Ael2MuRNIUQAev65dCu3aouNsQ/y2Jk
	 F0+LghVoe/dbtqVHkCh8gq7fDZL8rtF5qZiYz2h8GwARdJhOh117WkW9KO3lbUlpXCag1
	 qGDyrr1r9pj/F2FuyjWa/qxQo+aNc44Ua6mES8C1l0mbNjS4VOm6Nd48VshIDXTZ6JbbK
	 +vRSmpq9qdEi5IBP2bRIId09/bXai4XA7SIMXZ9eRhRzXdrP9VUWHzNprEinGKYusvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794552824;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=32C0FxBlQriZemWnWfi76aDhbmP3Z0qG7c56b0ARCqE=;
	b=ZPCQjZnwblSDv6vpqCaDkPagiuHFFo5p2m9KrC+H8TCCeX8QxV0mjcQSuy6M376KoUAH
	 5ZP14aNfTjE35/MmvHRuFDAwIXIKhgKauCiD5t55b2K3IiR60vlkxwtWDfm0ENefeIEm6
	 rpoM8Mm0kl8E7J1wBwMPQY9tMuSzNzt6qI2hlWSxHIEFsHl4hYYhYJ20nsy3leGU4JmIj
	 uIiMCXrKho68Yf7oj/1i3NMMyuYSBqeI41a/vce/jj5goFxX8g5seLhE/4YoyYbgirG8G
	 CUJRn0dd8DWH1/w1rlTV7WbAw/7nPv/NdRqPAAQ9QPYCuepVB7O+OgrzTNul/xeReyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--sarthakkukreti.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=puR8RExC;
	arc=none smtp.remote-ip=74.125.82.198
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E10F606A332
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 06:53:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E10F606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sarthakkukreti.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=puR8RExC
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-33713e5e6daso653272eec.0
        for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 22:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794552823; x=1795157623; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=32C0FxBlQriZemWnWfi76aDhbmP3Z0qG7c56b0ARCqE=;
        b=puR8RExCfWpsSrtlzQgscyAHr42VjngI1jUKat4N0EXiaNr5o3suIcmS6Suse73Kky
         WGrp3p15oHj417hYAbWAE9w+qYMp7Kfbwc+D2qAg8+J4DE7c60mvTtVGWtAbU6rJYbKL
         oFCJPWfx3aNOgtv8ubQ+iWNhgcYidNAgmCd0BCdryRuFOXLgRvO6JvX7WTDE1rVS41BA
         QCYJAw0z55YSHa11pdGyKIU2IJS5ttde8BPZkVAoqTvw/3Ck2bWI8ttYdUORTMGhqRxg
         0UXcaaleJ8NbpnRZfliF/SloGNj7FBrXiy8TeQWv8ax8gLmPBmhxbW6eE2D0LU4CgT3i
         R9+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794552823; x=1795157623;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=32C0FxBlQriZemWnWfi76aDhbmP3Z0qG7c56b0ARCqE=;
        b=vRdaxHeBED5lpJYOk1ewQFfkvhQH2kCxXjQfreHWqLvWXHT5PUIpHQ2zrCQi1NGxZ7
         NKY8GurvwxmTmY+cZDlNAsxR1l4HrzBgDaOa9qjHXyx+HFQLic6JpaM1MPiWD6vKrxYf
         PaREPEK+bndk8NMe1oXUzMd+2m+52oP2vyYbCu5tK1SlFgQj1WhJG3k1w6mh0uEYdfRB
         rpVmhpgVQ8g7fswEQtTCol7/CCJlIaLnyL2lwqd1yJj/d1meGcc3Bg0sIknLu24NNyBA
         KprFtfngaR414S2plDLp83Uv1irPFHmpGBjyV9seo9PM23TgCIPu8fmQcgb3OhBqPH/o
         NFjQ==
X-Forwarded-Encrypted: i=1; AL+hErHI4YTKtE4XL8ANpS+t8MorFLCxelBloVWiBUISXZXcPOjXin1oCAnOBZ66HIv9Q+IG3MFwpUK0m4lc@vger.kernel.org
X-Gm-Message-State: APuU4Z/2owUQ/7vYibREazIHIjFZyhT3yOB1K/Qghoj410DqLxV7xPci
	khrsGLU6TtFXEODqRU8sLuQIW5bS0fV7GfVwxj4rz+cuB89fCx5QyBKlFoqTdICqkvS15La7UFb
	UuB12YMqbIRyAnxd3beJTAKRJLBPu2gEemsKC5g==
X-Received: from dyp12.prod.google.com ([2002:a05:693c:65cc:b0:36c:9b55:8436])
 (user=sarthakkukreti job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:1a05:b0:369:f035:661 with SMTP id 5a478bee46e88-37967315a1emr1295500eec.15.1794552822463;
 Thu, 12 Nov 2026 22:53:42 -0800 (PST)
Date: Thu, 12 Nov 2026 22:53:31 -0800
In-Reply-To: <20261113065332.929085-1-sarthakkukreti@google.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261113065332.929085-1-sarthakkukreti@google.com>
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261113065332.929085-3-sarthakkukreti@google.com>
Subject: [PATCH 2/3] ext4: reject casefolded names that fold to ".", "..", or empty
From: Sarthak Kukreti <sarthakkukreti@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>
Cc: Gabriel Krisman Bertazi <krisman@collabora.co.uk>, Eric Biggers <ebiggers@google.com>, 
	Dmitry Torokhov <dtor@google.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, 
	Sarthak Kukreti <sarthakkukreti@google.com>
Content-Type: text/plain; charset="UTF-8"

Filenames consisting solely of ignorable Unicode characters fold to
empty strings, while names with leading dots and ignorable characters
fold to "." or "..". Allowing such names to be created or looked up in
casefolded directories collides with on-disk "." and ".." entries (which
triggers EXT4_ERROR_INODE in ext4_lookup()) and introduces duplicate
entries that e2fsck flags as corruption.

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
index a6386c1d237f..096f78ea5df4 100644
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
2.56.0.611.g1030f0b940-goog

