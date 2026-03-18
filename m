Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11CB34750B
	for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2026 07:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773820735; cv=none; b=FmKXbtckAglCY2GHMJMtOW95HOl05diNs+d06eKUtWp6f7L0yGf/2Wlqbo6qqb9jV+xFciiLuiaUmv32RYZbcA4bescZI/2BAicVa8ztSNMem48mMUpwJUTY0flizdVZDvF4tH+TRxwHwU2Fn8srVNhtuiuVQGUzWLPJJZyOHk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773820735; c=relaxed/simple;
	bh=+dxtWE1DwIgIzEHxMwSi9pwNrnQxZQGBzo8VT4ntRIA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=usouQcPqPeFZBCumrGFemeOeA5O21Qz96UB44QVy4g3vG8J19ul1y96ONIZlRm9NsEp0ooAs7O4kG+p7lQ9NNZ+odsoifujB+PIM44sBrVDmvc6ELuqtErob8PDeMGjcp0ZPtO4TJulXcDD0LXxBjSxHV+UwNtRawPdqt3KvzPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CoM/z0qM; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CoM/z0qM"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-35ba749f441so2353697a91.1
        for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2026 00:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773820734; x=1774425534; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HhVqm7dtmhIq5iMPEQ+RzAXpBXYN81Z6Q4RNXVVrMG8=;
        b=CoM/z0qMtFbq4/X7gHeRUYnGPf7z71khDevB8UwzCbpapQS3MkEBad5FtT2zX3uG9Y
         zQglQo5lHySGcmEUHSPYt/eLt0CuaCqPxb1yQAF1FAWCespFDwgpUaZicXTd7Snwdc2G
         a+CcR6/sozaWws4XASUidDNUFEMgdOf2j7gZjP6Fnd09OV72qoBotPz9lrjiHJ5MxHFD
         0vIgIAyaarNBNVbVUKy7N37CmlIbrAfMGgQTthKG/g+SXqt86RxqsZzzdKO5ARQND5Iv
         EBLcVS+MxFyTqJJ88k3T+b/AKmiHgNc8d6Ov32EAzkIggfGS6tDgdR3zzYNKEyEbXbTi
         pJ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773820734; x=1774425534;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HhVqm7dtmhIq5iMPEQ+RzAXpBXYN81Z6Q4RNXVVrMG8=;
        b=TMFV4eGp4rdz+GGMKsTgzDgPAJTcYBgosYraX/9gfK0PWekzjcxLgr8xi8OgzMIxK4
         5nNKC8Ex9u8WDzST8QjTpgUkZTFDRYYeT8qpk7fLqoBz6RCnzS1xmOS5pTyt8GRddkBT
         QJRvBZnOfJ4tw7l6Zjq1erROSzlM7TmYl4Z7ahRoAxVNpsiKK1tOzlPTU8nq4ukpeMZN
         HsXExauR6W5tcqREpWT9HqyD07GwH6BA6S6HvUX0vAJQW9izz2ycUT2dU01a+OAzZNYt
         SRgn0xhUvHW6XDOUDivrY19898T3MY0DazNPwooQ8REZIIrpifwDYjOUuL2SokHmiQ0A
         X6sQ==
X-Gm-Message-State: AOJu0YymsQMWLMj1EUlF6nr9J5APcWwPww/UrFZlgJAQZCWtj31FCNjN
	iwSCVpfP0EG9iQWVAjHlw01zg2gHYRS1YZn8MxUCRtV0rVMyOp8n2tN+
X-Gm-Gg: ATEYQzxiMspOaRheEIN4S7UntGb8/ApRVZiylp2YhBLWq+M8ktwwXmIQ7zeio4NeyMc
	kXhyQhLPLgM3pbsMYx115zwj/AIn2VYxmO+KNZPKfNtkKeF1hZ7LKjmBqj3QjYbsmQU3UyOkpjK
	oFkzheGgufh+N1jRCcGIhF3/2DlQgfTHa3UTnxL4N4PKXqX/cvR3oeK3xSgl24UhrQxYaGoYtYD
	5prwvDwcVrZ9C7p+BupU73VXsPEmneXG8VqCmjjdnSWdJP0q0v6sGI4Xe7eW3IvqP+zpU97QjjQ
	fqaniBy0qIpXhanLS1kdunJz4mP10zvxWh3PX5D28J6A63u41TUNFWutTLsOEpoTH9/3xTIUgUM
	ymiyww+sod+1JdkCFIDiO5Q36GlaSo2bN/jtKDLvBCsGzKFZzA8PUYISfGZTaPRUbUyi2+uQE19
	8qQDtDtnRjhykGbMkho9RPRYFafIqWECPj+NCkqklKUHDKL+vpIDzUdF6Zwy8Ei/oTMcTq1pg=
