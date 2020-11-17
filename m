Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FA15C64E90
	for <linux-ext4@archiver.kernel.org>; Tue, 17 Nov 2020 04:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10A462468F
	for <linux-ext4@archiver.kernel.org>; Tue, 17 Nov 2020 04:03:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="shg3+cQ9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgKQEDX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 16 Nov 2020 23:03:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727188AbgKQEDV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Nov 2020 23:03:21 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C356C0617A6
        for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2020 20:03:21 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id u37so23555589ybi.15
        for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2020 20:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=26rm8pP8X1eqyqMFHjed3HgpBJsgTLVuVg1p5M5T4ac=;
        b=shg3+cQ9HKM0nPNtrMQTh+D5eQYXxiRjQHiCYna15DnDwGSI4q6hNF86FmwmCYrJ09
         0uszwptNamjvsfa2d+Ebp170YA7jdMrfds4LdsowSETcYPuptonfbiP7v8hpd4Y0MZkg
         TcH5aai3GlIlPjDRJOutLlBhbMbEKGMg5F5w3kD5/X0fqC2FyU3uSCyFeDu5RIXt/ixa
         9s2Vzm7JxAfAo2lWEtY1zChL12tD9p7+0mwGYHx+TBdw2Ath0P70x0MCBOufxM8RBgRH
         D/gZzY+rDOJ3wmUNZ5lYBs7E1V5A8uxoYtCXmruoFljhdbJ8IaBIehg5VrO1VZ4lsbQk
         6BPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=26rm8pP8X1eqyqMFHjed3HgpBJsgTLVuVg1p5M5T4ac=;
        b=NVMmRPqqWRfhQt/W6+Vimb8/++P2jSB/tGmq6i29/QqVqmLG1WpQxqYHfna1aXx9B8
         m8YQiArdSLyh8DudOxsW3dxEcOUvzAkjYg3MIQLE8vj5cO+OJiUxyyYknJ8/UxlXNqtw
         rPFeiEMZ7YzYiTGoF4rRasF4zrg+adUcU6lFXVZM5YsniSpjU8DDydS7UvbhIl8KbVRw
         y7kzSJJjfYclZQvY2Sp3OoB+RlZ0ZgmVUynCOEL+CGnfD9hzTblyGn/AIyFbnZWn83LU
         KnNJHnLFaEL5fYhfSKnEazGAA/YKmnUhVQQxS5iSGq+WYL6KehZ81a/CHKkGztSr9P30
         BmkQ==
X-Gm-Message-State: AOAM531k9orN0u3XFzo7MjZCoRNCM/O2nGqyuXe+Zr1J8rtGlrFHLygJ
        9BGECBfHWUfOVJ1ZERrDGVEAIcVN0G8=
X-Google-Smtp-Source: ABdhPJzKALm1EBPTQ18K+cplc9Rj54/XCyTrRJBcCgve7DfHa3FcRADsKoXoWVc+0ELNdGgH6frN1aEubL8=
Sender: "drosen via sendgmr" <drosen@drosen.c.googlers.com>
X-Received: from drosen.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:4e6f])
 (user=drosen job=sendgmr) by 2002:a25:88a:: with SMTP id 132mr26330262ybi.215.1605585800711;
 Mon, 16 Nov 2020 20:03:20 -0800 (PST)
Date:   Tue, 17 Nov 2020 04:03:13 +0000
In-Reply-To: <20201117040315.28548-1-drosen@google.com>
Message-Id: <20201117040315.28548-2-drosen@google.com>
Mime-Version: 1.0
References: <20201117040315.28548-1-drosen@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [PATCH v2 1/3] libfs: Add generic function for setting dentry_ops
From:   Daniel Rosenberg <drosen@google.com>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Chao Yu <chao@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Richard Weinberger <richard@nod.at>,
        linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com, Daniel Rosenberg <drosen@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This adds a function to set dentry operations at lookup time that will
