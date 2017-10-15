From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: tune2fs: prevent crash if error in journal recovery
Date: Sun, 15 Oct 2017 00:39:27 -0400
Message-ID: <20171015043927.ntqqt43kbxgvbcbk@thunk.org>
References: <96fd009e4552b48cd9d4e4f776dc7d20@be409.mail.saunalahti.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: eru@netti.fi
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48106 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750704AbdJOEjc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 15 Oct 2017 00:39:32 -0400
Content-Disposition: inline
In-Reply-To: <96fd009e4552b48cd9d4e4f776dc7d20@be409.mail.saunalahti.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 05, 2017 at 08:25:50AM +0300, eru@netti.fi wrote:
> Prevent coredump if tunefs calls ext2fs_run_ext3_journal(), and this 
> then
> fails for some reason while calling ext2fs_open2(). Such failure makes
> the fs pointer NULL.
> 
> Signed-off-by: Erkki Ruohtula <eru@netti.fi>

Hi,

Thanks for reporting this issue and sending a patch.  It turns out
there were more problems hiding ext2fs_run_ext3_journal() than just
the one you pointed out, and so the clean up was more extensive.

    	    	    	     	- Ted

commit 6ae16a6814f47c96c261519380df7a7820c8f468
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Oct 15 00:22:20 2017 -0400

    misc: clean up error handling for ext2fs_run_ext3_journal()
    
    The ext2fs_run_ext3_journal() function is in debugfs/journal.c, and in
    some error conditions cases may close the passed-in file system handle.
    
    Clean up the both the function so that it reliably clears the file
    system handle if it has been freed, and its callers so that they do
    not crash by dereferencing a null pointer if it has been freed.
    
    Reported-by: Erkki Ruohtula <eru@netti.fi>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/debugfs/journal.c b/debugfs/journal.c
index 9997c7c7c..56a68be52 100644
--- a/debugfs/journal.c
+++ b/debugfs/journal.c
@@ -793,14 +793,14 @@ errcode_t ext2fs_run_ext3_journal(ext2_filsys *fsp)
 		kbytes_written = stats->bytes_written >> 10;
 
 	ext2fs_mmp_stop(fs);
-	fsname = strdup(fs->device_name);
+	fsname = fs->device_name;
+	fs->device_name = NULL;
 	fsflags = fs->flags;
 	fsblocksize = fs->blocksize;
 	ext2fs_free(fs);
-	retval = ext2fs_open(fsname, fsflags,
-			     0, fsblocksize, io_ptr,
-			     fsp);
-	free(fsname);
+	*fsp = NULL;
+	retval = ext2fs_open(fsname, fsflags, 0, fsblocksize, io_ptr, fsp);
+	ext2fs_free_mem(&fsname);
 	if (retval)
 		return retval;
 
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index b5897685c..f14cefbad 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -3759,7 +3759,7 @@ int main(int argc, char *argv[])
 		fctx.err_fp = fopen(logfile, "a");
 		if (!fctx.err_fp) {
 			perror(logfile);
-			goto out_nofs;
+			goto out;
 		}
 	} else
 		fctx.err_fp = stderr;
@@ -3780,7 +3780,7 @@ int main(int argc, char *argv[])
 	if (err) {
 		printf(_("%s: %s.\n"), fctx.device, error_message(err));
 		printf(_("Please run e2fsck -fy %s.\n"), fctx.device);
-		goto out_nofs;
+		goto out;
 	}
 	fctx.fs = global_fs;
 	global_fs->priv_data = &fctx;
@@ -3869,12 +3869,12 @@ int main(int argc, char *argv[])
 
 	ret = 0;
 out:
-	err = ext2fs_close(global_fs);
-	if (err)
-		com_err(argv[0], err, "while closing fs");
-	global_fs = NULL;
-out_nofs:
-
+	if (global_fs) {
+		err = ext2fs_close(global_fs);
+		if (err)
+			com_err(argv[0], err, "while closing fs");
+		global_fs = NULL;
+	}
 	return ret;
 }
 
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 3e7ca23e1..db06003e0 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -465,9 +465,6 @@ static void request_fsck_afterwards(ext2_filsys fs)
 
 static void convert_64bit(ext2_filsys fs, int direction)
 {
-	if (!direction)
-		return;
