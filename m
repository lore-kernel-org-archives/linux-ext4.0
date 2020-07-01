Return-Path: <SRS0=IASA=AM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9685C433E0
	for <linux-ext4@archiver.kernel.org>; Wed,  1 Jul 2020 15:35:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A086D20760
	for <linux-ext4@archiver.kernel.org>; Wed,  1 Jul 2020 15:35:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732072AbgGAPfF (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 1 Jul 2020 11:35:05 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:42755 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731399AbgGAPfE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Jul 2020 11:35:04 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id BF11E20003;
        Wed,  1 Jul 2020 15:35:01 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     linux-ext4@vger.kernel.org, tytso@mit.edu
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        matthew.weber@rockwellcollins.com, thomas.petazzoni@bootlin.com
Subject: [PATCH] create_inode: set xattrs to the root directory as well
Date:   Wed,  1 Jul 2020 17:34:04 +0200
Message-Id: <20200701153404.1647002-1-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

__populate_fs do copy the xattrs for all files and directories, but the
root directory is skipped and as a result its extended attributes aren't
set. This is an issue when using mkfs to build a full system image that
can be used with SElinux in enforcing mode without making any runtime
fix at first boot.

This patch adds logic to set the root directory's extended attributes.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 misc/create_inode.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/misc/create_inode.c b/misc/create_inode.c
index e8d1df6b55a5..0a6e4dc23d16 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -820,7 +820,29 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
 
 	for (i = 0; i < num_dents; free(dent[i]), i++) {
 		name = dent[i]->d_name;
-		if ((!strcmp(name, ".")) || (!strcmp(name, "..")))
+		if (!strcmp(name, ".")) {
+			retval = ext2fs_namei(fs, root, parent_ino, ".", &ino);
+			if (retval) {
+				com_err(name, retval, 0);
+					goto out;
+			}
+
+			/*
+			 * Take special care for the root directory, to copy its
+			 * extended attributes.
+			 */
+			if (ino == root) {
+				retval = set_inode_xattr(fs, ino, ".");
+				if (retval) {
+					com_err(__func__, retval,
+						_("while setting xattrs for ."));
+					goto out;
+				}
+			}
+
+			continue;
+		}
+		if (!strcmp(name, ".."))
 			continue;
 		if (lstat(name, &st)) {
 			retval = errno;
-- 
2.26.2

