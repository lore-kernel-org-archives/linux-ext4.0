From: akpm@linux-foundation.org
Subject: + ext3-add-missing-ext3_journal_stop.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:16:43 -0800
Message-ID: <200802181017.m1IAHfTK019834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: akinobu.mita@gmail.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: add missing ext3_journal_stop()
has been added to the -mm tree.  Its filename is
     ext3-add-missing-ext3_journal_stop.patch

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
Subject: ext3: add missing ext3_journal_stop()
From: Akinobu Mita <akinobu.mita@gmail.com>

Add missing ext3_journal_stop() in error handling.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/resize.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ext3/resize.c~ext3-add-missing-ext3_journal_stop fs/ext3/resize.c
--- a/fs/ext3/resize.c~ext3-add-missing-ext3_journal_stop
+++ a/fs/ext3/resize.c
@@ -1049,6 +1049,7 @@ int ext3_group_extend(struct super_block
 		ext3_warning(sb, __FUNCTION__,
 			     "multiple resizers run on filesystem!");
 		unlock_super(sb);
+		ext3_journal_stop(handle);
 		err = -EBUSY;
 		goto exit_put;
 	}
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

git-dvb.patch
ext2-improve-ext2_readdir-return-value.patch
ext2-use-ext2_group_first_block_no.patch
ext2-use-ext2_fsblk_t-type.patch
ext3-use-ext3_group_first_block_no.patch
ext3-add-missing-ext3_journal_stop.patch
ext3-use-ext3_get_group_desc.patch
ext3-check-ext3_journal_get_write_access-errors.patch
ext4-use-ext4_group_first_block_no.patch
ext4-add-missing-ext4_journal_stop.patch
ext4-use-ext4_get_group_desc.patch
ext4-check-ext4_journal_get_write_access-errors.patch