work for both encrypted filenames and casefolded filenames.

A filesystem that supports both features simultaneously can use this
function during lookup preparations to set up its dentry operations once
fscrypt no longer does that itself.

Currently the casefolding dentry operation are always set if the
filesystem defines an encoding because the features is toggleable on
empty directories. Since we don't know what set of functions we'll
eventually need, and cannot change them later, we add just add them.

Signed-off-by: Daniel Rosenberg <drosen@google.com>
---
 fs/libfs.c         | 60 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |  1 +
 2 files changed, 61 insertions(+)

diff --git a/fs/libfs.c b/fs/libfs.c
index fc34361c1489..dd8504f3ff5d 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1449,4 +1449,64 @@ int generic_ci_d_hash(const struct dentry *dentry, struct qstr *str)
 	return 0;
 }
 EXPORT_SYMBOL(generic_ci_d_hash);
+
+static const struct dentry_operations generic_ci_dentry_ops = {
+	.d_hash = generic_ci_d_hash,
+	.d_compare = generic_ci_d_compare,
+};
 #endif
+
+#ifdef CONFIG_FS_ENCRYPTION
+static const struct dentry_operations generic_encrypted_dentry_ops = {
+	.d_revalidate = fscrypt_d_revalidate,
+};
+#endif
+
+#if IS_ENABLED(CONFIG_UNICODE) && IS_ENABLED(CONFIG_FS_ENCRYPTION)
+static const struct dentry_operations generic_encrypted_ci_dentry_ops = {
+	.d_hash = generic_ci_d_hash,
+	.d_compare = generic_ci_d_compare,
+	.d_revalidate = fscrypt_d_revalidate,
+};
+#endif
+
+/**
+ * generic_set_encrypted_ci_d_ops - helper for setting d_ops for given dentry
+ * @dentry:	dentry to set ops on
+ *
+ * This function sets the dentry ops for the given dentry to handle both
+ * casefolded and encrypted dentry names.
+ *
+ * Encryption requires d_revalidate to remove nokey names once the key is present.
+ * Casefolding is toggleable on an empty directory. Since we can't change the
+ * operations later on, we just add the casefolding ops if the filesystem defines an
+ * encoding.
+ */
+void generic_set_encrypted_ci_d_ops(struct dentry *dentry)
+{
+#ifdef CONFIG_FS_ENCRYPTION
+	bool needs_encrypt_ops = dentry->d_flags & DCACHE_NOKEY_NAME;
+#endif
+#ifdef CONFIG_UNICODE
+	bool needs_ci_ops = dentry->d_sb->s_encoding;
+#endif
+#if defined(CONFIG_FS_ENCRYPTION) && defined(CONFIG_UNICODE)
+	if (needs_encrypt_ops && needs_ci_ops) {
+		d_set_d_op(dentry, &generic_encrypted_ci_dentry_ops);
+			return;
+	}
+#endif
+#ifdef CONFIG_FS_ENCRYPTION
+	if (needs_encrypt_ops) {
+		d_set_d_op(dentry, &generic_encrypted_dentry_ops);
+		return;
+	}
+#endif
+#ifdef CONFIG_UNICODE
+	if (needs_ci_ops) {
+		d_set_d_op(dentry, &generic_ci_dentry_ops);
+		return;
+	}
+#endif
+}
+EXPORT_SYMBOL(generic_set_encrypted_ci_d_ops);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8667d0cdc71e..11345e66353b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3202,6 +3202,7 @@ extern int generic_ci_d_hash(const struct dentry *dentry, struct qstr *str);
 extern int generic_ci_d_compare(const struct dentry *dentry, unsigned int len,
 				const char *str, const struct qstr *name);
 #endif
+extern void generic_set_encrypted_ci_d_ops(struct dentry *dentry);
 
 #ifdef CONFIG_MIGRATION
 extern int buffer_migrate_page(struct address_space *,
-- 
2.29.2.299.gdc1121823c-goog

