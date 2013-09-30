From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 08/11] ext4: Fix end of group handling in ext4_mb_init_cache
Date: Mon, 30 Sep 2013 13:29:09 -0700
Message-ID: <1380572952-30729-9-git-send-email-andi@firstfloor.org>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
Cc: Andi Kleen <ak@linux.intel.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The first loop in ext4_mb_init_cache can bail out when the end of
all groups is reached. Unfortunately the later loops did not
have that check and could access uninitialized buffer pointers
in bh[]. Add the end of group check everywhere.

Cc: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Makefile          | 6 +++---
 fs/ext4/mballoc.c | 6 +++++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 8d0668f..be3ef83 100644
--- a/Makefile
+++ b/Makefile
@@ -663,9 +663,9 @@ KBUILD_CFLAGS   += $(call cc-option,-fconserve-stack)
 KBUILD_ARFLAGS := $(call ar-option,D)
 
 # check for 'asm goto'
-ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC)), y)
-	KBUILD_CFLAGS += -DCC_HAVE_ASM_GOTO
-endif
+#ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC)), y)
+#	KBUILD_CFLAGS += -DCC_HAVE_ASM_GOTO
+#endif
 
 # Add user supplied CPPFLAGS, AFLAGS and CFLAGS as the last assignments
 KBUILD_CPPFLAGS += $(KCPPFLAGS)
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a41e3ba..619d8ed 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -878,6 +878,8 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 
 	/* wait for I/O completion */
 	for (i = 0, group = first_group; i < groups_per_page; i++, group++) {
+		if (group >= ngroups)
+			break;
 		if (bh[i] && ext4_wait_block_bitmap(sb, group, bh[i])) {
 			err = -EIO;
 			goto out;
@@ -953,7 +955,9 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 
 out:
 	if (bh) {
-		for (i = 0; i < groups_per_page; i++)
+		for (i = 0, group = first_group;
+		     i < groups_per_page && group < ngroups;
+		     i++, group++)
 			brelse(bh[i]);
 		if (bh != &bhs)
 			kfree(bh);
-- 
1.8.3.1
