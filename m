From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v5 20/22] ext4: Fix typos
Date: Wed, 15 Jan 2014 20:24:38 -0500
Message-ID: <2b60800c105942801e3dc6c70c1d2aa061d6bc68.1389779962.git.matthew.r.wilcox@intel.com>
References: <cover.1389779961.git.matthew.r.wilcox@intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-ext4@vger.kernel.org
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <cover.1389779961.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1389779961.git.matthew.r.wilcox@intel.com>
References: <cover.1389779961.git.matthew.r.wilcox@intel.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Comment fix only

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8b73d77..cae40af 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3720,7 +3720,7 @@ void ext4_truncate(struct inode *inode)
 
 	/*
 	 * There is a possibility that we're either freeing the inode
-	 * or it completely new indode. In those cases we might not
+	 * or it's a completely new inode. In those cases we might not
 	 * have i_mutex locked because it's not necessary.
 	 */
 	if (!(inode->i_state & (I_NEW|I_FREEING)))
-- 
1.8.5.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
