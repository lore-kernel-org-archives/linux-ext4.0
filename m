From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2undo: fix endian issues
Date: Thu, 16 Jun 2016 17:51:04 -0500
Message-ID: <fe6468da-e719-2d83-579a-e8bab91c0a99@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbcFPWvF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jun 2016 18:51:05 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 7CBF5693F2
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jun 2016 22:51:05 +0000 (UTC)
Received: from [IPv6:::1] (ovpn03.gateway.prod.ext.phx2.redhat.com [10.5.9.3])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u5GMp4YW007256
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jun 2016 18:51:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Two new e2undo issues exist in the latest release on big endian
machines.

>From sparse check:

undo_io.c:157:26: warning: invalid assignment: |=
undo_io.c:157:26:    left side has type restricted __le32
undo_io.c:157:26:    right side has type int
undo_io.c:161:26: warning: invalid assignment: &=
undo_io.c:161:26:    left side has type restricted __le32
undo_io.c:161:26:    right side has type int

e2undo.c:211:16: warning: cast to restricted __le64
e2undo.c:211:16: warning: cast from restricted blk64_t
e2undo.c:212:16: warning: cast to restricted __le64
e2undo.c:212:16: warning: cast from restricted blk64_t

Addresses-RedHat-Bugzilla: 1344636
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/lib/ext2fs/undo_io.c b/lib/ext2fs/undo_io.c
index f921218..776d5b8 100644
--- a/lib/ext2fs/undo_io.c
+++ b/lib/ext2fs/undo_io.c
@@ -154,11 +154,11 @@ struct undo_private_data {
 #define E2UNDO_FEATURE_COMPAT_FS_OFFSET 0x1	/* the filesystem offset */
 
 static inline void e2undo_set_feature_fs_offset(struct undo_header *header) {
-	header->f_compat |= E2UNDO_FEATURE_COMPAT_FS_OFFSET;
+	header->f_compat |= ext2fs_le32_to_cpu(E2UNDO_FEATURE_COMPAT_FS_OFFSET);
 }
 
 static inline void e2undo_clear_feature_fs_offset(struct undo_header *header) {
-	header->f_compat &= ~E2UNDO_FEATURE_COMPAT_FS_OFFSET;
+	header->f_compat &= ~ext2fs_le32_to_cpu(E2UNDO_FEATURE_COMPAT_FS_OFFSET);
 }
 
 static io_manager undo_io_backing_manager;
diff --git a/misc/e2undo.c b/misc/e2undo.c
index a8cb000..6fb6e44 100644
--- a/misc/e2undo.c
+++ b/misc/e2undo.c
@@ -208,8 +208,7 @@ static int key_compare(const void *a, const void *b)
 
 	ka = a;
 	kb = b;
-	return ext2fs_le64_to_cpu(ka->fsblk) -
-	       ext2fs_le64_to_cpu(kb->fsblk);
+	return ka->fsblk - kb->fsblk;
 }
 
 static int e2undo_setup_tdb(const char *name, io_manager *io_ptr)

