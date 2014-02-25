From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] xfs_io: add fzero command for zeroing range via fallocate
Date: Tue, 25 Feb 2014 20:15:33 +0100
Message-ID: <1393355733-12099-1-git-send-email-lczerner@redhat.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add fzero command which zeroes a range of the file using
fallocate FALLOC_FL_ZERO_RANGE flag.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 io/prealloc.c     | 42 +++++++++++++++++++++++++++++++++++++++++-
 man/man8/xfs_io.8 |  5 +++++
 2 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/io/prealloc.c b/io/prealloc.c
index d697f82..71ca877 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -33,6 +33,10 @@
 #define FALLOC_FL_COLLAPSE_RANGE 0x08
 #endif
 
+#ifndef FALLOC_FL_ZERO_RANGE
+#define FALLOC_FL_ZERO_RANGE 0x10
+#endif
+
 static cmdinfo_t allocsp_cmd;
 static cmdinfo_t freesp_cmd;
 static cmdinfo_t resvsp_cmd;
@@ -42,6 +46,7 @@ static cmdinfo_t zero_cmd;
 static cmdinfo_t falloc_cmd;
 static cmdinfo_t fpunch_cmd;
 static cmdinfo_t fcollapse_cmd;
+static cmdinfo_t fzero_cmd;
 #endif
 
 static int
@@ -230,6 +235,31 @@ fcollapse_f(
 	}
 	return 0;
 }
+
+static int
+fzero_f(
+	int		argc,
+	char		**argv)
+{
+	xfs_flock64_t	segment;
+	int		mode = FALLOC_FL_ZERO_RANGE;
+	int		index = 1;
+
+	if (strncmp(argv[index], "-k", 3) == 0) {
+		mode |= FALLOC_FL_KEEP_SIZE;
+		index++;
+	}
+
+	if (!offset_length(argv[index], argv[index + 1], &segment))
+		return 0;
+
+	if (fallocate(file->fd, mode,
+			segment.l_start, segment.l_len)) {
+		perror("fallocate");
+		return 0;
+	}
+	return 0;
+}
 #endif	/* HAVE_FALLOCATE */
 
 void
@@ -312,7 +342,17 @@ prealloc_init(void)
 	fcollapse_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
 	fcollapse_cmd.args = _("off len");
 	fcollapse_cmd.oneline =
-	_("de-allocates space and eliminates the hole by shifting extents");
+		_("de-allocates space and eliminates the hole by shifting extents");
 	add_command(&fcollapse_cmd);
+
+	fzero_cmd.name = "fzero";
+	fzero_cmd.cfunc = fzero_f;
+	fzero_cmd.argmin = 2;
+	fzero_cmd.argmax = 3;
+	fzero_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	fzero_cmd.args = _("[-k] off len");
+	fzero_cmd.oneline =
+		_("zeroes space and eliminates holes by preallocating");
+	add_command(&fzero_cmd);
 #endif	/* HAVE_FALLOCATE */
 }
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 9543b20..e95cf70 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -392,6 +392,11 @@ the FALLOC_FL_PUNCH_HOLE flag as described in the
 .BR fallocate (2)
 manual page.
 .TP
+.BI fzero " offset length"
+Call fallocate with FALLOC_FL_ZERO_RANGE flag as described in the
+.BR fallocate (2)
+manual page to allocate and zero blocks within the range.
+.TP
 .BI truncate " offset"
 Truncates the current file at the given offset using
 .BR ftruncate (2).
-- 
1.8.3.1

