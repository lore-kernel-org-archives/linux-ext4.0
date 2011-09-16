From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 23/25] e2fsprogs: Don't try to close an fd which is negative
Date: Fri, 16 Sep 2011 15:49:38 -0500
Message-ID: <1316206180-6375-24-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46739 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755881Ab1IPUtr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:47 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

These reflect either file descriptors which aren't tested
for failure, or closures of fd's which may have failed.

In setup_tdb(), test for failure of mkstemp and return
without trying to open the file (again).

In reserve_stdio_fds, rather than closing the "extra"
fd == 3 due to the way the loop is written, just
don't go that far by using while (fd <= 2).

In logsave, it forks and retries forever if open fails,
but at least make coverity happy by explicitly not
trying to close a negative file descriptor.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 e2fsck/dirinfo.c |    4 ++++
 e2fsck/unix.c    |   11 ++++++-----
 misc/logsave.c   |    3 ++-
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/e2fsck/dirinfo.c b/e2fsck/dirinfo.c
index ace5b4d..ca73c31 100644
--- a/e2fsck/dirinfo.c
+++ b/e2fsck/dirinfo.c
@@ -62,6 +62,10 @@ static void setup_tdb(e2fsck_t ctx, ext2_ino_t num_dirs)
 	uuid_unparse(ctx->fs->super->s_uuid, uuid);
 	sprintf(db->tdb_fn, "%s/%s-dirinfo-XXXXXX", tdb_dir, uuid);
 	fd = mkstemp(db->tdb_fn);
+	if (fd < 0) {
+		db->tdb = NULL;
+		return;
+	}
 	db->tdb = tdb_open(db->tdb_fn, 0, TDB_CLEAR_IF_FIRST,
 			   O_RDWR | O_CREAT | O_TRUNC, 0600);
 	close(fd);
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index bc18d41..a787d39 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -542,14 +542,16 @@ static int e2fsck_update_progress(e2fsck_t ctx, int pass,
 
 #define PATH_SET "PATH=/sbin"
 
+/*
+ * Make sure 0,1,2 file descriptors are open, so that we don't open
+ * the filesystem using the same file descriptor as stdout or stderr.
+ */
 static void reserve_stdio_fds(void)
 {
-	int	fd;
+	int	fd = 0;
 
-	while (1) {
+	while (fd <= 2) {
 		fd = open("/dev/null", O_RDWR);
-		if (fd > 2)
-			break;
 		if (fd < 0) {
 			fprintf(stderr, _("ERROR: Couldn't open "
 				"/dev/null (%s)\n"),
@@ -557,7 +559,6 @@ static void reserve_stdio_fds(void)
 			break;
 		}
 	}
-	close(fd);
 }
 
 #ifdef HAVE_SIGNAL_H
diff --git a/misc/logsave.c b/misc/logsave.c
index 74e09f7..17457a5 100644
--- a/misc/logsave.c
+++ b/misc/logsave.c
@@ -325,7 +325,8 @@ int main(int argc, char **argv)
 		write_all(outfd, outbuf, outbufsize);
 		free(outbuf);
 	}
-	close(outfd);
+	if (outfd >= 0)
+		close(outfd);
 
 	exit(rc);
 }
-- 
1.7.4.1

