From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v2 4/10] xfsprogs: xfs_io: add finsert command for insert range
 via fallocate
Date: Thu, 08 May 2014 19:30:47 +0900
Message-ID: <003a01cf6aa8$933f6890$b9be39b0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 'linux-ext4' <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	'Ashish Sangwan' <a.sangwan@samsung.com>
To: 'Dave Chinner' <david@fromorbit.com>,
	'Theodore Ts'o' <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:26368 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbaEHKat (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 May 2014 06:30:49 -0400
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add finsert command for fallocate FALLOC_FL_INSERT_RANGE flag.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 io/prealloc.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/io/prealloc.c b/io/prealloc.c
index aba6b44..11b1e12 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -37,6 +37,10 @@
 #define FALLOC_FL_ZERO_RANGE 0x10
 #endif
 
+#ifndef FALLOC_FL_INSERT_RANGE
+#define FALLOC_FL_INSERT_RANGE 0x20
+#endif
+
 static cmdinfo_t allocsp_cmd;
 static cmdinfo_t freesp_cmd;
 static cmdinfo_t resvsp_cmd;
@@ -46,6 +50,7 @@ static cmdinfo_t zero_cmd;
 static cmdinfo_t falloc_cmd;
 static cmdinfo_t fpunch_cmd;
 static cmdinfo_t fcollapse_cmd;
+static cmdinfo_t finsert_cmd;
 static cmdinfo_t fzero_cmd;
 #endif
 
@@ -169,11 +174,14 @@ fallocate_f(
 	int		mode = 0;
 	int		c;
 
-	while ((c = getopt(argc, argv, "ckp")) != EOF) {
+	while ((c = getopt(argc, argv, "cikp")) != EOF) {
 		switch (c) {
 		case 'c':
 			mode = FALLOC_FL_COLLAPSE_RANGE;
 			break;
+		case 'i':
+			mode = FALLOC_FL_INSERT_RANGE;
+			break;
 		case 'k':
 			mode = FALLOC_FL_KEEP_SIZE;
 			break;
@@ -237,6 +245,25 @@ fcollapse_f(
 }
 
 static int
+finsert_f(
+	int		argc,
+	char		**argv)
+{
+	xfs_flock64_t	segment;
+	int		mode = FALLOC_FL_INSERT_RANGE;
+
+	if (!offset_length(argv[1], argv[2], &segment))
+		return 0;
+
+	if (fallocate(file->fd, mode,
+			segment.l_start, segment.l_len)) {
+		perror("fallocate");
+		return 0;
+	}
+	return 0;
+}
+
+static int
 fzero_f(
 	int		argc,
 	char		**argv)
@@ -345,6 +372,16 @@ prealloc_init(void)
 	_("de-allocates space and eliminates the hole by shifting extents");
 	add_command(&fcollapse_cmd);
 
+	finsert_cmd.name = "finsert";
+	finsert_cmd.cfunc = finsert_f;
+	finsert_cmd.argmin = 2;
+	finsert_cmd.argmax = 2;
+	finsert_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	finsert_cmd.args = _("off len");
+	finsert_cmd.oneline =
+	_("allocates zeroes space after creating the hole by shifting extents");
+	add_command(&finsert_cmd);
+
 	fzero_cmd.name = "fzero";
 	fzero_cmd.cfunc = fzero_f;
 	fzero_cmd.argmin = 2;
-- 
1.7.11-rc0

