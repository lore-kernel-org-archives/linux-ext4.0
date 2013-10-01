From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 28/31] mke2fs: Complain about creating 64bit filesystems
 without extents
Date: Mon, 30 Sep 2013 18:29:46 -0700
Message-ID: <20131001012946.28415.19973.stgit@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38295 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613Ab3JAB3v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:29:51 -0400
In-Reply-To: <20131001012642.28415.89353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A 64bit filesystem without extents is not terribly useful, because the old
block map format does not support pointing to high block numbers.  Warn the
user who tries to create such an animal.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/mke2fs.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index d8bd5ed..1e44a84 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2460,6 +2460,18 @@ int main (int argc, char *argv[])
 				 "checksumming.  Pass -O 64bit to rectify.\n"));
 	}
 
+	/* Check the user's mkfs options for 64bit */
+	if (!quiet &&
+	    EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+			EXT4_FEATURE_INCOMPAT_64BIT) &&
+	    !EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+			EXT3_FEATURE_INCOMPAT_EXTENTS)) {
+		printf(_("Extents MUST be enabled for a 64-bit filesystem to "
+			 "be able to access the entire disk space.  Pass "
+			 "-O extents to rectify.\n"));
+		exit(1);
+	}
+
 	/* Calculate journal blocks */
 	if (!journal_device && ((journal_size) ||
 		(fs_param.s_feature_compat &

