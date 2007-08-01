From: Coly Li <colyli@gmail.com>
Subject: [PATCH] removing e2fsprogs compiling warnings
Date: Wed, 01 Aug 2007 15:18:04 +0800
Message-ID: <46B033AC.1070809@gmail.com>
Reply-To: colyli@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.186]:64477 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbXHAHXe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Aug 2007 03:23:34 -0400
Received: by mu-out-0910.google.com with SMTP id i10so168689mue
        for <linux-ext4@vger.kernel.org>; Wed, 01 Aug 2007 00:23:32 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch remove 3 compiling warning of current e2fsprogs git.

Best regards.

Coly



diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index b50ff7c..ce0301f 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -16,6 +16,7 @@
 #include <stdlib.h>
 #include <ctype.h>
 #include <string.h>
+#include <strings.h>
 #include <time.h>
 #include <sys/types.h>
 #include <sys/stat.h>
diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
index 69a43b0..c8fffa1 100644
--- a/lib/blkid/probe.c
+++ b/lib/blkid/probe.c
@@ -585,8 +585,8 @@ static int probe_luks(struct blkid_probe *probe,
        unsigned char uuid[40];
        /* 168 is the offset to the 40 character uuid:
         * http://luks.endorphin.org/LUKS-on-disk-format.pdf */
-       strncpy(uuid, buf+168, 40);
-       blkid_set_tag(probe->dev, "UUID", uuid, sizeof(uuid));
+       strncpy((char *)uuid, (const char *)(buf+168), 40);
+       blkid_set_tag(probe->dev, "UUID", (const char *)uuid, sizeof(uuid));
        return 0;
 }

diff --git a/misc/badblocks.c b/misc/badblocks.c
index 88c5a74..29c5a5c 100644
--- a/misc/badblocks.c
+++ b/misc/badblocks.c
@@ -1012,7 +1012,7 @@ int main (int argc, char ** argv)
                }
        } else from_count = 0;
        if (from_count >= last_block) {
-           com_err (program_name, 0, _("invalid starting block (%d):
must be less than %lu"),
+           com_err (program_name, 0, _("invalid starting block (%lu):
must be less than %lu"),
                     (unsigned long) from_count, (unsigned long)
last_block);
            exit (1);
        }
