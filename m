From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 3/6] ext4: use ktime_get_real_seconds for i_dtime
Date: Wed, 11 Jul 2018 11:14:11 +0200
Message-ID: <20180711091414.1494843-3-arnd@arndb.de>
References: <20180711091414.1494843-1-arnd@arndb.de>
Cc: arnd@arndb.de, jack@suse.cz, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, sirmy15@gmail.com,
        stable@vger.kernel.org, tgnottingham@gmail.com, tytso@mit.edu,
        y2038@lists.linaro.org
To: adilger.kernel@dilger.ca
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180711091414.1494843-1-arnd@arndb.de>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We only care about the low 32-bit for i_dtime as explained in commit
b5f515735bea ("ext4: avoid Y2038 overflow in recently_deleted()"), so
the use of get_seconds() is correct here, but that function is getting
removed in the process of the y2038 fixes, so let's use the modern
ktime_get_real_seconds() here.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 74982a9566a9..3b54227cf2b1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -317,7 +317,7 @@ void ext4_evict_inode(struct inode *inode)
 	 * (Well, we could do this if we need to, but heck - it works)
 	 */
 	ext4_orphan_del(handle, inode);
-	EXT4_I(inode)->i_dtime	= get_seconds();
+	EXT4_I(inode)->i_dtime	= (__u32)ktime_get_real_seconds();
 
 	/*
 	 * One subtle ordering requirement: if anything has gone wrong
-- 
2.9.0
