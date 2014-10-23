From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 6/6] quotaio: annotate & fix up for sparse endian checker
Date: Thu, 23 Oct 2014 16:29:49 -0500
Message-ID: <5449734D.4030705@redhat.com>
References: <54497296.8000708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbaJWV3u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Oct 2014 17:29:50 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9NLToCK001772
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Thu, 23 Oct 2014 17:29:50 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.rdu2.redhat.com [10.11.146.1])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s9NLTn0r015339
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 23 Oct 2014 17:29:50 -0400
In-Reply-To: <54497296.8000708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/quota/quotaio_tree.c |   10 +++++-----
 lib/quota/quotaio_v2.c   |    7 ++++---
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/lib/quota/quotaio_tree.c b/lib/quota/quotaio_tree.c
index 4d7a9ab..e7f3e95 100644
--- a/lib/quota/quotaio_tree.c
+++ b/lib/quota/quotaio_tree.c
@@ -254,7 +254,7 @@ static int do_insert_tree(struct quota_handle *h, struct dquot *dquot,
 {
 	dqbuf_t buf;
 	int newson = 0, newact = 0;
-	__u32 *ref;
+	__le32 *ref;
 	unsigned int newblk;
 	int ret = 0;
 
@@ -274,7 +274,7 @@ static int do_insert_tree(struct quota_handle *h, struct dquot *dquot,
 		read_blk(h, *treeblk, buf);
 	}
 
-	ref = (__u32 *) buf;
+	ref = (__le32 *) buf;
 	newblk = ext2fs_le32_to_cpu(ref[get_index(dquot->dq_id, depth)]);
 	if (!newblk)
 		newson = 1;
@@ -397,7 +397,7 @@ static void remove_tree(struct quota_handle *h, struct dquot *dquot,
 {
 	dqbuf_t buf = getdqbuf();
 	unsigned int newblk;
-	__u32 *ref = (__u32 *) buf;
+	__le32 *ref = (__le32 *) buf;
 
 	if (!buf)
 		return;
@@ -473,7 +473,7 @@ static ext2_loff_t find_tree_dqentry(struct quota_handle *h,
 {
 	dqbuf_t buf = getdqbuf();
 	ext2_loff_t ret = 0;
-	__u32 *ref = (__u32 *) buf;
+	__le32 *ref = (__le32 *) buf;
 
 	if (!buf)
 		return -ENOMEM;
@@ -597,7 +597,7 @@ static int report_tree(struct dquot *dquot, unsigned int blk, int depth,
 {
 	int entries = 0, i;
 	dqbuf_t buf = getdqbuf();
-	__u32 *ref = (__u32 *) buf;
+	__le32 *ref = (__le32 *) buf;
 
 	if (!buf)
 		return 0;
diff --git a/lib/quota/quotaio_v2.c b/lib/quota/quotaio_v2.c
index e7bf29c..504b3ea 100644
--- a/lib/quota/quotaio_v2.c
+++ b/lib/quota/quotaio_v2.c
@@ -151,6 +151,7 @@ static int v2_check_file(struct quota_handle *h, int type, int fmt)
 {
 	struct v2_disk_dqheader dqh;
 	int file_magics[] = INITQMAGICS;
+	int be_magic;
 
 	if (fmt != QFMT_VFS_V1)
 		return 0;
@@ -158,9 +159,9 @@ static int v2_check_file(struct quota_handle *h, int type, int fmt)
 	if (!v2_read_header(h, &dqh))
 		return 0;
 
-	if (ext2fs_le32_to_cpu(dqh.dqh_magic) != file_magics[type]) {
-		if (ext2fs_be32_to_cpu(dqh.dqh_magic) == file_magics[type])
-			log_err("Your quota file is stored in wrong endianity");
+	be_magic = ext2fs_be32_to_cpu((__force __be32)dqh.dqh_magic);
+	if (be_magic == file_magics[type]) {
+		log_err("Your quota file is stored in wrong endianity");
 		return 0;
 	}
 	if (V2_VERSION != ext2fs_le32_to_cpu(dqh.dqh_version))
-- 1.7.1

