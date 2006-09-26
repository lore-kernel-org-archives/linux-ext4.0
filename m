From: Alexandre Ratchov <alexandre.ratchov@bull.net>
Subject: [patch 08/12] rfc: 2fsprogs update
Date: Tue, 26 Sep 2006 16:49:15 +0200
Message-ID: <20060926144915.GH25755@openx1.frec.bull.fr>
References: <20060926143343.GA20020@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:50313 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S932105AbWIZOtY
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Sep 2006 10:49:24 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id DC26819D915
	for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2006 16:49:20 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 12580-01 for <linux-ext4@vger.kernel.org>;
 Tue, 26 Sep 2006 16:49:17 +0200 (CEST)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id BB82A19D90C
	for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2006 16:49:16 +0200 (CEST)
To: linux-ext4@vger.kernel.org
In-Reply-To: <20060926143343.GA20020@openx1.frec.bull.fr>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

use 64bit offsets and block numbers (unsigned long long) in
*_read_blk, *_write_blk, and friends.

Signed-off-by: Alexandre Ratchov <alexandre.ratchov@bull.net>              


Index: e2fsprogs-1.39/debugfs/debugfs.c
===================================================================
--- e2fsprogs-1.39.orig/debugfs/debugfs.c	2006-09-19 17:29:59.000000000 +0200
+++ e2fsprogs-1.39/debugfs/debugfs.c	2006-09-19 17:30:00.000000000 +0200
@@ -149,13 +149,13 @@ void do_open_filesys(int argc, char **ar
 			data_filename = optarg;
 			break;
 		case 'b':
-			blocksize = parse_ulong(optarg, argv[0],
+			blocksize = parse_ullong(optarg, argv[0],
 						"block size", &err);
 			if (err)
 				return;
 			break;
 		case 's':
-			superblock = parse_ulong(optarg, argv[0],
+			superblock = parse_ullong(optarg, argv[0],
 						 "superblock number", &err);
 			if (err)
 				return;
@@ -232,7 +232,7 @@ void do_init_filesys(int argc, char **ar
 		return;
 
 	memset(&param, 0, sizeof(struct ext2_super_block));
-	param.s_blocks_count = parse_ulong(argv[2], argv[0],
+	param.s_blocks_count = parse_ullong(argv[2], argv[0],
 					   "blocks count", &err);
 	if (err)
 		return;
@@ -1685,7 +1685,7 @@ void do_bmap(int argc, char *argv[])
 	ino = string_to_inode(argv[1]);
 	if (!ino)
 		return;
-	blk = parse_ulong(argv[2], argv[0], "logical_block", &err);
+	blk = parse_ullong(argv[2], argv[0], "logical_block", &err);
 
 	errcode = ext2fs_bmap(current_fs, ino, 0, 0, 0, blk, &pblk);
 	if (errcode) {
@@ -1823,11 +1823,11 @@ int main(int argc, char **argv)
 			open_flags |= EXT2_FLAG_RW;
 			break;
 		case 'b':
-			blocksize = parse_ulong(optarg, argv[0], 
+			blocksize = parse_ullong(optarg, argv[0], 
 						"block size", 0);
 			break;
 		case 's':
-			superblock = parse_ulong(optarg, argv[0], 
+			superblock = parse_ullong(optarg, argv[0], 
 						 "superblock number", 0);
 			break;
 		case 'c':
Index: e2fsprogs-1.39/debugfs/debugfs.h
===================================================================
--- e2fsprogs-1.39.orig/debugfs/debugfs.h	2006-09-19 17:29:54.000000000 +0200
+++ e2fsprogs-1.39/debugfs/debugfs.h	2006-09-19 17:30:00.000000000 +0200
@@ -32,7 +32,7 @@ extern int check_fs_bitmaps(char *name);
 extern ext2_ino_t string_to_inode(char *str);
 extern char *time_to_string(__u32);
 extern time_t string_to_time(const char *);
-extern unsigned long parse_ulong(const char *str, const char *cmd,
+extern unsigned long long parse_ullong(const char *str, const char *cmd,
 				 const char *descr, int *err);
 extern int strtoblk(const char *cmd, const char *str, blk_t *ret);
 extern int common_args_process(int argc, char *argv[], int min_argc,
Index: e2fsprogs-1.39/debugfs/util.c
===================================================================
--- e2fsprogs-1.39.orig/debugfs/util.c	2006-09-19 17:29:54.000000000 +0200
+++ e2fsprogs-1.39/debugfs/util.c	2006-09-19 17:30:00.000000000 +0200
@@ -238,16 +238,16 @@ extern time_t string_to_time(const char 
 }
 
 /*
- * This function will convert a string to an unsigned long, printing
+ * This function will convert a string to an unsigned long long, printing
  * an error message if it fails, and returning success or failure in err.
  */
-unsigned long parse_ulong(const char *str, const char *cmd,
+unsigned long long parse_ullong(const char *str, const char *cmd,
 			  const char *descr, int *err)
 {
 	char		*tmp;
-	unsigned long	ret;
+	unsigned long long	ret;
 	
-	ret = strtoul(str, &tmp, 0);
+	ret = strtoull(str, &tmp, 0);
 	if (*tmp == 0) {
 		if (err)
 			*err = 0;
@@ -270,7 +270,7 @@ int strtoblk(const char *cmd, const char
 	blk_t	blk;
 	int	err;
 
-	blk = parse_ulong(str, cmd, "block number", &err);
+	blk = parse_ullong(str, cmd, "block number", &err);
 	*ret = blk;
 	if (err == 0 && blk == 0) {
 		com_err(cmd, 0, "Invalid block number 0");
@@ -336,7 +336,7 @@ int common_block_args_process(int argc, 
 	if (strtoblk(argv[0], argv[1], block))
 		return 1;
 	if (argc > 2) {
-		*count = parse_ulong(argv[2], argv[0], "count", &err);
+		*count = parse_ullong(argv[2], argv[0], "count", &err);
 		if (err)
 			return 1;
 	}
Index: e2fsprogs-1.39/e2fsck/ehandler.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/ehandler.c	2006-09-19 17:29:54.000000000 +0200
+++ e2fsprogs-1.39/e2fsck/ehandler.c	2006-09-19 17:30:00.000000000 +0200
@@ -20,7 +20,7 @@
 static const char *operation;
 
 static errcode_t e2fsck_handle_read_error(io_channel channel,
-					  unsigned long block,
+					  unsigned long long block,
 					  int count,
 					  void *data,
 					  size_t size EXT2FS_ATTR((unused)),
@@ -66,7 +66,7 @@ static errcode_t e2fsck_handle_read_erro
 }
 
 static errcode_t e2fsck_handle_write_error(io_channel channel,
-					    unsigned long block,
+					    unsigned long long block,
 					    int count,
 					    const void *data,
 					    size_t size EXT2FS_ATTR((unused)),
Index: e2fsprogs-1.39/lib/e2p/e2p.h
===================================================================
--- e2fsprogs-1.39.orig/lib/e2p/e2p.h	2006-09-19 17:29:54.000000000 +0200
+++ e2fsprogs-1.39/lib/e2p/e2p.h	2006-09-19 17:30:00.000000000 +0200
@@ -46,7 +46,7 @@ const char *e2p_mntopt2string(unsigned i
 int e2p_string2mntopt(char *string, unsigned int *mask);
 int e2p_edit_mntopts(const char *str, __u32 *mntopts, __u32 ok);
 
-unsigned long parse_num_blocks(const char *arg, int log_block_size);
+unsigned long long parse_num_blocks(const char *arg, int log_block_size);
 
 char *e2p_os2string(int os_type);
 int e2p_string2os(char *str);
Index: e2fsprogs-1.39/lib/e2p/parse_num.c
===================================================================
--- e2fsprogs-1.39.orig/lib/e2p/parse_num.c	2006-09-19 17:29:54.000000000 +0200
+++ e2fsprogs-1.39/lib/e2p/parse_num.c	2006-09-19 17:30:00.000000000 +0200
@@ -11,7 +11,7 @@
 
 #include <stdlib.h>
 
-unsigned long parse_num_blocks(const char *arg, int log_block_size)
+unsigned long long parse_num_blocks(const char *arg, int log_block_size)
 {
 	char *p;
 	unsigned long long num;
Index: e2fsprogs-1.39/lib/ext2fs/ext2_io.h
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/ext2_io.h	2006-09-19 17:29:54.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/ext2_io.h	2006-09-19 17:30:00.000000000 +0200
@@ -35,14 +35,14 @@ struct struct_io_channel {
 	char		*name;
 	int		block_size;
 	errcode_t	(*read_error)(io_channel channel,
-				      unsigned long block,
+				      unsigned long long block,
 				      int count,
 				      void *data,
 				      size_t size,
 				      int actual_bytes_read,
 				      errcode_t	error);
 	errcode_t	(*write_error)(io_channel channel,
-				       unsigned long block,
+				       unsigned long long block,
 				       int count,
 				       const void *data,
 				       size_t size,
@@ -61,12 +61,12 @@ struct struct_io_manager {
 	errcode_t (*open)(const char *name, int flags, io_channel *channel);
 	errcode_t (*close)(io_channel channel);
 	errcode_t (*set_blksize)(io_channel channel, int blksize);
-	errcode_t (*read_blk)(io_channel channel, unsigned long block,
+	errcode_t (*read_blk)(io_channel channel, unsigned long long block,
 			      int count, void *data);
-	errcode_t (*write_blk)(io_channel channel, unsigned long block,
+	errcode_t (*write_blk)(io_channel channel, unsigned long long block,
 			       int count, const void *data);
 	errcode_t (*flush)(io_channel channel);
-	errcode_t (*write_byte)(io_channel channel, unsigned long offset,
+	errcode_t (*write_byte)(io_channel channel, unsigned long long offset,
 				int count, const void *data);
 	errcode_t (*set_option)(io_channel channel, const char *option, 
 				const char *arg);
@@ -99,9 +99,9 @@ extern io_manager unix_io_manager;
 /* test_io.c */
 extern io_manager test_io_manager, test_io_backing_manager;
 extern void (*test_io_cb_read_blk)
-	(unsigned long block, int count, errcode_t err);
+	(unsigned long long block, int count, errcode_t err);
 extern void (*test_io_cb_write_blk)
-	(unsigned long block, int count, errcode_t err);
+	(unsigned long long block, int count, errcode_t err);
 extern void (*test_io_cb_set_blksize)
 	(int blksize, errcode_t err);
 
Index: e2fsprogs-1.39/lib/ext2fs/inode_io.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/inode_io.c	2006-09-19 17:29:54.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/inode_io.c	2006-09-19 17:30:00.000000000 +0200
@@ -49,12 +49,12 @@ static int ino_unique = 0;
 static errcode_t inode_open(const char *name, int flags, io_channel *channel);
 static errcode_t inode_close(io_channel channel);
 static errcode_t inode_set_blksize(io_channel channel, int blksize);
-static errcode_t inode_read_blk(io_channel channel, unsigned long block,
+static errcode_t inode_read_blk(io_channel channel, unsigned long long block,
 			       int count, void *data);
-static errcode_t inode_write_blk(io_channel channel, unsigned long block,
+static errcode_t inode_write_blk(io_channel channel, unsigned long long block,
 				int count, const void *data);
 static errcode_t inode_flush(io_channel channel);
-static errcode_t inode_write_byte(io_channel channel, unsigned long offset,
+static errcode_t inode_write_byte(io_channel channel, unsigned long long offset,
 				int size, const void *data);
 
 static struct struct_io_manager struct_inode_manager = {
@@ -197,7 +197,7 @@ static errcode_t inode_set_blksize(io_ch
 }
 
 
-static errcode_t inode_read_blk(io_channel channel, unsigned long block,
+static errcode_t inode_read_blk(io_channel channel, unsigned long long block,
 			       int count, void *buf)
 {
 	struct inode_private_data *data;
@@ -217,7 +217,7 @@ static errcode_t inode_read_blk(io_chann
 	return ext2fs_file_read(data->file, buf, count, 0);
 }
 
-static errcode_t inode_write_blk(io_channel channel, unsigned long block,
+static errcode_t inode_write_blk(io_channel channel, unsigned long long block,
 				int count, const void *buf)
 {
 	struct inode_private_data *data;
@@ -237,7 +237,7 @@ static errcode_t inode_write_blk(io_chan
 	return ext2fs_file_write(data->file, buf, count, 0);
 }
 
-static errcode_t inode_write_byte(io_channel channel, unsigned long offset,
+static errcode_t inode_write_byte(io_channel channel, unsigned long long offset,
 				 int size, const void *buf)
 {
 	struct inode_private_data *data;
Index: e2fsprogs-1.39/lib/ext2fs/test_io.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/test_io.c	2006-09-19 17:29:54.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/test_io.c	2006-09-19 17:30:00.000000000 +0200
@@ -48,21 +48,21 @@ struct test_private_data {
 	FILE *outfile;
 	unsigned long block;
 	int read_abort_count, write_abort_count;
-	void (*read_blk)(unsigned long block, int count, errcode_t err);
-	void (*write_blk)(unsigned long block, int count, errcode_t err);
+	void (*read_blk)(unsigned long long block, int count, errcode_t err);
+	void (*write_blk)(unsigned long long block, int count, errcode_t err);
 	void (*set_blksize)(int blksize, errcode_t err);
-	void (*write_byte)(unsigned long block, int count, errcode_t err);
+	void (*write_byte)(unsigned long long block, int count, errcode_t err);
 };
 
 static errcode_t test_open(const char *name, int flags, io_channel *channel);
 static errcode_t test_close(io_channel channel);
 static errcode_t test_set_blksize(io_channel channel, int blksize);
-static errcode_t test_read_blk(io_channel channel, unsigned long block,
+static errcode_t test_read_blk(io_channel channel, unsigned long long block,
 			       int count, void *data);
-static errcode_t test_write_blk(io_channel channel, unsigned long block,
+static errcode_t test_write_blk(io_channel channel, unsigned long long block,
 				int count, const void *data);
 static errcode_t test_flush(io_channel channel);
-static errcode_t test_write_byte(io_channel channel, unsigned long offset,
+static errcode_t test_write_byte(io_channel channel, unsigned long long offset,
 				 int count, const void *buf);
 static errcode_t test_set_option(io_channel channel, const char *option, 
 				 const char *arg);
@@ -88,13 +88,13 @@ io_manager test_io_manager = &struct_tes
  */
 io_manager test_io_backing_manager = 0;
 void (*test_io_cb_read_blk)
-	(unsigned long block, int count, errcode_t err) = 0;
+	(unsigned long long block, int count, errcode_t err) = 0;
 void (*test_io_cb_write_blk)
-	(unsigned long block, int count, errcode_t err) = 0;
+	(unsigned long long block, int count, errcode_t err) = 0;
 void (*test_io_cb_set_blksize)
 	(int blksize, errcode_t err) = 0;
 void (*test_io_cb_write_byte)
-	(unsigned long block, int count, errcode_t err) = 0;
+	(unsigned long long block, int count, errcode_t err) = 0;
 
 /*
  * Test flags
@@ -108,7 +108,7 @@ void (*test_io_cb_write_byte)
 
 static void test_dump_block(io_channel channel,
 			    struct test_private_data *data,
-			    unsigned long block, const void *buf)
+			    unsigned long long block, const void *buf)
 {
 	const unsigned char *cp;
 	FILE *f = data->outfile;
@@ -118,7 +118,7 @@ static void test_dump_block(io_channel c
 	for (i=0, cp = buf; i < channel->block_size; i++, cp++) {
 		cksum += *cp;
 	}
-	fprintf(f, "Contents of block %lu, checksum %08lu: \n", block, cksum);
+	fprintf(f, "Contents of block %llu, checksum %08lu: \n", block, cksum);
 	for (i=0, cp = buf; i < channel->block_size; i++, cp++) {
 		if ((i % 16) == 0)
 			fprintf(f, "%04x: ", i);
@@ -126,7 +126,7 @@ static void test_dump_block(io_channel c
 	}
 }
 
-static void test_abort(io_channel channel, unsigned long block)
+static void test_abort(io_channel channel, unsigned long long block)
 {
 	struct test_private_data *data;
 	FILE *f;
@@ -135,7 +135,7 @@ static void test_abort(io_channel channe
 	f = data->outfile;
 	test_flush(channel);
 
-	fprintf(f, "Aborting due to I/O to block %lu\n", block);
+	fprintf(f, "Aborting due to I/O to block %llu\n", block);
 	fflush(f);
 	abort();
 }
@@ -286,7 +286,7 @@ static errcode_t test_set_blksize(io_cha
 }
 
 
-static errcode_t test_read_blk(io_channel channel, unsigned long block,
+static errcode_t test_read_blk(io_channel channel, unsigned long long block,
 			       int count, void *buf)
 {
 	struct test_private_data *data;
@@ -302,7 +302,7 @@ static errcode_t test_read_blk(io_channe
 		data->read_blk(block, count, retval);
 	if (data->flags & TEST_FLAG_READ)
 		fprintf(data->outfile,
-			"Test_io: read_blk(%lu, %d) returned %s\n",
+			"Test_io: read_blk(%llu, %d) returned %s\n",
 			block, count, retval ? error_message(retval) : "OK");
 	if (data->block && data->block == block) {
 		if (data->flags & TEST_FLAG_DUMP)
@@ -313,7 +313,7 @@ static errcode_t test_read_blk(io_channe
 	return retval;
 }
 
-static errcode_t test_write_blk(io_channel channel, unsigned long block,
+static errcode_t test_write_blk(io_channel channel, unsigned long long block,
 			       int count, const void *buf)
 {
 	struct test_private_data *data;
@@ -329,7 +329,7 @@ static errcode_t test_write_blk(io_chann
 		data->write_blk(block, count, retval);
 	if (data->flags & TEST_FLAG_WRITE)
 		fprintf(data->outfile,
-			"Test_io: write_blk(%lu, %d) returned %s\n",
+			"Test_io: write_blk(%llu, %d) returned %s\n",
 			block, count, retval ? error_message(retval) : "OK");
 	if (data->block && data->block == block) {
 		if (data->flags & TEST_FLAG_DUMP)
@@ -340,7 +340,7 @@ static errcode_t test_write_blk(io_chann
 	return retval;
 }
 
-static errcode_t test_write_byte(io_channel channel, unsigned long offset,
+static errcode_t test_write_byte(io_channel channel, unsigned long long offset,
 			       int count, const void *buf)
 {
 	struct test_private_data *data;
@@ -356,7 +356,7 @@ static errcode_t test_write_byte(io_chan
 		data->write_byte(offset, count, retval);
 	if (data->flags & TEST_FLAG_WRITE)
 		fprintf(data->outfile,
-			"Test_io: write_byte(%lu, %d) returned %s\n",
+			"Test_io: write_byte(%llu, %d) returned %s\n",
 			offset, count, retval ? error_message(retval) : "OK");
 	return retval;
 }
Index: e2fsprogs-1.39/lib/ext2fs/unix_io.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/unix_io.c	2006-09-19 17:29:54.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/unix_io.c	2006-09-19 17:30:42.000000000 +0200
@@ -75,12 +75,12 @@ struct unix_private_data {
 static errcode_t unix_open(const char *name, int flags, io_channel *channel);
 static errcode_t unix_close(io_channel channel);
 static errcode_t unix_set_blksize(io_channel channel, int blksize);
-static errcode_t unix_read_blk(io_channel channel, unsigned long block,
+static errcode_t unix_read_blk(io_channel channel, unsigned long long block,
 			       int count, void *data);
-static errcode_t unix_write_blk(io_channel channel, unsigned long block,
+static errcode_t unix_write_blk(io_channel channel, unsigned long long block,
 				int count, const void *data);
 static errcode_t unix_flush(io_channel channel);
-static errcode_t unix_write_byte(io_channel channel, unsigned long offset,
+static errcode_t unix_write_byte(io_channel channel, unsigned long long offset,
 				int size, const void *data);
 static errcode_t unix_set_option(io_channel channel, const char *option, 
 				 const char *arg);
@@ -522,7 +522,7 @@ static errcode_t unix_set_blksize(io_cha
 }
 
 
-static errcode_t unix_read_blk(io_channel channel, unsigned long block,
+static errcode_t unix_read_blk(io_channel channel, unsigned long long block,
 			       int count, void *buf)
 {
 	struct unix_private_data *data;
@@ -587,7 +587,7 @@ static errcode_t unix_read_blk(io_channe
 #endif /* NO_IO_CACHE */
 }
 
-static errcode_t unix_write_blk(io_channel channel, unsigned long block,
+static errcode_t unix_write_blk(io_channel channel, unsigned long long block,
 				int count, const void *buf)
 {
 	struct unix_private_data *data;
@@ -639,7 +639,7 @@ static errcode_t unix_write_blk(io_chann
 #endif /* NO_IO_CACHE */
 }
 
-static errcode_t unix_write_byte(io_channel channel, unsigned long offset,
+static errcode_t unix_write_byte(io_channel channel, unsigned long long offset,
 				 int size, const void *buf)
 {
 	struct unix_private_data *data;
