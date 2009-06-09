From: <gregkh@suse.de>
Subject: patch ext4-don-t-inherit-inappropriate-inode-flags-from-parent.patch added to 2.6.29-stable tree
Date: Tue, 09 Jun 2009 02:33:00 -0700
Message-ID: <20090609094016.928B1488FC@coco.kroah.org>
References: <1243944479-20574-1-git-send-email-tytso@mit.edu>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: duaneg@dghda.com, adilger@sun.com, akpm@linux-foundation.org,
	gregkh@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:46628 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757100AbZFIJkR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2009 05:40:17 -0400
In-Reply-To: <1243944479-20574-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: ext4: don't inherit inappropriate inode flags from parent

to the 2.6.29-stable tree.  Its filename is

    ext4-don-t-inherit-inappropriate-inode-flags-from-parent.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org  Tue Jun  9 02:24:00 2009
From: Duane Griffin <duaneg@dghda.com>
Date: Tue,  2 Jun 2009 08:07:42 -0400
Subject: ext4: don't inherit inappropriate inode flags from parent
To: stable@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>, Duane Griffin <duaneg@dghda.com>
Message-ID: <1243944479-20574-1-git-send-email-tytso@mit.edu>


From: Duane Griffin <duaneg@dghda.com>

(cherry picked from commit 8fa43a81b97853fc69417bb6054182e78f95cbeb)

At present INDEX and EXTENTS are the only flags that new ext4 inodes do
NOT inherit from their parent.  In addition prevent the flags DIRTY,
ECOMPR, IMAGIC, TOPDIR, HUGE_FILE and EXT_MIGRATE from being inherited.
List inheritable flags explicitly to prevent future flags from
accidentally being inherited.

This fixes the TOPDIR flag inheritance bug reported at
http://bugzilla.kernel.org/show_bug.cgi?id=9866.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Acked-by: Andreas Dilger <adilger@sun.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/ext4.h   |    7 +++++++
 fs/ext4/ialloc.c |    2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -248,6 +248,13 @@ struct flex_groups {
 #define EXT4_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */
 #define EXT4_FL_USER_MODIFIABLE		0x000B80FF /* User modifiable flags */
 
+/* Flags that should be inherited by new inodes from their parent. */
+#define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
+			   EXT4_SYNC_FL | EXT4_IMMUTABLE_FL | EXT4_APPEND_FL |\
+			   EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
+			   EXT4_NOCOMPR_FL | EXT4_JOURNAL_DATA_FL |\
+			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL)
+
 /*
  * Inode dynamic state flags
  */
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -889,7 +889,7 @@ got:
 	 * newly created directory and file only if -o extent mount option is
 	 * specified
 	 */
-	ei->i_flags = EXT4_I(dir)->i_flags & ~(EXT4_INDEX_FL|EXT4_EXTENTS_FL);
+	ei->i_flags = EXT4_I(dir)->i_flags & EXT4_FL_INHERITED;
 	if (S_ISLNK(mode))
 		ei->i_flags &= ~(EXT4_IMMUTABLE_FL|EXT4_APPEND_FL);
 	/* dirsync only applies to directories */


Patches currently in stable-queue which might be from duaneg@dghda.com are

