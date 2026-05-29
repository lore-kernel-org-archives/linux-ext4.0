Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6190434F259;
	Fri, 29 May 2026 08:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780044234; cv=none; b=rGlrrvhA5IbVNQVVYInrx9Fb1vqsv2Y+/mYIKqFntTsJOGu8e3sYdlDTC/5y4C7JPoetNikguYZp3A9ibS5Rqnn8f11WX0f4AaGmkMzBaMjG7E0bSx0xQNfJJD4Nj7RjuW1WvjRsogHsZ/fQsAWWY5Mh9XpUbBlGbmy2DTP/Eg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780044234; c=relaxed/simple;
	bh=jbv0e0UK8Foq77XiEZ0D9pv3i2mZ9QxiUA/GapR/NIc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=U5rEZzfKoPwgP36dux1k/I9iUIHwUAOKo+cv7Q5vTFuxf6vEphg/0Q20nQ1+ePUO+MsckW0SqCRwmVcQAJNxQN2KhOZvfxAg8k1XEE1yUsg8rZq1fBibukvrgpQneKTjx9PdLtOPE3FiIbJ+/c6AXsge7liEdK/6aWYckrcwjTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oVfZQCto; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oVfZQCto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145D91F00899;
	Fri, 29 May 2026 08:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780044233;
	bh=FoBKUDf7V4kIgk99vmo9HWfzrUU9xwOAAvRzErDHe48=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oVfZQCto+uOmnUcJJ3y6/kj2cgd0wuyXoi2cYk++lBZbgD8QDn6Y241LH9rqrI/Vk
	 l8l8AQZRyhInClCg41rIduGKmtYgPHWw/P6lNCpIv6JnaTvG9agPcW0evpuEAHn0Ne
	 R12OQNyP8a46eaHZkt2Lmnxe2UCU2eXfylO21mQHPzjPAwHd5FVcUMJaxMH1rm1V5r
	 jwl4/p6r3P56O+V/tUJgzo3Oz8EJ/5rSqIyYzBWfI94ERM+vGr4oKEXPfPQEUsRv5s
	 89Zbe52gnUGgYSgOmem3Qeb8/h3M7utNSYtd/VP/syyBfdP4fBljwW7+zu84pT3kic
	 e2TN3XcY3o9pw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 29 May 2026 10:43:41 +0200
Subject: [PATCH v2 2/4] ext4: convert mballoc KUnit test to sget_fc()
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260529-work-sget-v2-2-57bbe08604e4@kernel.org>
References: <20260529-work-sget-v2-0-57bbe08604e4@kernel.org>
In-Reply-To: <20260529-work-sget-v2-0-57bbe08604e4@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, 
 linux-cifs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-fffa9
X-Developer-Signature: v=1; a=openpgp-sha256; l=2130; i=brauner@kernel.org;
 h=from:subject:message-id; bh=jbv0e0UK8Foq77XiEZ0D9pv3i2mZ9QxiUA/GapR/NIc=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGoZUcHIRBxKcDWKclwSxsWCNLr2EC5/6qCvC9mKUjSvFrRbS
 Ih1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmoZUcEACgkQkcYbwGV43KLsCgD/fKbP
 O3dBKJkQATlt8Rl3pztqviDEy7hPYuzpUlo/9GEBAI2ywG696OzS5rAzkhst0s9qd4iAqVASz9a
 u9Op0JhcH
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Same treatment as the extents KUnit test. The mballoc test uses sget()
as a thin "give me an initialized superblock" wrapper for a fake
file_system_type. Move it onto sget_fc() so sget() can go away.

Add a no-op mbt_init_fs_context() so fs_context_for_mount() has
something to call on the fake fs_type. mbt_set() now takes a struct
fs_context * (still a no-op). mbt_ext4_alloc_super_block() allocates
the fc, hands it to sget_fc() and drops the fc reference once the sb
is published.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext4/mballoc-test.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc-test.c b/fs/ext4/mballoc-test.c
index 90ed505fa4b1..d90da44aadbd 100644
--- a/fs/ext4/mballoc-test.c
+++ b/fs/ext4/mballoc-test.c
@@ -5,6 +5,7 @@
 
 #include <kunit/test.h>
 #include <kunit/static_stub.h>
+#include <linux/fs_context.h>
 #include <linux/random.h>
 
 #include "ext4.h"
@@ -63,8 +64,14 @@ static void mbt_kill_sb(struct super_block *sb)
 	generic_shutdown_super(sb);
 }
 
+static int mbt_init_fs_context(struct fs_context *fc)
+{
+	return 0;
+}
+
 static struct file_system_type mbt_fs_type = {
 	.name			= "mballoc test",
+	.init_fs_context	= mbt_init_fs_context,
 	.kill_sb		= mbt_kill_sb,
 };
 
@@ -127,7 +134,7 @@ static void mbt_mb_release(struct super_block *sb)
 	kfree(sb->s_bdev);
 }
 
-static int mbt_set(struct super_block *sb, void *data)
+static int mbt_set(struct super_block *sb, struct fs_context *fc)
 {
 	return 0;
 }
@@ -136,13 +143,19 @@ static struct super_block *mbt_ext4_alloc_super_block(void)
 {
 	struct mbt_ext4_super_block *fsb;
 	struct super_block *sb;
+	struct fs_context *fc;
 	struct ext4_sb_info *sbi;
 
 	fsb = kzalloc_obj(*fsb);
 	if (fsb == NULL)
 		return NULL;
 
-	sb = sget(&mbt_fs_type, NULL, mbt_set, 0, NULL);
+	fc = fs_context_for_mount(&mbt_fs_type, 0);
+	if (IS_ERR(fc))
+		goto out;
+
+	sb = sget_fc(fc, NULL, mbt_set);
+	put_fs_context(fc);
 	if (IS_ERR(sb))
 		goto out;
 

-- 
2.47.3

