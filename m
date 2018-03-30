From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH -v2] ext4: limit xattr size to INT_MAX
Date: Fri, 30 Mar 2018 15:13:20 -0400
Message-ID: <20180330191320.7270-1-tytso@mit.edu>
References: <20180329194125.GC3790@thunk.org>
Cc: adilger@dilger.ca, ebiggers3@gmail.com, wen.xu@gatech.edu,
        ebiggers@google.com, Theodore Ts'o <tytso@mit.edu>,
        stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180329194125.GC3790@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

ext4 isn't validating the sizes of xattrs.  This is problematic
because ->e_value_size is a u32, but ext4_xattr_get() returns an int.
A very large size is misinterpreted as an error code, which
ext4_get_acl() translates into a bogus ERR_PTR() for which IS_ERR()
returns false, causing a crash.

Fix this by validating that all xattrs are <= INT_MAX bytes.  Also add
explicit checks in ext4_xattr_block_get() and ext4_xattr_ibody_get()
just in case the xattr block is corrupted in memory.

Also if the xattr block is corrupted, mark the file system as
containing an error.

This issue has been assigned CVE-2018-1095.

https://bugzilla.kernel.org/show_bug.cgi?id=199185
https://bugzilla.redhat.com/show_bug.cgi?id=1560793

Reported-by: Wen Xu <wen.xu@gatech.edu>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/xattr.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 63656dbafdc4..d2a9b078e121 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -195,10 +195,14 @@ ext4_xattr_check_entries(struct ext4_xattr_entry *entry, void *end,
 
 	/* Check the values */
 	while (!IS_LAST_ENTRY(entry)) {
+		u32 size = le32_to_cpu(entry->e_value_size);
+
+		if (size > INT_MAX)
+			return -EFSCORRUPTED;
+
 		if (entry->e_value_size != 0 &&
 		    entry->e_value_inum == 0) {
 			u16 offs = le16_to_cpu(entry->e_value_offs);
-			u32 size = le32_to_cpu(entry->e_value_size);
 			void *value;
 
 			/*
@@ -523,8 +527,10 @@ ext4_xattr_block_get(struct inode *inode, int name_index, const char *name,
 	if (error)
 		goto cleanup;
 	size = le32_to_cpu(entry->e_value_size);
+	error = -ERANGE;
+	if (unlikely(size > INT_MAX))
+		goto cleanup;
 	if (buffer) {
-		error = -ERANGE;
 		if (size > buffer_size)
 			goto cleanup;
 		if (entry->e_value_inum) {
@@ -572,8 +578,10 @@ ext4_xattr_ibody_get(struct inode *inode, int name_index, const char *name,
 	if (error)
 		goto cleanup;
 	size = le32_to_cpu(entry->e_value_size);
+	error = -ERANGE;
+	if (unlikely(size > INT_MAX))
+		goto cleanup;
 	if (buffer) {
-		error = -ERANGE;
 		if (size > buffer_size)
 			goto cleanup;
 		if (entry->e_value_inum) {
-- 
2.16.1.72.g5be1f00a9a
