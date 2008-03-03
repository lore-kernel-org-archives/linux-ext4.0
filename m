From: akpm@linux-foundation.org
Subject: + ext4-fix-mount-option-parsing.patch added to -mm tree
Date: Mon, 03 Mar 2008 13:46:22 -0800
Message-ID: <200803032146.m23LkMRN008192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: jbacik@redhat.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: fix mount option parsing
has been added to the -mm tree.  Its filename is
     ext4-fix-mount-option-parsing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ext3-fix-mount-option-parsing.patch
jbd-fix-the-way-the-b_modified-flag-is-cleared.patch
jbd-fix-possible-journal-overflow-issues.patch
jbd2-fix-the-way-the-b_modified-flag-is-cleared.patch
jbd2-fix-possible-journal-overflow-issues.patch
ext4-fix-mount-option-parsing.patch

