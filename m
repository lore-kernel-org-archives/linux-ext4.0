From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3 v2] 285: Fix indentation of do_pwrite
Date: Thu, 30 May 2013 23:21:44 +0200
Message-ID: <1369948905-6693-2-git-send-email-jack@suse.cz>
References: <1369948905-6693-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: xfs@oss.sgi.com
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <1369948905-6693-1-git-send-email-jack@suse.cz>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Jan Kara <jack@suse.cz>
---
 src/seek_sanity_test.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
index eec6903..748eec2 100644
--- a/src/seek_sanity_test.c
+++ b/src/seek_sanity_test.c
@@ -120,19 +120,19 @@ static int do_sync_dirty_pages(int fd, off64_t offset, off64_t nbytes)
 
 static ssize_t do_pwrite(int fd, const void *buf, size_t count, off_t offset)
 {
-       ssize_t ret, written = 0;
-
-       while (count > written) {
-               ret = pwrite(fd, buf + written, count - written, offset + written);
-               if (ret < 0) {
-                       fprintf(stderr, "  ERROR %d: Failed to write %ld "
-                               "bytes\n", errno, (long)count);
-                       return ret;
-               }
-               written += ret;
-       }
-
-       return 0;
+	ssize_t ret, written = 0;
+
+	while (count > written) {
+		ret = pwrite(fd, buf + written, count - written, offset + written);
+		if (ret < 0) {
+			fprintf(stderr, "  ERROR %d: Failed to write %ld "
+				"bytes\n", errno, (long)count);
+			return ret;
+		}
+		written += ret;
+	}
+
+	return 0;
 }
 
 #define do_close(x)	do { if ((x) > -1) close(x); } while(0);
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
