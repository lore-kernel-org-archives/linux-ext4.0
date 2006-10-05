From: akpm@osdl.org
Subject: + ext3-errors-behaviour-fix.patch added to -mm tree
Date: Thu, 05 Oct 2006 15:48:09 -0700
Message-ID: <200610052248.k95MmAfX007528@shell0.pdx.osdl.net>
Cc: dim@openvz.org, dev@openvz.org, linux-ext4@vger.kernel.org,
	vvs@sw.ru
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:29374 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751401AbWJEWs2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Oct 2006 18:48:28 -0400
To: mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled

     ext3: errors behaviour fix

has been added to the -mm tree.  Its filename is

     ext3-errors-behaviour-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext3: errors behaviour fix
From: Dmitry Mishin <dim@openvz.org>

Current error behaviour for ext2 and ext3 filesystems does not fully
correspond to the documentation and should be fixed.

According to man 8 mount, ext2 and ext3 file systems allow to set one of 3
different on-errors behaviours:

---- start of quote man 8 mount ----

errors=continue / errors=remount-ro / errors=panic

    Define the behaviour when an error is encountered.  (Either ignore
    errors and just mark the file system erroneous and continue, or remount
    the file system read-only, or panic and halt the system.) The default is
    set in the filesystem superblock, and can be changed using tune2fs(8).

---- end of quote ----

However EXT3_ERRORS_CONTINUE is not read from the superblock, and thus
ERRORS_CONT is not saved on the sbi->s_mount_opt.  It leads to the incorrect
handle of errors on ext3.

Then we've checked corresponding code in ext2 and discovered that it is buggy
as well:

- EXT2_ERRORS_CONTINUE is not read from the superblock (the same);

- parse_option() does not clean the alternative values and thus something
  like (ERRORS_CONT|ERRORS_RO) can be set;

- if options are omitted, parse_option() does not set any of these options.

Therefore it is possible to set any combination of these options on the ext2:

- none of them may be set: EXT2_ERRORS_CONTINUE on superblock / empty mount
  options;

- any of them may be set using mount options;

- 2 any options may be set: by using EXT2_ERRORS_RO/EXT2_ERRORS_PANIC on the
  superblock and other value in mount options;

- and finally all three options may be set by adding third option in remount.

Currently ext2 uses these values only in ext2_error() and it is not leading to
any noticeable troubles.  However somebody may be discouraged when he will try
to workaround EXT2_ERRORS_PANIC on the superblock by using errors=continue in
mount options.


This patch:

EXT3_ERRORS_CONTINUE should be taken from the superblock as default value for
error behaviour.

Signed-off-by:	Dmitry Mishin <dim@openvz.org>
Acked-by:	Vasily Averin <vvs@sw.ru>
Acked-by: 	Kirill Korotaev <dev@openvz.org>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext3/super.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN fs/ext3/super.c~ext3-errors-behaviour-fix fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-errors-behaviour-fix
+++ a/fs/ext3/super.c
@@ -1470,6 +1470,8 @@ static int ext3_fill_super (struct super
 		set_opt(sbi->s_mount_opt, ERRORS_PANIC);
 	else if (le16_to_cpu(sbi->s_es->s_errors) == EXT3_ERRORS_RO)
 		set_opt(sbi->s_mount_opt, ERRORS_RO);
+	else
+		set_opt(sbi->s_mount_opt, ERRORS_CONT);
 
 	sbi->s_resuid = le16_to_cpu(es->s_def_resuid);
 	sbi->s_resgid = le16_to_cpu(es->s_def_resgid);
diff -puN /dev/null /dev/null
_

Patches currently in -mm which might be from dim@openvz.org are

ext3-errors-behaviour-fix.patch

