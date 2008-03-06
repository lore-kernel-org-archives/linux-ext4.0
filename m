From: akpm@linux-foundation.org
Subject: - ext4-fix-mount-option-parsing.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:23:43 -0800
Message-ID: <200803062223.m26MNhSv020910@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: jbacik@redhat.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: fix mount option parsing
has been removed from the -mm tree.  Its filename was
     ext4-fix-mount-option-parsing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: fix mount option parsing
From: Josef Bacik <jbacik@redhat.com>

The "resize" option won't be noticed as it comes after the NULL option, so if
you try to mount (or in this case remount) with that option it won't be
recognized.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext4/super.c~ext4-fix-mount-option-parsing fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-fix-mount-option-parsing
+++ a/fs/ext4/super.c
@@ -950,8 +950,8 @@ static match_table_t tokens = {
 	{Opt_stripe, "stripe=%u"},
 	{Opt_delalloc, "delalloc"},
 	{Opt_nodelalloc, "nodelalloc"},
-	{Opt_err, NULL},
 	{Opt_resize, "resize"},
+	{Opt_err, NULL},
 };
 
 static ext4_fsblk_t get_sb_block(void **data)
_

Patches currently in -mm which might be from jbacik@redhat.com are

jbd-fix-the-way-the-b_modified-flag-is-cleared.patch
jbd-fix-possible-journal-overflow-issues.patch

