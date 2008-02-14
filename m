From: akpm@linux-foundation.org
Subject: + ext3-convert-byte-order-of-constant-instead-of-variable.patch added to -mm tree
Date: Thu, 14 Feb 2008 14:19:50 -0800
Message-ID: <200802142219.m1EMJore005885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: marcin.slusarz@gmail.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: convert byte order of constant instead of variable
has been added to the -mm tree.  Its filename is
     ext3-convert-byte-order-of-constant-instead-of-variable.patch

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
Subject: ext3: convert byte order of constant instead of variable
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Convert byte order of constant instead of variable which can be done at
compile time (vs run time).

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext3/super.c~ext3-convert-byte-order-of-constant-instead-of-variable fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-convert-byte-order-of-constant-instead-of-variable
+++ a/fs/ext3/super.c
@@ -1218,7 +1218,7 @@ static int ext3_setup_super(struct super
                    inconsistencies, to force a fsck at reboot.  But for
                    a plain journaled filesystem we can keep it set as
                    valid forever! :) */
-	es->s_state = cpu_to_le16(le16_to_cpu(es->s_state) & ~EXT3_VALID_FS);
+	es->s_state &= cpu_to_le16(~EXT3_VALID_FS);
 #endif
 	if (!(__s16) le16_to_cpu(es->s_max_mnt_count))
 		es->s_max_mnt_count = cpu_to_le16(EXT3_DFL_MAX_MNT_COUNT);
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch
udf-fix-directory-offset-handling.patch
udf-fix-udf_add_free_space.patch
git-gfs2-nmw.patch
jfs-le_add_cpu-conversion.patch
ntfs-le_add_cpu-conversion.patch
ocfs2-le_add_cpu-conversion.patch
scsi-le_add_cpu-conversion.patch
ipw2200-le_add_cpu-conversion.patch
ext2-le_add_cpu-conversion.patch
ufs-e_add_cpu-conversion.patch
ufs-e_add_cpu-conversion-in-return.patch
reiserfs-le_add_cpu-conversion.patch
ext4-le_add_cpu-conversion.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
quota-le_add_cpu-conversion.patch
sysv-e_add_cpu-conversion.patch
ext2-convert-byte-order-of-constant-instead-of-variable.patch
ext3-convert-byte-order-of-constant-instead-of-variable.patch
ext4-convert-byte-order-of-constant-instead-of-variable.patch
