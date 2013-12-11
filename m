From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 06/74] tune2fs: forbid changing uuid on an uninit_bg filesystem
Date: Tue, 10 Dec 2013 17:18:57 -0800
Message-ID: <20131211011857.30655.20986.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42167 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3LKBTD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:19:03 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The old uninit_bg checksums depend on the UUID, so prohibit changes to
the UUID if a checksumming filesystem is mounted, because this
introduces a nasty race where the kernel and tune2fs are both trying
to rewrite group descriptors at the same time, with different ideas
about what the UUID is.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/tune2fs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 1ae0ee6..111a43d 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -2653,8 +2653,7 @@ retry_open:
 		int set_csum = 0;
 		dgrp_t i;
 
-		if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+		if (ext2fs_has_group_desc_csum(fs)) {
 			/*
 			 * Changing the UUID requires rewriting all metadata,
 			 * which can race with a mounted fs.  Don't allow that.

