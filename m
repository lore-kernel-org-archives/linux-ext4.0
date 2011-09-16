From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 08/25] e2fsprogs: annotate intentional fallthroughs in case statements
Date: Fri, 16 Sep 2011 15:49:23 -0500
Message-ID: <1316206180-6375-9-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46739 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313Ab1IPUtp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:45 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Using the /* fallthrough */ comment lets Coverity (and humans)
know that we really do want to fall through in these case statements.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/e2p/feature.c    |    1 +
 lib/e2p/mntopts.c    |    1 +
 lib/e2p/parse_num.c  |    3 +++
 lib/ext2fs/dirhash.c |    3 +++
 lib/ext2fs/extent.c  |    2 ++
 5 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 5188483..ef4376a 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -307,6 +307,7 @@ int e2p_edit_feature2(const char *str, __u32 *compat_array, __u32 *ok_array,
 		case '-':
 		case '^':
 			neg++;
+			/* fallthrough */
 		case '+':
 			cp++;
 			break;
diff --git a/lib/e2p/mntopts.c b/lib/e2p/mntopts.c
index dfdd0ef..9d3879e 100644
--- a/lib/e2p/mntopts.c
+++ b/lib/e2p/mntopts.c
@@ -122,6 +122,7 @@ int e2p_edit_mntopts(const char *str, __u32 *mntopts, __u32 ok)
 		case '-':
 		case '^':
 			neg++;
+			/* fallthrough */
 		case '+':
 			cp++;
 			break;
diff --git a/lib/e2p/parse_num.c b/lib/e2p/parse_num.c
index 83a329a..9ca6799 100644
--- a/lib/e2p/parse_num.c
+++ b/lib/e2p/parse_num.c
@@ -26,10 +26,13 @@ unsigned long long parse_num_blocks2(const char *arg, int log_block_size)
 	switch (*p) {		/* Using fall-through logic */
 	case 'T': case 't':
 		num <<= 10;
+		/* fallthrough */
 	case 'G': case 'g':
 		num <<= 10;
+		/* fallthrough */
 	case 'M': case 'm':
 		num <<= 10;
+		/* fallthrough */
 	case 'K': case 'k':
 		num >>= log_block_size;
 		break;
diff --git a/lib/ext2fs/dirhash.c b/lib/ext2fs/dirhash.c
index a069706..5477bfb 100644
--- a/lib/ext2fs/dirhash.c
+++ b/lib/ext2fs/dirhash.c
@@ -217,11 +217,13 @@ errcode_t ext2fs_dirhash(int version, const char *name, int len,
 	switch (version) {
 	case EXT2_HASH_LEGACY_UNSIGNED:
 		unsigned_flag++;
+		/* fallthrough */
 	case EXT2_HASH_LEGACY:
 		hash = dx_hack_hash(name, len, unsigned_flag);
 		break;
 	case EXT2_HASH_HALF_MD4_UNSIGNED:
 		unsigned_flag++;
+		/* fallthrough */
 	case EXT2_HASH_HALF_MD4:
 		p = name;
 		while (len > 0) {
@@ -235,6 +237,7 @@ errcode_t ext2fs_dirhash(int version, const char *name, int len,
 		break;
 	case EXT2_HASH_TEA_UNSIGNED:
 		unsigned_flag++;
+		/* fallthrough */
 	case EXT2_HASH_TEA:
 		p = name;
 		while (len > 0) {
diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index abb60dd..6d2afb0 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -373,9 +373,11 @@ retry:
 	case EXT2_EXTENT_ROOT:
 		handle->level = 0;
 		path = handle->path + handle->level;
+		/* fallthrough */
 	case EXT2_EXTENT_FIRST_SIB:
 		path->left = path->entries;
 		path->curr = 0;
+		/* fallthrough */
 	case EXT2_EXTENT_NEXT_SIB:
 		if (path->left <= 0)
 			return EXT2_ET_EXTENT_NO_NEXT;
-- 
1.7.4.1

