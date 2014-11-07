From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 15/47] misc: don't allow mk_hugefiles unless the fs supports
 extents
Date: Fri, 07 Nov 2014 13:52:24 -0800
Message-ID: <20141107215224.883.32873.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35764 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbaKGVw2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:52:28 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The current mk_hugefile code in mke2fs doesn't support creating
non-extent files, so disable the functionality when we're mkfs'ing
without extent support.

The fallocate patches further on will eliminate the need for this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/mk_hugefiles.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/misc/mk_hugefiles.c b/misc/mk_hugefiles.c
index 3e4274c..9097b7c 100644
--- a/misc/mk_hugefiles.c
+++ b/misc/mk_hugefiles.c
@@ -477,6 +477,10 @@ errcode_t mk_hugefiles(ext2_filsys fs, const char *device_name)
 	if (!get_bool_from_profile(fs_types, "make_hugefiles", 0))
 		return 0;
 
+	if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				       EXT3_FEATURE_INCOMPAT_EXTENTS))
+		return EXT2_ET_EXTENT_NOT_SUPPORTED;
+
 	uid = get_int_from_profile(fs_types, "hugefiles_uid", 0);
 	gid = get_int_from_profile(fs_types, "hugefiles_gid", 0);
 	fs->umask = get_int_from_profile(fs_types, "hugefiles_umask", 077);

