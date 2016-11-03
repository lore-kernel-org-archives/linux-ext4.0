From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH] ext4: ext4_mb_mark_free_simple: Fix integer value truncation
Date: Thu,  3 Nov 2016 14:44:32 +0530
Message-ID: <1478164472-28376-1-git-send-email-chandan@linux.vnet.ibm.com>
Cc: jack@suse.cz, Chandan Rajendra <chandan@linux.vnet.ibm.com>, tytso@mit.edu,
 aneesh.kumar@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
To: linux-ext4@vger.kernel.org
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-ext4.vger.kernel.org

'border' variable is set to a value of 2 times the block size of the
underlying filesystem. With 64k block size, the resulting value won't
fit into a 16-bit variable. Hence this commit changes the data type of
'border' to 'unsigned int'.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index f418f55..a937ac7 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -669,7 +669,7 @@ static void ext4_mb_mark_free_simple(struct super_block *sb,
 	ext4_grpblk_t min;
 	ext4_grpblk_t max;
 	ext4_grpblk_t chunk;
-	unsigned short border;
+	unsigned int border;
 
 	BUG_ON(len > EXT4_CLUSTERS_PER_GROUP(sb));
 
-- 
2.5.5
