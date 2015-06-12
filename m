From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1 linux-next] ext4: use swap() in mext_page_double_lock()
Date: Fri, 12 Jun 2015 18:59:15 +0200
Message-ID: <1434128356-10738-1-git-send-email-fabf@skynet.be>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
	Fabian Frederick <fabf@skynet.be>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Use kernel.h macro definition.

Thanks to Julia Lawall for Coccinelle scripting support.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext4/move_extent.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 370420b..8c04afb 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -166,12 +166,9 @@ mext_page_double_lock(struct inode *inode1, struct inode *inode2,
 	 */
 	wait_on_page_writeback(page[0]);
 	wait_on_page_writeback(page[1]);
-	if (inode1 > inode2) {
-		struct page *tmp;
-		tmp = page[0];
-		page[0] = page[1];
-		page[1] = tmp;
-	}
+	if (inode1 > inode2)
+		swap(page[0], page[1]);
+
 	return 0;
 }
 
-- 
2.4.2
