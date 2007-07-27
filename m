From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] e2fsprogs: Support for large inode migration.
Date: Sat, 28 Jul 2007 00:33:52 +0530
Message-ID: <46AA4198.9060905@linux.vnet.ibm.com>
References: <bee58d48110eee4d5cd133167245b99644148d96.1185341470.git.aneesh.kumar@linux.vnet.ibm.com> <3ae4c55b831a13f9fbb9a187efcd65d29434bf09.1185341470.git.aneesh.kumar@linux.vnet.ibm.com> <20070725143209.GA23613@thunk.org> <46A8895A.5000308@linux.vnet.ibm.com> <20070726161325.GB12895@thunk.org> <46A95F93.3020001@linux.vnet.ibm.com> <20070727153419.GA13515@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:53473 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765AbXG0TEG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Jul 2007 15:04:06 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l6RJ6C4q6500394
	for <linux-ext4@vger.kernel.org>; Sat, 28 Jul 2007 05:06:13 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6RJ7biM182218
	for <linux-ext4@vger.kernel.org>; Sat, 28 Jul 2007 05:07:37 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6RJ44Ef004477
	for <linux-ext4@vger.kernel.org>; Sat, 28 Jul 2007 05:04:04 +1000
In-Reply-To: <20070727153419.GA13515@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Theodore Tso wrote:
> On Fri, Jul 27, 2007 at 08:29:31AM +0530, Aneesh Kumar K.V wrote:
>> What are the issues you see with PATCH 1 and PATCH 2 which implement 
>> Undo I/O Manager and undoe2fs other than it is not hooked into any of
>> the existing tools. I will try to add it to mke2fs as you suggested. But
>> should that prevent it from going in ?
> 
> The main issue is that it's not used by an in-tree caller.  If you can
> add it to mke2fs, that would be great; 


diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 0c6d4f3..fab8830 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1521,6 +1521,92 @@ static void PRS(int argc, char *argv[])
 						fs_param.s_blocks_count);
 }
 
+static int fileystem_exist(const char *name)
+{
+	int retval;
+	io_channel channel;
+	__u16	s_magic;
+	struct ext2_super_block super;
+	io_manager manager = unix_io_manager;
+
+	retval = manager->open(name, IO_FLAG_EXCLUSIVE,  &channel);
+	if (retval) {
+		retval = 0;
+		goto open_err_out;
+	}
+
+	io_channel_set_blksize(channel, SUPERBLOCK_OFFSET);
+	retval = io_channel_read_blk(channel, 1, -SUPERBLOCK_SIZE, &super);
+	if (retval) {
+		retval = 0;
+		goto err_out;
+	}
+
+#if defined(WORDS_BIGENDIAN)
+	s_magic = ext2fs_swab16(super.s_magic);
+#else
+	s_magic = super.s_magic;
+#endif
+
+	if (s_magic == EXT2_SUPER_MAGIC)
+		retval = 1;
+
+err_out:
+	io_channel_close(channel);
+
+open_err_out:
+
+	/*
+	 * We don't handle error cases instead we
+	 * declare that the file system doesn't exist
+	 * and let the rest of mke2fs take care of
+	 * error
+	 */
+	return retval;
+}
+
+static int mke2fs_setup_tdb(const char *name)
+{
+	char *tdb_dir, tdb_file[PATH_MAX];
+#if 0 /* FIXME!! */
+	/*
+	 * Configuration via a conf file would be
+	 * nice
+	 */
+	profile_get_string(profile, "scratch_files",
+					"directory", 0, 0,
+					&tdb_dir);
+#endif
+	tdb_dir = getenv("MKE2FS_SCRATCH_DIR");
+	if (!tdb_dir) {
+		printf(_("MKE2FS_SCRATCH_DIR not configured\n"));
+		printf(_("Using /var/lib/e2fsprogs\n"));
+		tdb_dir="/var/lib/e2fsprogs";
+	}
+	if (access(tdb_dir, W_OK)) {
+		fprintf(stderr,
+			_("Cannot create file under %s\n"),
+			tdb_dir);
+		return EXT2_ET_INVALID_ARGUMENT;
+
+	}
+
+	/* FIXME!! Should we generate Unique file name ?? */
+	sprintf(tdb_file, "%s/mke2fs-XXXXXX", tdb_dir);
+
+	if (!access(tdb_file, F_OK)) {
+		fprintf(stderr,
+			_("File exist %s\n"), tdb_file);
+		return EXT2_ET_INVALID_ARGUMENT;
+	}
+
+	set_undo_io_backup_file(tdb_file);
+	printf(_("previous filesystem detected; to undo "
+		 "the mke2fs operation, please run the "
+		 "command \n'undoe2fs %s %s' in order to recover\n\n"),
+		  tdb_file, name);
+	return 0;
+}
 int main (int argc, char *argv[])
 {
 	errcode_t	retval = 0;
@@ -1543,7 +1629,17 @@ int main (int argc, char *argv[])
 	io_ptr = test_io_manager;
 	test_io_backing_manager = unix_io_manager;
 #else
-	io_ptr = unix_io_manager;
+	if (fileystem_exist(device_name)) {
+
+		io_ptr = undo_io_manager;
+		set_undo_io_backing_manager(unix_io_manager);
+		retval = mke2fs_setup_tdb(device_name);
+		if (retval)
+			exit(1);
+
+	} else {
+		io_ptr = unix_io_manager;
+	}
 #endif
 
 	/*
