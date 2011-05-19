From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: [PATCH] fs: Fix default SEEK_DATA and SEEK_HOLE
	implementation
Date: Wed, 18 May 2011 19:44:43 -0700
Message-ID: <1305773084-19296-2-git-send-email-sunil.mushran@oracle.com>
References: <1305773084-19296-1-git-send-email-sunil.mushran@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: josef@redhat.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, viro@ZenIV.linux.org.uk,
        o
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
In-Reply-To: <1305773084-19296-1-git-send-email-sunil.mushran@oracle.com>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org

In the default SEEK_DATA implementation, as the entire file is treated as data,
all supplied offsets less than the size of the file are valid.

For empty files, SEEK_DATA and SEEK_HOLE returns -ENXIO irrespective of the
input offset.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/read_write.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index af9cc51..4b991e9 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -66,11 +66,10 @@ generic_file_llseek_unlocked(struct file *file, loff_t offset, int origin)
 		break;
 	case SEEK_DATA:
 		/*
-		 * In the generic case the entire file is data, so data only
-		 * starts at position 0 provided the file has an i_size,
-		 * otherwise it's an empty file and will always be ENXIO.
+		 * In the generic case the entire file is data. So all offsets
+		 * less than the file size are valid.
 		 */
-		if (offset != 0 || inode->i_size == 0)
+		if (inode->i_size == 0 || offset >= inode->i_size)
 			return -ENXIO;
 		break;
 	case SEEK_HOLE:
@@ -78,7 +77,7 @@ generic_file_llseek_unlocked(struct file *file, loff_t offset, int origin)
 		 * There is a virtual hole at the end of the file, so as long as
 		 * offset isn't i_size or larger, return i_size.
 		 */
-		if (offset >= inode->i_size)
+		if (inode->i_size == 0 || offset >= inode->i_size)
 			return -ENXIO;
 		offset = inode->i_size;
 		break;
-- 
1.7.4.1
