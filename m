From: eru@netti.fi
Subject: tune2fs crash in error situation
Date: Thu, 28 Sep 2017 15:01:15 +0300
Message-ID: <55a8dd42bcb78c1b965ba5ca159e7a9b@be409.mail.saunalahti.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:43151 "EHLO
        gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752472AbdI1MKE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Sep 2017 08:10:04 -0400
Received: from cfwo-21-2.mail.saunalahti.fi (cfwo-21.mail.saunalahti.fi [62.142.5.103])
        by gw03.mail.saunalahti.fi (Postfix) with ESMTP id 8ABD9200C8
        for <linux-ext4@vger.kernel.org>; Thu, 28 Sep 2017 15:01:15 +0300 (EEST)
Received: from localhost (localhost [127.0.0.1])
        by cfwo-21-2.mail.saunalahti.fi (Postfix) with ESMTP id 7ACC020084
        for <linux-ext4@vger.kernel.org>; Thu, 28 Sep 2017 15:01:15 +0300 (EEST)
Received: from webmail.elisa.fi (wm-web17.pa.saunalahti.fi [195.197.1.110])
        by cfwo-21-2.mail.saunalahti.fi (Postfix) with ESMTP id 0EF712007E
        for <linux-ext4@vger.kernel.org>; Thu, 28 Sep 2017 15:01:15 +0300 (EEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tune2fs seems to coredump if the file system is not clean, so that it 
goes
to the branch calling ext2fs_run_ext3_journal(), and this then fails for
some reason while calling ext2fs_open2().

misc/tunefs.c:
..
         /* Recover the journal if possible. */
         if ((open_flag & EXT2_FLAG_RW) && !(mount_flags & 
EXT2_MF_MOUNTED) &&
             ext2fs_has_feature_journal_needs_recovery(fs->super)) {
                 errcode_t err;

                 printf(_("Recovering journal.\n"));
                 err = ext2fs_run_ext3_journal(&fs);
                 if (err) {
                         com_err("tune2fs", err, "while recovering 
journal.\n");
                         printf(_("Please run e2fsck -fy %s.\n"), 
argv[1]);
                         goto closefs;
                 }
                 ext2fs_clear_feature_journal_needs_recovery(fs->super);
                 ext2fs_mark_super_dirty(fs);
         }

Failures in ext2fs_open2() zero the fs pointer, and the goto closefs
leads to code that will dereference fs:

closefs:
         if (rc) {
                 ext2fs_mmp_stop(fs);
#ifndef BUILD_AS_LIB
                 exit(1);
#endif
         }

         convert_64bit(fs, feature_64bit);
         return (ext2fs_close_free(&fs) ? 1 : 0);

calling ext2fs_close_free(&fs) leads to

lib/ext2fs/closefs.c:
..
errcode_t ext2fs_close2(ext2_filsys fs, int flags)
{
         errcode_t       retval;
         int             meta_blks;
         io_stats stats = 0;

         EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);

and the dereference happens in that macro.

A crash because of this was observed when the device passed to tune2fs
was a /dev/disk/by-id/* link, and apparently udevd happened to 
manipulate
it while tune2fs was running. Or that at least is my theory for the
randomly observed error message:

  tune2fs: No such file or directory while recovering journal

that preceded the crash. This error situation could be reproduced
nondeterministically by a loop that calls tunefs with an unclean file
system (created by mounting an image to a VM, and the suddenly killing
the VM), and having the loop make the path invalid while tune2fs is 
running.

while true; do
   cp dirtyfs.img x.img
   ln -s /root/x.img /tmp/disk
   ./tune2fs -L somelabel /tmp/disk 2>>tunefs.error &
   sleep 0.1
   rm /tmp/disk
done

At least versions e2fsprogs-1.43.5 and e2fsprogs-1.43.6 are affected.
An obvious patch for the problem:

diff -ru e2fsprogs-1.43.6.orig/misc/tune2fs.c 
e2fsprogs-1.43.6/misc/tune2fs.c
--- e2fsprogs-1.43.6.orig/misc/tune2fs.c	2017-08-29 16:05:52.000000000 
+0300
+++ e2fsprogs-1.43.6/misc/tune2fs.c	2017-09-21 12:00:37.068873101 +0300
@@ -3256,6 +3256,9 @@
  #endif
  	}

-	convert_64bit(fs, feature_64bit);
-	return (ext2fs_close_free(&fs) ? 1 : 0);
+	if (fs) {
+		convert_64bit(fs, feature_64bit);
+		return (ext2fs_close_free(&fs) ? 1 : 0);
+	}
+	return 1;
  }


-- 
Erkki Ruohtula
