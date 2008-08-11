From: akpm@linux-foundation.org
Subject: + ext4-dont-try-to-resize-if-there-are-no-reserved-gdt-blocks-left.patch added to -mm tree
Date: Mon, 11 Aug 2008 14:50:50 -0700
Message-ID: <200808112150.m7BLooOX023263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: jbacik@redhat.com, adilger@sun.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: don't try to resize if there are no reserved gdt blocks left
has been added to the -mm tree.  Its filename is
     ext4-dont-try-to-resize-if-there-are-no-reserved-gdt-blocks-left.patch

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
Subject: ext4: don't try to resize if there are no reserved gdt blocks left
From: Josef Bacik <jbacik@redhat.com>

When trying to resize a ext3 fs and you run out of reserved gdt blocks,
you get an error that doesn't actually tell you what went wrong, it just
says that the gdb it picked is not correct, which is the case since you
don't have any reserved gdt blocks left.  This patch adds a check to make
sure you have reserved gdt blocks to use, and if not prints out a more
relevant error.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Cc: Andreas Dilger <adilger@sun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/resize.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/ext4/resize.c~ext4-dont-try-to-resize-if-there-are-no-reserved-gdt-blocks-left fs/ext4/resize.c
--- a/fs/ext4/resize.c~ext4-dont-try-to-resize-if-there-are-no-reserved-gdt-blocks-left
+++ a/fs/ext4/resize.c
@@ -773,7 +773,8 @@ int ext4_group_add(struct super_block *s
 
 	if (reserved_gdb || gdb_off == 0) {
 		if (!EXT4_HAS_COMPAT_FEATURE(sb,
-					     EXT4_FEATURE_COMPAT_RESIZE_INODE)){
+					     EXT4_FEATURE_COMPAT_RESIZE_INODE)
+		    || !le16_to_cpu(es->s_reserved_gdt_blocks)) {
 			ext4_warning(sb, __func__,
 				     "No reserved GDT blocks, can't resize");
 			return -EPERM;
_

Patches currently in -mm which might be from jbacik@redhat.com are

ext3-dont-try-to-resize-if-there-are-no-reserved-gdt-blocks-left.patch
ext4-dont-try-to-resize-if-there-are-no-reserved-gdt-blocks-left.patch

