Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795124992;
	b=b2i9actif85XHyqGMSCOe4c13G0kpJH6Ys/ruF8wU90gQ1fB60Qz1dIstEnQGiPlCEiB
	 pDNHxmw5Jt+QxF61ZErWh4AYjjR5avMW0SIhoy/1etnacxo+fRxYZhQ18Vqpsjfuw5fNj
	 nFFK02E0x/JIaxMq80LGIJY3vbA/2OgH+NxnahsFmzUjfYaJkH/ah+l6n9rlxmZ7mCtfV
	 ViBxJn7BiMhRvHwg/ZdIt99RyO9Y21tYYtb6RTV1vDKr2qjtv4zlXrYwWSITufILNblSR
	 AtGzXF3aOaW+8Vj9QrN1u6rrhQCXUn3MNXe5tyF9CKfWWhz7kr2JjY7tZ24BavFZUnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795124992;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=F+2hOopmrqVojtJDaVmiIa/Ykk5HH2rozBQfm3Mp9xM=;
	b=WItnIRyllaAaLRgynFb6f1pKeOIa9avd9hyC1GP56gLGxuT12MUIeYkDqWJPv602QuFn
	 echSAE+073lX8OBG803+SU740BN9mQj5b0V4WFsez3cJat/ZAteNPCagouTt+2Mzl4k2o
	 +qOnF8i4A7vTnJX21ucvQ6a1uMuFNao0qMO/7rdux0R+bFNZBCnAdlZ1UgtUikD8Bt9ZO
	 ZaYHEhw2ayC45greP5VDhM74FXtHH/gqLE8wWhaa64F2g7PFzmal3p+drJATo96UjkHvO
	 6vR4zYOEbwE1kak83v6k1ullJqX/q+XkyRRIDo9Q8gfiI0b6yXNeKXYQFbpin6uL4wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--sarthakkukreti.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="C8Xs9oU/";
	arc=none smtp.remote-ip=74.125.82.72
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817B9606A339
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 21:49:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 817B9606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sarthakkukreti.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=C8Xs9oU/
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-16bc6f3fdb1so157772c88.0
        for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 13:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795124991; x=1795729791; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F+2hOopmrqVojtJDaVmiIa/Ykk5HH2rozBQfm3Mp9xM=;
        b=C8Xs9oU/SvNp+LpI8BZI5uGxKx1KiEp8jT/SeS4RJV9Wqzb20NMn4Tzh49N7tEKSsT
         dlA26Z1pBAUkOm2afQjDQoQrp/04RkOkzG+vdOnJljdiLyFNlk4xwYA/9aIObQ3M8LqJ
         Ey9eIcf+9Od/mmQKgBH4beICR8Xla4HuhDOESi+Zjg10w7GzfomOvrMutZfgCHCzm5I2
         8BQSmhwOVPytHBZUXYowbbU8Fdw1WmTeG7EeF/deW2keHJrCPkAwFbaWXqVkr9eSv+ez
         9eXzyYNrCJdChCYAeN48RrvXM0Bgvgj6YVzB9dBBRS2cUckYrr0twiV0ibw3VImUsDtN
         Q9Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795124991; x=1795729791;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F+2hOopmrqVojtJDaVmiIa/Ykk5HH2rozBQfm3Mp9xM=;
        b=FKO0iLTjfn0LH2buUsmBve+fMYMuxs/nr21wycM5OUD0U7/P0SgXblqNjfOGkBZlSl
         U+lSd7ae+jSY7OJtQV4VcqOuCsPe/FwYLU+cfgVHjw21COhhuUX6t0RIgwOU8IC5KU5X
         8J5m1fu5BnHOL00Pgpj36w0X6OBBHzjom8dFWyJJWct1wcu6C6JepfBSOWEZRpfnYKZi
         gUPU4KLNRG1RyTnxN/yRQfxyc7RYzF5nx4zO2CXwE+6TKJzpfftDb+Lk3ddRsFWBmuzz
         3Dgm1QiwSyzRQqxZs1HPy6Il3i5aE4nYJW/Hat/7qZlNsKsHKlpH+bbrcNi83TpDVsaO
         Q81A==
