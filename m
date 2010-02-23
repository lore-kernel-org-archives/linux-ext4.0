From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck: Fix bug which can cause e2fsck -fD to corrupt non-indexed directories
Date: Tue, 23 Feb 2010 00:43:41 -0500
Message-ID: <1266903821-20800-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41496 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab0BWFnq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Feb 2010 00:43:46 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

E2fsprogs 1.41.10 introduced a regression (in commit b71e018) where
e2fsck -fD can corrupt non-indexed directories when are exists one or
more file names which alphabetically sort before ".".  This can happen
with ext2 filesystems or for small directories (take less than a
block) which contain filenames that begin with a space or some other
punctuation mark.

Fix this by making sure we never reorder the '.' or '..' entry in the
directory, since they must be first.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/rehash.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 780742e..ceb8543 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -763,7 +763,12 @@ retry_nohash:
 
 	/* Sort the list */
 resort:
-	qsort(fd.harray, fd.num_array, sizeof(struct hash_entry), hash_cmp);
+	if (fd.compress)
+		qsort(fd.harray+2, fd.num_array-2, sizeof(struct hash_entry),
+		      hash_cmp);
+	else
+		qsort(fd.harray, fd.num_array, sizeof(struct hash_entry),
+		      hash_cmp);
 
 	/*
 	 * Look for duplicates
-- 
1.6.6.1.1.g974db.dirty

