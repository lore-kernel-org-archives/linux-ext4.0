From: Michael Halcrow <mhalcrow@google.com>
Subject: [PATCH 3/3] UBIFS crypto: Return -EXDEV for link, rename, and cross-rename between incompat contexts
Date: Thu,  7 Sep 2017 17:12:04 -0700
Message-ID: <20170908001204.18174-4-mhalcrow@google.com>
References: <20170908001204.18174-1-mhalcrow@google.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        tytso@mit.edu, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
To: linux-fscrypt@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170908001204.18174-1-mhalcrow@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Gives user space the opportunity to fall back to copy-and-delete.

Signed-off-by: Michael Halcrow <mhalcrow@google.com>
---
 fs/ubifs/dir.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 417fe0b29f23..6c5753a2f79f 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -745,7 +745,7 @@ static int ubifs_link(struct dentry *old_dentry, struct inode *dir,
 
 	if (ubifs_crypt_is_encrypted(dir) &&
 	    !fscrypt_has_permitted_context(dir, inode))
-		return -EPERM;
+		return -EXDEV;
 
 	err = fscrypt_setup_filename(dir, &dentry->d_name, 0, &nm);
 	if (err)
@@ -1356,7 +1356,7 @@ static int do_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (old_dir != new_dir) {
 		if (ubifs_crypt_is_encrypted(new_dir) &&
 		    !fscrypt_has_permitted_context(new_dir, old_inode))
-			return -EPERM;
+			return -EXDEV;
 	}
 
 	if (unlink && is_dir) {
@@ -1578,7 +1578,7 @@ static int ubifs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 	    (old_dir != new_dir) &&
 	    (!fscrypt_has_permitted_context(new_dir, fst_inode) ||
 	     !fscrypt_has_permitted_context(old_dir, snd_inode)))
-		return -EPERM;
+		return -EXDEV;
 
 	err = fscrypt_setup_filename(old_dir, &old_dentry->d_name, 0, &fst_nm);
 	if (err)
-- 
2.14.1.581.gf28d330327-goog
