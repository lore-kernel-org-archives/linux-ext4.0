From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH] vfs: Return -ENXIO for negative SEEK_HOLE / SEEK_DATA offsets
Date: Wed, 30 Aug 2017 16:13:13 +0200
Message-ID: <20170830141313.11283-1-agruenba@redhat.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        stable@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In generic_file_llseek_size, return -ENXIO for negative offsets as well.

Fixes xfstest generic/448.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Cc: stable@vger.kernel.org
---
 fs/read_write.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 0cc7033aa413..52872c1e57dd 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -112,7 +112,7 @@ generic_file_llseek_size(struct file *file, loff_t offset, int whence,
 		 * In the generic case the entire file is data, so as long as
 		 * offset isn't at the end of the file then the offset is data.
 		 */
-		if (offset >= eof)
+		if ((unsigned long long)offset >= eof)
 			return -ENXIO;
 		break;
 	case SEEK_HOLE:
@@ -120,7 +120,7 @@ generic_file_llseek_size(struct file *file, loff_t offset, int whence,
 		 * There is a virtual hole at the end of the file, so as long as
 		 * offset isn't i_size or larger, return i_size.
 		 */
-		if (offset >= eof)
+		if ((unsigned long long)offset >= eof)
 			return -ENXIO;
 		offset = eof;
 		break;
-- 
2.13.3
