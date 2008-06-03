From: akpm@linux-foundation.org
Subject: + ext4-fix-online-resize-bug.patch added to -mm tree
Date: Mon, 02 Jun 2008 17:20:09 -0700
Message-ID: <200806030020.m530K9Bx007256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: jbacik@redhat.com, adilger@sun.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: fix online resize bug
has been added to the -mm tree.  Its filename is
     ext4-fix-online-resize-bug.patch

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
Subject: ext4: fix online resize bug
From: Josef Bacik <jbacik@redhat.com>

There is a bug when we are trying to verify that the reserve inode's
double indirect blocks point back to the primary gdt blocks.  The fix is
obvious, we need to mod the gdb count by the addr's per block.  This was
verified using the same testcase as with the ext3 equivalent of this
patch.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/resize.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/ext4/resize.c~ext4-fix-online-resize-bug fs/ext4/resize.c
--- a/fs/ext4/resize.c~ext4-fix-online-resize-bug
+++ a/fs/ext4/resize.c
@@ -563,7 +563,8 @@ static int reserve_backup_gdb(handle_t *
 	}
 
 	blk = EXT4_SB(sb)->s_sbh->b_blocknr + 1 + EXT4_SB(sb)->s_gdb_count;
-	data = (__le32 *)dind->b_data + EXT4_SB(sb)->s_gdb_count;
+	data = (__le32 *)dind->b_data + (EXT4_SB(sb)->s_gdb_count %
+					 EXT4_ADDR_PER_BLOCK(sb));
 	end = (__le32 *)dind->b_data + EXT4_ADDR_PER_BLOCK(sb);
 
 	/* Get each reserved primary GDT block and verify it holds backups */
_

Patches currently in -mm which might be from jbacik@redhat.com are

ext3-fix-online-resize-bug.patch
ext4-fix-online-resize-bug.patch

