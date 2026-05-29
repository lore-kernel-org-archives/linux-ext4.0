Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E893034F259;
	Fri, 29 May 2026 08:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780044231; cv=none; b=gaT/+6tC78FiJSCcStcDO3bi+GqiQY1OKjjl9CIrIwy6sFll1KxdNywiuQPFf6QcNGBeH28Y01thV3hr7FBwGqzrJkNTe8hUTxoBixZ94nPJ4CqHxXG6B/ozOfmE78BGvHcvGMwoX+ceEH8Lij1fK0wMg4w8vbrfs6hA5dNb0l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780044231; c=relaxed/simple;
	bh=bKCd+6WHWH/ZSdnFH3KA5lLqkOQMvZCMRNxWyxdxJt4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ry1VkxTbd3QCycfNsVKW3qciul1NTnoNlHfcD/cGRDr9kTG82TH89E7aGI7tJQF5fRXkLgeTFtTK5LKt9AcrjWlQhLa/lx3c7u3Uf1DASViMX+eGgA7NETmmcdhpMEqOQuC5Sw0kxLSw8zU+hinUTd+QnhRheQ60BKC/+1SL4vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XjlAh2YQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XjlAh2YQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999E91F00898;
	Fri, 29 May 2026 08:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780044230;
	bh=p8M0TmhL8WmjGsixmaToKhDU4wQeSVaKmSsVD37DIA8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XjlAh2YQzewH7JYly8FQ0BFULZ3K+dxK1MgEKec6N1LDubo5pTVM/OiguwQPIXApi
	 fdowUQ6V/CGTnARrT7P/8PalJX8inl+/bCkX9ZFBBdwlhP/pzvjKGveSOoVeGrwE/O
	 OvMSa5JKFwXgK4UY31O+AGBOTPpGMUlB+GDuy/H0G86glOXzkUBYd/1JseNg1qCK4U
	 +yzEGdBzy0Tqxt4+RMUS3GOMbWSQVwXVcb18Rx4cXo2gea3Oi0MbMR0IUlnWNGgHPp
	 siWJkyZUrg8JaXtjW+QNv4/yH5yg1+hyDgVtlxzDLhNHZhlu0P+XEzcYmg6CVSVqjg
	 z5OFu6wbkJ4dg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 29 May 2026 10:43:40 +0200
Subject: [PATCH v2 1/4] ext4: convert extents KUnit test to sget_fc()
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260529-work-sget-v2-1-57bbe08604e4@kernel.org>
References: <20260529-work-sget-v2-0-57bbe08604e4@kernel.org>
In-Reply-To: <20260529-work-sget-v2-0-57bbe08604e4@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, 
 linux-cifs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-fffa9
X-Developer-Signature: v=1; a=openpgp-sha256; l=2402; i=brauner@kernel.org;
 h=from:subject:message-id; bh=bKCd+6WHWH/ZSdnFH3KA5lLqkOQMvZCMRNxWyxdxJt4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRJBh5UKeA+lWadpBzp9Ga2zvEa1d6etvnmD2+VWVilX
 Dpsrj2/o5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCJPVBgZdrrOX3DmpdZrlVPr
 tQ4s6nvs1pQaLWv1QYrTbWOi7fHSboY/vCsiZeWfBjcy3midvCzuxcIDokHiH2P/6D/+2JvmL2T
 OCgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

The extents KUnit test uses sget() to get an initialized superblock for
its fake file_system_type. sget() predates fs_context and we want to
retire it. Switch this caller over to sget_fc().

Add a no-op ext_init_fs_context() so fs_context_for_mount() has
something to call on the fake fs_type. ext_set() now takes a struct
fs_context * (still a no-op). extents_kunit_init() allocates the fc,
hands it to sget_fc() and drops the fc reference once the sb is
published. sget_fc() does not retain a pointer to it.

No functional change for the test.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext4/extents-test.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index 6b53a3f39fcd..bd7795a82607 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -37,6 +37,7 @@
 
 #include <kunit/test.h>
 #include <kunit/static_stub.h>
+#include <linux/fs_context.h>
 #include <linux/gfp_types.h>
 #include <linux/stddef.h>
 
@@ -130,14 +131,20 @@ static void ext_kill_sb(struct super_block *sb)
 	generic_shutdown_super(sb);
 }
 
-static int ext_set(struct super_block *sb, void *data)
+static int ext_init_fs_context(struct fs_context *fc)
+{
+	return 0;
+}
+
+static int ext_set(struct super_block *sb, struct fs_context *fc)
 {
 	return 0;
 }
 
 static struct file_system_type ext_fs_type = {
-	.name = "extents test",
-	.kill_sb = ext_kill_sb,
+	.name		 = "extents test",
+	.init_fs_context = ext_init_fs_context,
+	.kill_sb	 = ext_kill_sb,
 };
 
 static void extents_kunit_exit(struct kunit *test)
@@ -223,6 +230,7 @@ static int extents_kunit_init(struct kunit *test)
 	struct ext4_inode_info *ei;
 	struct inode *inode;
 	struct super_block *sb;
+	struct fs_context *fc;
 	struct ext4_sb_info *sbi = NULL;
 	struct kunit_ext_test_param *param =
 		(struct kunit_ext_test_param *)(test->param_value);
@@ -232,7 +240,13 @@ static int extents_kunit_init(struct kunit *test)
 	if (sbi == NULL)
 		return -ENOMEM;
 
-	sb = sget(&ext_fs_type, NULL, ext_set, 0, NULL);
+	fc = fs_context_for_mount(&ext_fs_type, 0);
+	if (IS_ERR(fc)) {
+		kfree(sbi);
+		return PTR_ERR(fc);
+	}
+	sb = sget_fc(fc, NULL, ext_set);
+	put_fs_context(fc);
 	if (IS_ERR(sb)) {
 		kfree(sbi);
 		return PTR_ERR(sb);

-- 
2.47.3

