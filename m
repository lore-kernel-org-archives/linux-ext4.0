Return-Path: <SRS0=JWMb=RZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE16FC43381
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Mar 2019 09:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A329C218D3
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Mar 2019 09:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbfCVJci (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 22 Mar 2019 05:32:38 -0400
Received: from smtp-out-so.shaw.ca ([64.59.136.139]:39528 "EHLO
        smtp-out-so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727915AbfCVJch (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Mar 2019 05:32:37 -0400
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Mar 2019 05:32:37 EDT
Received: from cabot.adilger.int ([70.77.216.213])
        by shaw.ca with ESMTP
        id 7GPbhc7uLGusj7GPchnmgm; Fri, 22 Mar 2019 03:24:29 -0600
X-Authority-Analysis: v=2.3 cv=fOdHIqSe c=1 sm=1 tr=0
 a=BQvS1EmAg2ttxjPVUuc1UQ==:117 a=BQvS1EmAg2ttxjPVUuc1UQ==:17 a=ySfo2T4IAAAA:8
 a=lB0dNpNiAAAA:8 a=thxFCWJzFAOT7apkbWMA:9 a=SXCzXuTzgfc2xU4i:21
 a=PreYGR90gYLVzJGo:21 a=ZUkhVnNHqyo2at-WnAgH:22 a=c-ZiYqmG3AbHTdtsH08C:22
From:   Andreas Dilger <adilger@dilger.ca>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org, Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] mke2fs: allow 64bit feature without extents
Date:   Fri, 22 Mar 2019 03:24:27 -0600
Message-Id: <1553246667-53793-1-git-send-email-adilger@dilger.ca>
X-Mailer: git-send-email 1.8.0
X-CMAE-Envelope: MS4wfIPX50/9oSNtil52X+02+fvENTqKXFw2I9g2JIX3BoB/YcRct9Du7UyAXR2PWBgMwt0YJEIU5Lz7C6vwsChToXPl/CQIvIHWCrUQPWG9JoI85lmlHRra
 uB1+DxTTGIYMdY0RXMRkW+QBRg4zYped7JNR1nCXm39osrSLXkLZhXuI589vykpjoAcPgVmVbhXpK30nBSZ+0NU3De1gmdYKtEV06M3DSPRJbuGab2QPwHxd
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Andreas Dilger <adilger@whamcloud.com>

The 64bit feature should be allowed without extents to for 32-bit
metadata_csum checksums to be stored in the group descriptor.
Change the extents check to check for more than 2^32 blocks instead
of the 64bit feature flag.  This also avoids warnings later if the
metadata_csum feature is enabled on a filesystem without 64bit.

Consolidate repeated 64bit feature checks into one check.

The fs_blocks_count value is always set when parse_fs_type() is
called, so no need to check if it is zero.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
Reviewed-by: Li Dongyang <dongyangli@ddn.com>
Whamcloud-bug-id: https://jira.whamcloud.com/browse/LU-11609
Change-Id: Ie73ff0ed50cfed5d6a9596260c6b6dc32d3ebbe5
Reviewed-on: https://review.whamcloud.com/33897
---
 misc/mke2fs.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index f05003f..267e919 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1985,8 +1985,7 @@ profile_error:
 	 * be appropriately configured.
 	 */
 	fs_types = parse_fs_type(fs_type, usage_types, &fs_param,
-				 fs_blocks_count ? fs_blocks_count : dev_size,
-				 argv[0]);
+				 fs_blocks_count, argv[0]);
 	if (!fs_types) {
 		fprintf(stderr, "%s", _("Failed to parse fs types list\n"));
 		exit(1);
@@ -2118,29 +2117,30 @@ profile_error:
 	 * We now need to do a sanity check of fs_blocks_count for
 	 * 32-bit vs 64-bit block number support.
 	 */
-	if ((fs_blocks_count > MAX_32_NUM) &&
-	    ext2fs_has_feature_64bit(&fs_param))
-		ext2fs_clear_feature_resize_inode(&fs_param);
-	if ((fs_blocks_count > MAX_32_NUM) &&
-	    !ext2fs_has_feature_64bit(&fs_param) &&
-	    get_bool_from_profile(fs_types, "auto_64-bit_support", 0)) {
-		ext2fs_set_feature_64bit(&fs_param);
-		ext2fs_clear_feature_resize_inode(&fs_param);
-	}
-	if ((fs_blocks_count > MAX_32_NUM) &&
-	    !ext2fs_has_feature_64bit(&fs_param)) {
-		fprintf(stderr, _("%s: Size of device (0x%llx blocks) %s "
+	if (fs_blocks_count > MAX_32_NUM) {
+		if (!ext2fs_has_feature_64bit(&fs_param) &&
+		    get_bool_from_profile(fs_types, "auto_64-bit_support", 0))
+			ext2fs_set_feature_64bit(&fs_param);
+
+		if (ext2fs_has_feature_64bit(&fs_param)) {
+			ext2fs_clear_feature_resize_inode(&fs_param);
+		} else {
+			fprintf(stderr,
+				_("%s: Size of device (0x%llx blocks) %s "
 				  "too big to be expressed\n\t"
 				  "in 32 bits using a blocksize of %d.\n"),
-			program_name, fs_blocks_count, device_name,
-			EXT2_BLOCK_SIZE(&fs_param));
-		exit(1);
+				program_name, fs_blocks_count, device_name,
+				EXT2_BLOCK_SIZE(&fs_param));
+			exit(1);
+		}
 	}
+
 	/*
 	 * Guard against group descriptor count overflowing... Mostly to avoid
 	 * strange results for absurdly large devices.
 	 */
-	if (fs_blocks_count > ((1ULL << (fs_param.s_log_block_size + 3 + 32)) - 1)) {
+	if (fs_blocks_count >
+	    ((1ULL << (fs_param.s_log_block_size + 3 + 32)) - 1)) {
 		fprintf(stderr, _("%s: Size of device (0x%llx blocks) %s "
 				  "too big to create\n\t"
 				  "a filesystem using a blocksize of %d.\n"),
@@ -2213,13 +2213,13 @@ profile_error:
 		fs_param.s_feature_compat = 0;
 		fs_param.s_feature_ro_compat &=
 					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM;
- 	}
+	}
 
 	/* Check the user's mkfs options for 64bit */
-	if (ext2fs_has_feature_64bit(&fs_param) &&
+	if (fs_blocks_count > MAX_32_NUM &&
 	    !ext2fs_has_feature_extents(&fs_param)) {
-		printf("%s", _("Extents MUST be enabled for a 64-bit "
-			       "filesystem.  Pass -O extents to rectify.\n"));
+		printf("%s", _("Extents MUST be enabled for filesystems with "
+			       "over 2^32 blocks. Use '-O extents' to fix.\n"));
 		exit(1);
 	}
 
-- 
1.8.0