X-Forwarded-Encrypted: i=1; AL+hErGJ2V6zDosEDd3HQ/el1QBsWfDr41mnNOzaDh3fuk80eYI+8VPO3LaPa/X3Fb9Xma5hEgtA6k2j+uK8@vger.kernel.org
X-Gm-Message-State: APuU4Z9EuWKNVkFf43HGW+DpomxO3MPvHFY8oEn3+4E7Adz13zd5/x0q
	/UtFrx6AqmlN/Pga5VgfMR2SN0e/QlKI9kHtNkFLylmerpBR60mr5vKGH3iR1UqfwZri4EOjZV6
	MS7i2V8B982aWS0ykHSAH4nFSOq1d62CtTAUeGQ==
X-Received: from dlbrl2.prod.google.com ([2002:a05:7022:f502:b0:1a3:c305:2584])
 (user=sarthakkukreti job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:2209:b0:1b2:43ac:d3a3 with SMTP id a92af1059eb24-1b5568b9e59mr1130134c88.24.1795124991172;
 Thu, 19 Nov 2026 13:49:51 -0800 (PST)
Date: Thu, 19 Nov 2026 13:49:42 -0800
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
Message-ID: <20261119214944.1480596-2-sarthakkukreti@google.com>
Subject: [PATCH v2 1/3] libfs: reject casefolded names that fold to ".", "..",
 or empty
From: Sarthak Kukreti <sarthakkukreti@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>, Eric Biggers <ebiggers@kernel.org>, 
	Dmitry Torokhov <dtor@google.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, 
	Sarthak Kukreti <sarthakkukreti@google.com>
Content-Type: text/plain; charset="UTF-8"

Unicode normalization and casefolding (utf8_casefold()) strips code
points with the Default_Ignorable_Code_Point property. As a result:

1. A filename consisting of "." or ".." followed by ignorable characters
   (e.g. ".\xe2\x80\xae" or "..\xe2\x80\xae") bypasses VFS special-entry
   handling during path walk, but casefolds to "." or "..".
2. A filename consisting solely of ignorable characters (e.g.
   "\xe2\x80\xae") casefolds to the empty string "" (length 0), causing
   any two distinct ignorable-only filenames to compare and hash as
   equal.

Update generic_ci_d_hash(), generic_ci_match(), and
generic_ci_validate_strict_name() to reject case-insensitive hashing,
matching, and creation of filenames that casefold to "", ".", or "..",
while preserving exact byte-equality matches (such as NFS export lookups
of literal ".."). Using a 3-byte stack buffer with utf8_casefold()
detects all three cases in O(1) space without heap allocations.

Fixes: b886ee3e778e ("ext4: Support case-insensitive file name lookups")
Fixes: 2c2eb7a300cd ("f2fs: Support case-insensitive file name lookups")
Fixes: c843843e714c ("fs: Add standard casefolding support")
Co-developed-by: Dmitry Torokhov <dtor@google.com>
Signed-off-by: Dmitry Torokhov <dtor@google.com>
Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>
---
 fs/libfs.c         | 32 +++++++++++++++++++++++++++++---
 include/linux/fs.h | 31 ++++++++++++++++++-------------
 2 files changed, 47 insertions(+), 16 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 46e0205154e7..77997f88e475 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1828,13 +1828,21 @@ int generic_ci_d_hash(const struct dentry *dentry, struct qstr *str)
 	const struct inode *dir = READ_ONCE(dentry->d_inode);
 	struct super_block *sb = dentry->d_sb;
 	const struct unicode_map *um = sb->s_encoding;
+	unsigned char buf[3];
 	int ret;
 
 	if (!dir || !IS_CASEFOLDED(dir))
 		return 0;
 
 	ret = utf8_casefold_hash(um, dentry, str);
-	if (ret < 0 && sb_has_strict_encoding(sb))
+	if (ret < 0) {
+		if (sb_has_strict_encoding(sb))
+			return -EINVAL;
+		return 0;
+	}
+
+	ret = utf8_casefold(um, str, buf, sizeof(buf));
+	if (ret == 0 || (ret > 0 && name_is_dot_dotdot(buf, ret)))
 		return -EINVAL;
 	return 0;
 }
