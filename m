From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 27/74] libquota: fix memory leak
Date: Tue, 10 Dec 2013 17:21:21 -0800
Message-ID: <20131211012121.30655.38835.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26520 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3LKBV1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:21:27 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/quota/mkquota.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index a0d3a2a..3aa8100 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -230,6 +230,7 @@ errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype)
 		err = ext2fs_get_mem(sizeof(dict_t), &dict);
 		if (err) {
 			log_err("Failed to allocate dictionary");
+			quota_release_context(&ctx);
 			return err;
 		}
 		ctx->quota_dict[i] = dict;

