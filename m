From: Colin King <colin.king@canonical.com>
Subject: [PATCH] ext4: fix incorrect indentation of if statement
Date: Wed, 29 Nov 2017 14:20:59 +0000
Message-ID: <20171129142059.21898-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The indentation is incorrect and spaces need replacing with a tab
on the if statement.

Cleans up smatch warning:
fs/ext4/namei.c:3220 ext4_link() warn: inconsistent indenting

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/ext4/namei.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 798b3ac680db..d3fabc553c65 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3217,8 +3217,8 @@ static int ext4_link(struct dentry *old_dentry,
 	if (err)
 		return err;
 
-       if ((ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT)) &&
-	   (!projid_eq(EXT4_I(dir)->i_projid,
+	if ((ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT)) &&
+	    (!projid_eq(EXT4_I(dir)->i_projid,
 		       EXT4_I(old_dentry->d_inode)->i_projid)))
 		return -EXDEV;
 
-- 
2.14.1