@@ -1907,10 +1915,28 @@ int generic_ci_match(const struct inode *parent,
 	    !memcmp(name->name, dirent.name, dirent.len))
 		goto out;
 
-	if (folded_name->name)
+	if (name_is_dot_dotdot(dirent.name, dirent.len) ||
+	    name_is_dot_dotdot(name->name, name->len) ||
+	    (folded_name->name &&
+	     (!folded_name->len ||
+	      name_is_dot_dotdot(folded_name->name, folded_name->len)))) {
+		res = 1;
+		goto out;
+	}
+
+	if (folded_name->name) {
 		res = utf8_strncasecmp_folded(um, folded_name, &dirent);
-	else
+	} else {
+		unsigned char buf[3];
+		int cf_len = utf8_casefold(um, name, buf, sizeof(buf));
+
+		if (cf_len == 0 ||
+		    (cf_len > 0 && name_is_dot_dotdot(buf, cf_len))) {
+			res = 1;
+			goto out;
+		}
 		res = utf8_strncasecmp(um, name, &dirent);
+	}
 
 out:
 	kfree(decrypted_name.name);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5b3a100aba77..22c411e046ce 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3368,28 +3368,26 @@ int generic_ci_d_compare(const struct dentry *dentry, unsigned int len,
  * generic_ci_validate_strict_name - Check if a given name is suitable
  * for a directory
  *
- * This functions checks if the proposed filename is valid for the
- * parent directory. That means that only valid UTF-8 filenames will be
- * accepted for casefold directories from filesystems created with the
- * strict encoding flag.  That also means that any name will be
- * accepted for directories that doesn't have casefold enabled, or
- * aren't being strict with the encoding.
+ * This function checks if the proposed filename is valid for the
+ * parent directory. Names that casefold to "", ".", or ".." are
+ * rejected for all casefolded directories. When the filesystem is
+ * created with the strict encoding flag, only valid UTF-8 filenames
+ * are accepted for casefolded directories.
  *
  * @dir: inode of the directory where the new file will be created
  * @name: name of the new file
  *
  * Return:
- * * True: if the filename is suitable for this directory. It can be
- *   true if a given name is not suitable for a strict encoding
- *   directory, but the directory being used isn't strict
- * * False if the filename isn't suitable for this directory. This only
- *   happens when a directory is casefolded and the filesystem is strict
- *   about its encoding.
+ * * True: if the filename is suitable for this directory.
+ * * False: if the filename isn't suitable for this directory.
  */
 static inline bool generic_ci_validate_strict_name(struct inode *dir,
 						   const struct qstr *name)
 {
-	if (!IS_CASEFOLDED(dir) || !sb_has_strict_encoding(dir->i_sb))
+	unsigned char buf[3];
+	int len;
+
+	if (!IS_CASEFOLDED(dir))
 		return true;
 
 	/*
@@ -3399,6 +3397,13 @@ static inline bool generic_ci_validate_strict_name(struct inode *dir,
 	if (WARN_ON_ONCE(!dir->i_sb->s_encoding))
 		return true;
 
+	len = utf8_casefold(dir->i_sb->s_encoding, name, buf, sizeof(buf));
+	if (len == 0 || (len > 0 && name_is_dot_dotdot(buf, len)))
+		return false;
+
+	if (!sb_has_strict_encoding(dir->i_sb))
+		return true;
+
 	return !utf8_validate(dir->i_sb->s_encoding, name);
 }
 #else
-- 
2.56.1.750.gf70dc682cf-goog