X-Received: by 2002:a17:902:ce11:b0:2ad:d5d7:bad2 with SMTP id d9443c01a7336-2b06e43709fmr25696775ad.48.1773820733922;
        Wed, 18 Mar 2026 00:58:53 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b06e41aad6sm17610545ad.16.2026.03.18.00.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 00:58:53 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	tahsin@google.com
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] ext4: xattr: fix out-of-bounds access in ext4_xattr_set_entry
Date: Wed, 18 Mar 2026 15:58:42 +0800
Message-ID: <20260318075842.3341370-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
KASAN reports show out-of-bounds and use-after-free memory accesses when
ext4_xattr_set_entry() processes corrupted on-disk xattr entries:

  BUG: KASAN: slab-out-of-bounds in ext4_xattr_set_entry+0xfc2/0x1f40 fs/ext4/xattr.c:1735
  Write of size 12 at addr ffff88801a249af4 [slab OOB]
  Call Trace:
    ...
    ext4_xattr_set_entry+0xfc2/0x1f40 fs/ext4/xattr.c:1735
    ext4_xattr_ibody_set+0x396/0x5a0 fs/ext4/xattr.c:2268
    ext4_destroy_inline_data_nolock+0x25e/0x560 fs/ext4/inline.c:463
    ext4_convert_inline_data_nolock+0x186/0xa80 fs/ext4/inline.c:1105
    ext4_try_add_inline_entry+0x58e/0x960 fs/ext4/inline.c:1224
    ext4_add_entry+0x6d2/0xce0 fs/ext4/namei.c:2389
    ext4_rename+0x133c/0x2490 fs/ext4/namei.c:3929
    ext4_rename2+0x1de/0x2c0 fs/ext4/namei.c:4208
    vfs_rename+0xd42/0x1d50 fs/namei.c:5216
    do_renameat2+0x715/0xb60 fs/namei.c:5364
    ...

  BUG: KASAN: use-after-free in ext4_xattr_set_entry+0xfd3/0x1f40 fs/ext4/xattr.c:1736
  Write of size 65796 at addr ffff88802feb6ee8 [UAF across page boundary]

[CAUSE]
During inode load, xattr_check_inode() validates the ibody xattr entries
found in the inode at that time, and ext4_read_inode_extra() sets
EXT4_STATE_XATTR after the validation succeeds.

Later, when updating an ibody xattr, ext4_xattr_ibody_find() does not rely
on those already validated contents. It calls ext4_get_inode_loc() and
reads the inode table block again, so the entry eventually passed to
ext4_xattr_set_entry() comes from a new on-disk read. xattr_find_entry()
may return that entry based on its name, but does not revalidate its
e_value_offs and e_value_size before they are dereferenced.

Therefore, if the inode table block is modified between inode load and the
later xattr update, the code ends up validating one version of the xattr
data and using another. ext4_xattr_set_entry() may then consume corrupted
e_value_offs/e_value_size fields from the newly read entry, which can cause
out-of-bounds accesses, size_t underflow, and use-after-free.

[FIX]
Fix this by validating the target entry's value offset and size in
ext4_xattr_set_entry() before using them. Reject invalid entries
with -EFSCORRUPTED, consistent with the checks already enforced by
check_xattrs() for ibody xattrs.

Fixes: dec214d00e0d7 ("ext4: xattr inode deduplication")
Cc: stable@vger.kernel.org
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ext4/xattr.c | 58 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index ce7253b3f549..3ebfe2dfcae9 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1638,6 +1638,48 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
 			EXT4_XATTR_SIZE(le32_to_cpu(here->e_value_size)) : 0;
 	new_size = (i->value && !in_inode) ? EXT4_XATTR_SIZE(i->value_len) : 0;
 
+	/* Compute min_offs and last. */
+	last = s->first;
+	for (; !IS_LAST_ENTRY(last); last = next) {
+		next = EXT4_XATTR_NEXT(last);
+		if ((void *)next >= s->end) {
+			EXT4_ERROR_INODE(inode, "corrupted xattr entries");
+			ret = -EFSCORRUPTED;
+			goto out;
+		}
+		if (!last->e_value_inum && last->e_value_size) {
+			size_t offs = le16_to_cpu(last->e_value_offs);
+
+			if (offs < min_offs)
+				min_offs = offs;
+		}
+	}
+
+	/*
+	 * Validate the value range before dereferencing e_value_offs / e_value_size.
+	 * This mirrors check_xattrs() for the entry we are about to touch.
+	 */
+	if (!s->not_found && !here->e_value_inum && here->e_value_size) {
+		u16 offs = le16_to_cpu(here->e_value_offs);
+		size_t size = le32_to_cpu(here->e_value_size);
+		void *value;
+
+		if (offs > s->end - s->base) {
+			EXT4_ERROR_INODE(inode, "corrupted xattr entry: invalid value offset");
+			ret = -EFSCORRUPTED;
+			goto out;
+		}
+
+		value = s->base + offs;
+		if (value < (void *)last + sizeof(__u32) ||
+		    size > s->end - value ||
+		    EXT4_XATTR_SIZE(size) > s->end - value) {
+			EXT4_ERROR_INODE(inode, "corrupted xattr entry: invalid value range");
+			ret = -EFSCORRUPTED;
+			goto out;
+		}
+	}
+
 	/*
 	 * Optimization for the simple case when old and new values have the
 	 * same padded sizes. Not applicable if external inodes are involved.
@@ -1657,22 +1699,6 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
 		goto update_hash;
 	}
 
-	/* Compute min_offs and last. */
-	last = s->first;
-	for (; !IS_LAST_ENTRY(last); last = next) {
-		next = EXT4_XATTR_NEXT(last);
-		if ((void *)next >= s->end) {
-			EXT4_ERROR_INODE(inode, "corrupted xattr entries");
-			ret = -EFSCORRUPTED;
-			goto out;
-		}
-		if (!last->e_value_inum && last->e_value_size) {
-			size_t offs = le16_to_cpu(last->e_value_offs);
-			if (offs < min_offs)
-				min_offs = offs;
-		}
-	}
-
 	/* Check whether we have enough space. */
 	if (i->value) {
 		size_t free;
-- 
2.43.0

