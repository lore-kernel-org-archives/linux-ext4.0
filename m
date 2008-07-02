From: akpm@linux-foundation.org
Subject: + ext3-validate-directory-entry-data-before-use-v5.patch added to -mm tree
Date: Tue, 01 Jul 2008 20:37:17 -0700
Message-ID: <200807020337.m623bHoF029491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: duaneg@dghda.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: validate directory entry data before use
has been added to the -mm tree.  Its filename is
     ext3-validate-directory-entry-data-before-use-v5.patch

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
Subject: ext3: validate directory entry data before use
From: "Duane Griffin" <duaneg@dghda.com>

ext3_dx_find_entry uses ext3_next_entry without verifying that the entry
is valid.  If its rec_len == 0 this causes an infinite loop.  Refactor the
loop to check the validity of entries before checking whether they match
and moving onto the next one.

There are other uses of ext3_next_entry in this file which also look
problematic.  They should be reviewed and fixed if/when we have a
test-case that triggers them.

This patch fixes the first case (image hdb.25.softlockup.gz) reported in
http://bugzilla.kernel.org/show_bug.cgi?id=10882.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/namei.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff -puN fs/ext3/namei.c~ext3-validate-directory-entry-data-before-use-v5 fs/ext3/namei.c
--- a/fs/ext3/namei.c~ext3-validate-directory-entry-data-before-use-v5
+++ a/fs/ext3/namei.c
@@ -991,19 +991,21 @@ static struct buffer_head * ext3_dx_find
 		de = (struct ext3_dir_entry_2 *) bh->b_data;
 		top = (struct ext3_dir_entry_2 *) ((char *) de + sb->s_blocksize -
 				       EXT3_DIR_REC_LEN(0));
-		for (; de < top; de = ext3_next_entry(de))
-		if (ext3_match (namelen, name, de)) {
-			if (!ext3_check_dir_entry("ext3_find_entry",
-						  dir, de, bh,
-				  (block<<EXT3_BLOCK_SIZE_BITS(sb))
-					  +((char *)de - bh->b_data))) {
-				brelse (bh);
+		for (; de < top; de = ext3_next_entry(de)) {
+			int off = (block << EXT3_BLOCK_SIZE_BITS(sb))
+				  + ((char *) de - bh->b_data);
+
+			if (!ext3_check_dir_entry(__func__, dir, de, bh, off)) {
+				brelse(bh);
 				*err = ERR_BAD_DX_DIR;
 				goto errout;
 			}
-			*res_dir = de;
-			dx_release (frames);
-			return bh;
+
+			if (ext3_match(namelen, name, de)) {
+				*res_dir = de;
+				dx_release(frames);
+				return bh;
+			}
 		}
 		brelse (bh);
 		/* Check to see if we should continue to search */
_

Patches currently in -mm which might be from duaneg@dghda.com are

jbd-replace-potentially-false-assertion-with-if-block.patch
jbd-eliminate-duplicated-code-in-revocation-table-init-destroy-functions.patch
jbd-tidy-up-revoke-cache-initialisation-and-destruction.patch
ext3-handle-corrupted-orphan-list-at-mount.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup.patch
ext3-handle-corrupted-orphan-list-at-mount-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup-fix.patch
ext3-handle-deleting-corrupted-indirect-blocks.patch
ext3-validate-directory-entry-data-before-use-v5.patch

