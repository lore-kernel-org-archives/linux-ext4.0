From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 07/21] libext2fs: don't fail inline data operations if
 there's no EA
Date: Fri, 8 Aug 2014 15:46:40 -0700
Message-ID: <20140808224640.GH11191@birch.djwong.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
 <20140805010543.2611.86125.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30860 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaHHWqq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Aug 2014 18:46:46 -0400
Content-Disposition: inline
In-Reply-To: <20140805010543.2611.86125.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix up the rest of the inline data code not to complain if there's no
EA, since it's possible that there's no EA because we're in the
process of creating an inline data file.  Also, don't return an error
code when removing a nonexistent EA, because there's no reason to.

Furthermore, if we write less than 60 bytes of inline data, remove the
EA to avoid wasting space.

v2: Fix a few more places where inline data functions would totally
fail if the EA was missing, even though the EA's presence isn't
required.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext_attr.c      |    3 ++-
 lib/ext2fs/inline_data.c   |    9 ++++++++-
 tests/d_xattr_edits/expect |    1 -
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 5732ca6..fc191f5 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -1020,7 +1020,8 @@ errcode_t ext2fs_xattr_remove(struct ext2_xattr_handle *handle,
 		}
 	}
 
-	return EXT2_ET_EA_KEY_NOT_FOUND;
+	/* no key found, success! */
+	return 0;
 }
 
 errcode_t ext2fs_xattrs_open(ext2_filsys fs, ext2_ino_t ino,
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index b9bda50..3ba04ae 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -70,7 +70,11 @@ static errcode_t ext2fs_inline_data_ea_get(struct ext2_inline_data *data)
 
 	retval = ext2fs_xattr_get(handle, "system.data",
 				  (void **)&data->ea_data, &data->ea_size);
-	if (retval)
+	if (retval == EXT2_ET_EA_KEY_NOT_FOUND) {
+		data->ea_size = 0;
+		data->ea_data = NULL;
+		retval = 0;
+	} else if (retval)
 		goto err;
 
 err:
@@ -557,6 +561,9 @@ errcode_t ext2fs_inline_data_set(ext2_filsys fs, ext2_ino_t ino,
 	}
 
 	if (size <= EXT4_MIN_INLINE_DATA_SIZE) {
+		retval = ext2fs_inline_data_ea_remove(fs, ino);
+		if (retval)
+			return retval;
 		memcpy((void *)inode->i_block, buf, size);
 		return ext2fs_write_inode(fs, ino, inode);
 	}
diff --git a/tests/d_xattr_edits/expect b/tests/d_xattr_edits/expect
index 10e30c1..44ce5e4 100644
--- a/tests/d_xattr_edits/expect
+++ b/tests/d_xattr_edits/expect
@@ -19,7 +19,6 @@ Exit status is 0
 ea_rm / user.moo
 Exit status is 0
 ea_rm / nosuchea
-ea_rm: Extended attribute key not found while removing extended attribute
 Exit status is 0
 ea_list /
 Extended attributes:
