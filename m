From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 14/54] e2fsck: fix the journal recreation message
Date: Tue, 27 Jan 2015 13:02:54 -0500
Message-ID: <20150127180254.GN2453@thunk.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150127073703.13308.19956.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35704 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbbA0SCz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2015 13:02:55 -0500
Content-Disposition: inline
In-Reply-To: <20150127073703.13308.19956.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 26, 2015 at 11:37:03PM -0800, Darrick J. Wong wrote:
> When we recreate the journal, don't say that the FS "is now ext3
> again", since we could be fixing a damaged ext4 FS journal, which does
> not magically convert the FS back to ext3.
> 
> Fix the po files too, though this string hasn't been translated.
> 

So a couple of things.  "Journaled" is spelled with a single 'l':

   http://www.oxforddictionaries.com/definition/english/journal

Also, if you're going to fix the journal recreation message, we should
also fix the message which is generated when the journal is removed.

Finally, don't mess with the po files; just before we do a release,
we'll regenerate the po template file (e2fsprogs.pot), and there are
automated tools that will take care of merging the changes into the
.po files.  It's cleaner if we don't modify the po files except via
automated tools, when we get updates from the Translation Project:

	  http://translationproject.org/html/maintainers.html

Here's the patch that I've applied instead.  I ended up simplifying
the message because "journal has been re-created - filesystem is
journaled again" sounds a like an entry from

http://tvtropes.org/pmwiki/pmwiki.php/Main/DepartmentOfRedundancyDepartment

:-)

					- Ted


commit 85068f9d86ab70da6d27384210f1c964f8c09f79
Author: Darrick J. Wong <darrick.wong@oracle.com>
Date:   Mon Jan 26 23:37:03 2015 -0800

    e2fsck: fix message when the journal is deleted and regenerated
    
    When we recreate the journal, don't say that the FS "is now ext3
    again", since we could be fixing a damaged ext4 FS journal, which does
    not magically convert the FS back to ext3.
    
    [ Use "journaled" instead of "journalled", and also fix the message we
      print when deleting the journal --Ted ]
    
    Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 6119cda..9f32095 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -545,8 +545,7 @@ static errcode_t e2fsck_journal_fix_bad_inode(e2fsck_t ctx,
 		pctx->ino = sb->s_journal_inum;
 		if (fix_problem(ctx, PR_0_JOURNAL_BAD_INODE, pctx)) {
 			if (has_journal && sb->s_journal_inum)
-				printf("*** ext3 journal has been deleted - "
-				       "filesystem is now ext2 only ***\n\n");
+				printf("*** journal has been deleted ***\n\n");
 			sb->s_feature_compat &= ~EXT3_FEATURE_COMPAT_HAS_JOURNAL;
 			sb->s_journal_inum = 0;
 			memset(sb->s_jnl_blocks, 0, sizeof(sb->s_jnl_blocks));
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 615d690..96551a1 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1674,8 +1674,7 @@ print_unsupp_features:
 			}
 			log_out(ctx, "%s", _(" Done.\n"));
 			log_out(ctx, "%s",
-				_("\n*** journal has been re-created - "
-				  "filesystem is now ext3 again ***\n"));
+				_("\n*** journal has been regenerated ***\n"));
 		}
 	}
 no_journal:
diff --git a/tests/f_badjour_indblks/expect.1 b/tests/f_badjour_indblks/expect.1
index 7ccc59b..cb8054c 100644
--- a/tests/f_badjour_indblks/expect.1
+++ b/tests/f_badjour_indblks/expect.1
@@ -1,7 +1,7 @@
 Superblock has an invalid journal (inode 8).
 Clear? yes
 
-*** ext3 journal has been deleted - filesystem is now ext2 only ***
+*** journal has been deleted ***
 
 Adding dirhash hint to filesystem.
 
@@ -25,7 +25,7 @@ Recreate journal? yes
 
 Creating journal (1024 blocks):  Done.
 
-*** journal has been re-created - filesystem is now ext3 again ***
+*** journal has been regenerated ***
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
 test_filesys: 11/256 files (0.0% non-contiguous), 1111/8192 blocks
diff --git a/tests/f_badjourblks/expect.1 b/tests/f_badjourblks/expect.1
index 34c6658..5483a0d 100644
--- a/tests/f_badjourblks/expect.1
+++ b/tests/f_badjourblks/expect.1
@@ -1,7 +1,7 @@
 Superblock has an invalid journal (inode 8).
 Clear? yes
 
-*** ext3 journal has been deleted - filesystem is now ext2 only ***
+*** journal has been deleted ***
 
 Pass 1: Checking inodes, blocks, and sizes
 Journal inode is not in use, but contains data.  Clear? yes
@@ -23,7 +23,7 @@ Recreate journal? yes
 
 Creating journal (1024 blocks):  Done.
 
-*** journal has been re-created - filesystem is now ext3 again ***
+*** journal has been regenerated ***
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
 test_filesys: 11/256 files (0.0% non-contiguous), 1079/8192 blocks
diff --git a/tests/f_jnl_etb_alloc_fail/expect.1 b/tests/f_jnl_etb_alloc_fail/expect.1
index 8f4ebbb..243a151 100644
--- a/tests/f_jnl_etb_alloc_fail/expect.1
+++ b/tests/f_jnl_etb_alloc_fail/expect.1
@@ -1,7 +1,7 @@
 Superblock has an invalid journal (inode 8).
 Clear? yes
 
-*** ext3 journal has been deleted - filesystem is now ext2 only ***
+*** journal has been deleted ***
 
 Superblock has_journal flag is clear, but a journal is present.
 Clear? yes
diff --git a/tests/f_miss_journal/expect.1 b/tests/f_miss_journal/expect.1
index 6ec8b38..d435952 100644
--- a/tests/f_miss_journal/expect.1
+++ b/tests/f_miss_journal/expect.1
@@ -1,7 +1,7 @@
 Superblock has an invalid journal (inode 8).
 Clear? yes
 
-*** ext3 journal has been deleted - filesystem is now ext2 only ***
+*** journal has been deleted ***
 
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
@@ -21,7 +21,7 @@ Recreate journal? yes
 
 Creating journal (1024 blocks):  Done.
 
-*** journal has been re-created - filesystem is now ext3 again ***
+*** journal has been regenerated ***
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
 test_filesys: 11/256 files (0.0% non-contiguous), 1079/2048 blocks
diff --git a/tests/j_corrupt_sb_magic/expect b/tests/j_corrupt_sb_magic/expect
index 2169a15..d1dae88 100644
--- a/tests/j_corrupt_sb_magic/expect
+++ b/tests/j_corrupt_sb_magic/expect
@@ -1,7 +1,7 @@
 Superblock has an invalid journal (inode 8).
 Clear? yes
 
-*** ext3 journal has been deleted - filesystem is now ext2 only ***
+*** journal has been deleted ***
 
 Superblock has_journal flag is clear, but a journal is present.
 Clear? yes
@@ -26,7 +26,7 @@ Recreate journal? yes
 
 Creating journal (1024 blocks):  Done.
 
-*** journal has been re-created - filesystem is now ext3 again ***
+*** journal has been regenerated ***
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
 test_filesys: 12/128 files (0.0% non-contiguous), 1092/2048 blocks
diff --git a/tests/j_long_trans/expect b/tests/j_long_trans/expect
index 7638ef1..7a17541 100644
--- a/tests/j_long_trans/expect
+++ b/tests/j_long_trans/expect
@@ -57,7 +57,7 @@ test_filesys: recovering journal
 Superblock has an invalid journal (inode 8).
 Clear? yes
 
-*** ext3 journal has been deleted - filesystem is now ext2 only ***
+*** journal has been deleted ***
 
 Resize inode not valid.  Recreate? yes
 
@@ -100,7 +100,7 @@ Recreate journal? yes
 
 Creating journal (8192 blocks):  Done.
 
-*** journal has been re-created - filesystem is now ext3 again ***
+*** journal has been regenerated ***
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
 test_filesys: 11/16384 files (0.0% non-contiguous), 14420/262144 blocks
diff --git a/tests/j_long_trans_mcsum_32bit/expect b/tests/j_long_trans_mcsum_32bit/expect
index 0d141c1..a808d9f 100644
--- a/tests/j_long_trans_mcsum_32bit/expect
+++ b/tests/j_long_trans_mcsum_32bit/expect
@@ -93,7 +93,7 @@ test_filesys: recovering journal
 Superblock has an invalid journal (inode 8).
 Clear? yes
 
-*** ext3 journal has been deleted - filesystem is now ext2 only ***
+*** journal has been deleted ***
 
 Resize inode not valid.  Recreate? yes
 
@@ -139,7 +139,7 @@ Recreate journal? yes
 
 Creating journal (16384 blocks):  Done.
 
-*** journal has been re-created - filesystem is now ext3 again ***
+*** journal has been regenerated ***
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
 test_filesys: 11/32768 files (0.0% non-contiguous), 27039/524288 blocks
diff --git a/tests/j_long_trans_mcsum_64bit/expect b/tests/j_long_trans_mcsum_64bit/expect
index 94e9925..76e109a 100644
--- a/tests/j_long_trans_mcsum_64bit/expect
+++ b/tests/j_long_trans_mcsum_64bit/expect
@@ -92,7 +92,7 @@ test_filesys: recovering journal
 Superblock has an invalid journal (inode 8).
 Clear? yes
 
-*** ext3 journal has been deleted - filesystem is now ext2 only ***
+*** journal has been deleted ***
 
 Resize inode not valid.  Recreate? yes
 
@@ -138,7 +138,7 @@ Recreate journal? yes
 
 Creating journal (16384 blocks):  Done.
 
-*** journal has been re-created - filesystem is now ext3 again ***
+*** journal has been regenerated ***
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
 test_filesys: 11/32768 files (0.0% non-contiguous), 27057/524288 blocks
