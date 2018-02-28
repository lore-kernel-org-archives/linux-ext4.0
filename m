From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] ext2: fix FS_IOMAP dependency
Date: Wed, 28 Feb 2018 14:36:46 +0100
Message-ID: <20180228133659.1933887-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Dan Williams <dan.j.williams@intel.com>,
        =?UTF-8?q?Ernesto=20A=2E=20Fern=C3=A1ndez?=
        <ernesto.mnd.fernandez@gmail.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Tejun Heo <tj@kernel.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I ran into a randconfig link error on next-20180228 that appears to have
been caused by an older patch:

fs/ext2/inode.o: In function `ext2_setattr':
inode.c:(.text+0x19eb): undefined reference to `iomap_zero_range'

This adds a compile-time conditional around the code path so the
compiler can optimize out the reference in configurations that don't
need it anyway.

Fixes: 00697eed386d ("ext2: use iomap_zero_range() for zeroing truncated page in DAX path")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/ext2/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 5d5e9f7b98d6..6e6db0ab3bd6 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1296,7 +1296,7 @@ static int ext2_setsize(struct inode *inode, loff_t newsize)
 
 	inode_dio_wait(inode);
 
-	if (IS_DAX(inode)) {
+	if (IS_ENABLED(CONFIG_FS_DAX) && IS_DAX(inode)) {
 		error = iomap_zero_range(inode, newsize,
 					 PAGE_ALIGN(newsize) - newsize, NULL,
 					 &ext2_iomap_ops);
-- 
2.9.0
