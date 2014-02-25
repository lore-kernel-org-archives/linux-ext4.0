From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 5/6] xfstests: Define fallocate flags locally in fsx
Date: Tue, 25 Feb 2014 20:15:27 +0100
Message-ID: <1393355728-12056-5-git-send-email-lczerner@redhat.com>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Define fallocate flags such as FALLOC_FL_PUNCH_HOLE and
FALLOC_FL_ZERO_RANGE locally if they do not exist.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 ltp/fsx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index b3c30db..331257e 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -35,8 +35,13 @@
 #endif
 #ifdef FALLOCATE
 #include <linux/falloc.h>
+#ifndef FALLOC_FL_PUNCH_HOLE
+#define FALLOC_FL_PUNCH_HOLE    0x02 /* de-allocates range */
+#endif
+#ifndef FALLOC_FL_ZERO_RANGE
+#define FALLOC_FL_ZERO_RANGE    0x10 /* zeroes range */
+#endif
 #endif
-
 #ifndef MAP_FILE
 # define MAP_FILE 0
 #endif
-- 
1.8.3.1

