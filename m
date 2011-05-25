From: Joe Perches <joe@perches.com>
Subject: [PATCH 1/4] treewide: Remove direct includes of printk.h
Date: Wed, 25 May 2011 10:02:38 -0700
Message-ID: <16b4d3f7016443ed5e9ab580cde3c5e7cf1cc553.1306342673.git.joe@perches.com>
References: <BANLkTimo30L7feKr9_Ec=fMoe1erw8Rnag@mail.gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	oprofile-list@lists.sf.net
To: Geert Uytterhoeven <geert@linux-m68k.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Robert Richter <robert.richter@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BANLkTimo30L7feKr9_Ec=fMoe1erw8Rnag@mail.gmail.com>
In-Reply-To: <cover.1306342673.git.joe@perches.com>
References: <cover.1306342673.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Make the uses kernel.h instead.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ext4/inode.c          |    1 -
 include/linux/oprofile.h |    2 +-
 kernel/sysctl.c          |    3 +--
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2e95819..cffecac 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -39,7 +39,6 @@
 #include <linux/bio.h>
 #include <linux/workqueue.h>
 #include <linux/kernel.h>
-#include <linux/printk.h>
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
 
diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index 7f5cfd3..ef7d5b1 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -14,10 +14,10 @@
 #define OPROFILE_H
 
 #include <linux/types.h>
+#include <linux/kernel.h>
 #include <linux/spinlock.h>
 #include <linux/init.h>
 #include <linux/errno.h>
-#include <linux/printk.h>
 #include <asm/atomic.h>
  
 /* Each escaped entry is prefixed by ESCAPE_CODE
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4fc9244..814d227 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -24,14 +24,13 @@
 #include <linux/slab.h>
 #include <linux/sysctl.h>
 #include <linux/signal.h>
-#include <linux/printk.h>
+#include <linux/kernel.h>
 #include <linux/proc_fs.h>
 #include <linux/security.h>
 #include <linux/ctype.h>
 #include <linux/kmemcheck.h>
 #include <linux/fs.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/kobject.h>
 #include <linux/net.h>
 #include <linux/sysrq.h>
-- 
1.7.4.rc3
