From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 13/54] e2fsck: on read error,
 don't rewrite blocks past the end of the fs
Date: Mon, 26 Jan 2015 23:36:57 -0800
Message-ID: <20150127073657.13308.5523.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33500 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbbA0HhC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:37:02 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If e2fsck encounters a read error on a block past the end of the
filesystem, don't bother trying to "rewrite" the block.  We might
still want to re-try the read to capture FS data marooned past the end
of the filesystem, but in that case e2fsck ought to move the block
back inside the filesystem.

This enables e2fuzz to detect writes past the end of the FS due to
software bugs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/ehandler.c |    5 +++++
 misc/e2fuzz.sh    |    7 +++++++
 2 files changed, 12 insertions(+)


diff --git a/e2fsck/ehandler.c b/e2fsck/ehandler.c
index 6dddf9c..71ca301 100644
--- a/e2fsck/ehandler.c
+++ b/e2fsck/ehandler.c
@@ -58,6 +58,11 @@ static errcode_t e2fsck_handle_read_error(io_channel channel,
 		printf(_("Error reading block %lu (%s).  "), block,
 		       error_message(error));
 	preenhalt(ctx);
+
+	/* Don't rewrite a block past the end of the FS. */
+	if (block >= ext2fs_blocks_count(fs->super))
+		return 0;
+
 	if (ask(ctx, _("Ignore error"), 1)) {
 		if (ask(ctx, _("Force rewrite"), 1))
 			io_channel_write_blk64(channel, block, count, data);
diff --git a/misc/e2fuzz.sh b/misc/e2fuzz.sh
index 4cb7b61..d8d9a82 100755
--- a/misc/e2fuzz.sh
+++ b/misc/e2fuzz.sh
@@ -219,6 +219,7 @@ seq 1 "${PASSES}" | while read pass; do
 	fi
 	if [ "${RUN_FSCK}" -gt 0 ]; then
 		cp "${PASS_IMG}" "${FSCK_IMG}"
+		pass_img_sz="$(stat -c '%s' "${PASS_IMG}")"
 
 		seq 1 "${MAX_FSCK}" | while read fsck_pass; do
 			echo "++ fsck pass ${fsck_pass}: $(which e2fsck) -fy ${FSCK_IMG} ${EXTENDED_FSCK_OPTS}"
@@ -250,6 +251,12 @@ seq 1 "${PASSES}" | while read pass; do
 					exit 2
 				fi
 			fi
+
+			fsck_img_sz="$(stat -c '%s' "${FSCK_IMG}")"
+			if [ "${fsck_img_sz}" -ne "${pass_img_sz}" ]; then
+				echo "++ fsck image size changed"
+				exit 3
+			fi
 		done
 		fsck_loop_ret=$?
 		if [ "${fsck_loop_ret}" -gt 0 ]; then

