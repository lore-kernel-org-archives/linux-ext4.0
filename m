From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH][e2fsprogs] Allow user to disable Undo manager through
	MKE2FS_SCRATCH_DIR
Date: Sun, 6 Apr 2008 18:19:47 -0400
Message-ID: <20080406221947.GA13284@mit.edu>
References: <20080404140235.28080.97243.stgit@gara.konoha.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:53220 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754240AbYDFXMP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Apr 2008 19:12:15 -0400
Content-Disposition: inline
In-Reply-To: <20080404140235.28080.97243.stgit@gara.konoha.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 04, 2008 at 09:02:35AM -0500, Jose R. Santos wrote:
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index c8170f0..3f9cbe2 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1802,6 +1802,13 @@ static int filesystem_exist(const char *name)
>  	__u16	s_magic;
>  	struct ext2_super_block super;
>  	io_manager manager = unix_io_manager;
> +	char *tdb_dir;
> +
> +	tdb_dir = getenv("MKE2FS_SCRATCH_DIR");
> +	if (tdb_dir && !strcmp(tdb_dir, "disable")) {
> +		retval = 0;
> +		goto open_err_out;
> +	}


Yuck.  Yuck, Yuck, Yuck, Yuck.

This functionality has nothing to do with filesystem_exist() and
putting this kind of magic (a) means you have to read the environment
variable twice, and (b) makes the code less maintainable in the
long run.

While I was looking at the code, I also realized that the way the undo
code was written it also wasn't compatible with configure
--enable-testio-deug.

So here's a much better patch that does the right thing.

Looking over the undo code more closely, there's much I find that's
ugly about this patch, including the fact that after you make a
filesystem at some device, say /dev/sda1, you have to manually go and
rm the file /var/lib/e2fsprogs/mke2fs-sda1 or you get the
non-intuitive error message "File exist /var/lib/e2fsprogs/mke2fs-sda1".  
This made me reach for the barf bag; the undo-mgr patch branch needs
cleanup before it's going into mainline.  In any case, here's a much
better patch which co-exists with testio-debugging, and which actually
decreases the number of lines of the code to support the undo feature.

(This will be merged into the patch "e2fsprogs: Make mke2fs use undo
I/O manager" before the whole branch gets integrated into the next or
master branches, using the magic that is git rebase --interactive.
Also needing fixing is the code to hook into the profile lookup.)

	  	      	     	      	     - Ted

commit 11079defe6c4bc3577381a8669f9944408d77023
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Apr 6 18:08:12 2008 -0400

    Allow user to disable Undo manager through MKE2FS_SCRATCH_DIR
    
    Undo manager is a bit annoying when doing e2fsprogs testing since it
    makes mke2fs significatly slower.  Use the MKE2FS_SCRATCH_DIR=disable
    enviroment value to disable undo manager for those of us that blow up
    filesystems on a regular basis.
    
    Also fix so that the undo manager doesn't conflict with configure
    --enable-testio-debug.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index a23d841..06558d8 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1605,7 +1605,7 @@ open_err_out:
 	return retval;
 }
 
-static int mke2fs_setup_tdb(const char *name)
+static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 {
 	errcode_t retval = 0;
 	char *tdb_dir, tdb_file[PATH_MAX];
@@ -1620,24 +1620,24 @@ static int mke2fs_setup_tdb(const char *name)
 			"directory", 0, 0,
 			&tdb_dir);
 #endif
-	tmp_name = strdup(name);
-	device_name = basename(tmp_name);
-
 	tdb_dir = getenv("MKE2FS_SCRATCH_DIR");
 	if (!tdb_dir) {
 		printf(_("MKE2FS_SCRATCH_DIR not configured\n"));
 		printf(_("Using /var/lib/e2fsprogs\n"));
 		tdb_dir="/var/lib/e2fsprogs";
 	}
+	if (!strcmp(tdb_dir, "disable"))
+		return 0;
+
 	if (access(tdb_dir, W_OK)) {
 		fprintf(stderr,
 			_("Cannot create file under %s\n"),
 			tdb_dir);
-		retval = EXT2_ET_INVALID_ARGUMENT;
-		goto err_out;
-
+		return (EXT2_ET_INVALID_ARGUMENT);
 	}
 
+	tmp_name = strdup(name);
+	device_name = basename(tmp_name);
 	sprintf(tdb_file, "%s/mke2fs-%s", tdb_dir, device_name);
 
 	if (!access(tdb_file, F_OK)) {
@@ -1647,6 +1647,8 @@ static int mke2fs_setup_tdb(const char *name)
 		goto err_out;
 	}
 
+	set_undo_io_backing_manager(*io_ptr);
+	*io_ptr = undo_io_manager;
 	set_undo_io_backup_file(tdb_file);
 	printf(_("previous filesystem detected; to undo "
 		"the mke2fs operation, please run the "
@@ -1679,18 +1681,14 @@ int main (int argc, char *argv[])
 	io_ptr = test_io_manager;
 	test_io_backing_manager = unix_io_manager;
 #else
-	if (filesystem_exist(device_name)) {
+	io_ptr = unix_io_manager;
+#endif
 
-		io_ptr = undo_io_manager;
-		set_undo_io_backing_manager(unix_io_manager);
-		retval = mke2fs_setup_tdb(device_name);
+	if (filesystem_exist(device_name)) {
+		retval = mke2fs_setup_tdb(device_name, &io_ptr);
 		if (retval)
 			exit(1);
