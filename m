From: Michael Halcrow via Linux-f2fs-devel
 <linux-f2fs-devel@lists.sourceforge.net>
Subject: [PATCH 1/3] ext4 crypto: Return -EXDEV for link, rename,
 and cross-rename between incompat contexts
Date: Thu,  7 Sep 2017 17:12:02 -0700
Message-ID: <20170908001204.18174-2-mhalcrow@google.com>
References: <20170908001204.18174-1-mhalcrow@google.com>
Reply-To: Michael Halcrow <mhalcrow@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-ext4@vger.kernel.org, tytso@mit.edu,
 linux-f2fs-devel@lists.sourceforge.net
To: linux-fscrypt@vger.kernel.org
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20170908001204.18174-1-mhalcrow@google.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

Gives user space the opportunity to fall back to copy-and-delete.

Signed-off-by: Michael Halcrow <mhalcrow@google.com>
---
 fs/ext4/namei.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c1cf020d1889..3c493bc4273d 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3223,7 +3223,7 @@ static int ext4_link(struct dentry *old_dentry,
 		return -EMLINK;
 	if (ext4_encrypted_inode(dir) &&
 			!fscrypt_has_permitted_context(dir, inode))
-		return -EPERM;
+		return -EXDEV;
 
        if ((ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT)) &&
 	   (!projid_eq(EXT4_I(dir)->i_projid,
@@ -3552,7 +3552,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if ((old.dir != new.dir) &&
 	    ext4_encrypted_inode(new.dir) &&
 	    !fscrypt_has_permitted_context(new.dir, old.inode)) {
-		retval = -EPERM;
+		retval = -EXDEV;
 		goto end_rename;
 	}
 
@@ -3732,7 +3732,7 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	    (old_dir != new_dir) &&
 	    (!fscrypt_has_permitted_context(new_dir, old.inode) ||
 	     !fscrypt_has_permitted_context(old_dir, new.inode)))
-		return -EPERM;
+		return -EXDEV;
 
 	if ((ext4_test_inode_flag(new_dir, EXT4_INODE_PROJINHERIT) &&
 	     !projid_eq(EXT4_I(new_dir)->i_projid,
-- 
2.14.1.581.gf28d330327-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
