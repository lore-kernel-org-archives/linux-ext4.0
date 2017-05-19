From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH] ext4: keep existing extra fields when inode expands
Date: Fri, 19 May 2017 10:13:39 +0300
Message-ID: <149517801870.34533.16399602916806300461.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext4_expand_extra_isize() should clear only space between old and new size.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 fs/ext4/inode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5834c4d76be8..7204e1a2801a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5637,8 +5637,9 @@ static int ext4_expand_extra_isize(struct inode *inode,
 	/* No extended attributes present */
 	if (!ext4_test_inode_state(inode, EXT4_STATE_XATTR) ||
 	    header->h_magic != cpu_to_le32(EXT4_XATTR_MAGIC)) {
-		memset((void *)raw_inode + EXT4_GOOD_OLD_INODE_SIZE, 0,
-			new_extra_isize);
+		memset((void *)raw_inode + EXT4_GOOD_OLD_INODE_SIZE +
+		       EXT4_I(inode)->i_extra_isize, 0,
+		       new_extra_isize - EXT4_I(inode)->i_extra_isize);
 		EXT4_I(inode)->i_extra_isize = new_extra_isize;
 		return 0;
 	}
