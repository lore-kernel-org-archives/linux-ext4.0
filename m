From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] mke2fs: Inform user of ongoing discard
Date: Mon, 13 Dec 2010 18:08:20 +0100
Message-ID: <1292260100-6145-1-git-send-email-lczerner@redhat.com>
References: <alpine.LFD.2.00.1012131756310.3054@dhcp-lab-213.englab.brq.redhat.com>
Cc: tytso@mit.edu, lczerner@redhat.com, tm@tao.ma
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab0LMRI2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Dec 2010 12:08:28 -0500
In-Reply-To: <alpine.LFD.2.00.1012131756310.3054@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For some time now we are doing initial discard of the device prior to
filesystem creation. However, there is no feedback for the user and
hence on some devices with slow TRIM implementation it may appear that
mke2fs is stuck.

This commit introduce new function mke2fs_discard_device(), which is a
wrapper for io_channel_discard(). The discard is done per-partes and
discard progress is being reported back to the user. The discard step
has been set to 2GB size, which works reasonably well on both slow and
fast devices.

I gave up on doing fancy things like align discard according to
discard_alignment, checking for discard granularity and computing
estimate time. First of all, because it would require either new ioctl
to retrieve those information or use of libudev library, none of it
seems to be worth it. Regarding discard_granularity, I doubt there is
any sane device with discard granularity that big it would affect this.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 misc/mke2fs.c |   55 ++++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index bc1211d..75b07bb 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -72,6 +72,9 @@ extern int optind;
 #define ZAP_BOOTBLOCK
 #endif
 
+#define DISCARD_STEP_MB		(2048)
+#define MB			(1024*1024)
+
 extern int isatty(int);
 extern FILE *fpopen(const char *cmd, const char *mode);
 
@@ -1922,6 +1925,44 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 	return retval;
 }
 
+static int mke2fs_discard_device(ext2_filsys fs)
+{
+	struct ext2fs_numeric_progress_struct progress;
+	blk64_t blocks = ext2fs_blocks_count(fs->super);
+	blk64_t count = DISCARD_STEP_MB;
+	blk64_t cur = 0;
+	int retval = 0;
+
+	count *= MB;
+	count /= fs->blocksize;
+
+	ext2fs_numeric_progress_init(fs, &progress,
+				     _("Discarding device blocks: "),
+				     blocks);
+	while (cur < blocks) {
+		ext2fs_numeric_progress_update(fs, &progress, cur);
+
+		if (cur + count > blocks)
+			count = blocks - cur;
+
+		retval = io_channel_discard(fs->io, cur, count, fs->blocksize);
+		if (retval)
+			break;
+		cur += count;
+	}
+
+	if (retval) {
+		ext2fs_numeric_progress_close(fs, &progress,
+				      _("failed - "));
+		if (!quiet)
+			printf("%s\n",error_message(retval));
+	} else
+		ext2fs_numeric_progress_close(fs, &progress,
+				      _("done                            \n"));
+
+	return retval;
+}
+
 int main (int argc, char *argv[])
 {
 	errcode_t	retval = 0;
@@ -1982,19 +2023,7 @@ int main (int argc, char *argv[])
 
 	/* Can't undo discard ... */
 	if (discard && (io_ptr != undo_io_manager)) {
-		blk64_t blocks = ext2fs_blocks_count(fs->super);
-		if (verbose)
-			printf(_("Calling BLKDISCARD from 0 to %llu... "),
-			       (unsigned long long) blocks);
-		retval = io_channel_discard(fs->io, 0, blocks, fs->blocksize);
-		if (verbose) {
-			if (retval)
-				printf(_("failed (%s)\n"),
-				       error_message(retval));
-			else
-				printf(_("succeeded\n"));
-		}
