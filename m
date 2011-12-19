From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 02/10] libext2fs: add tests for the bitmap functions
Date: Mon, 19 Dec 2011 11:59:00 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1112191149090.30656@dhcp-27-109.brq.redhat.com>
References: <1324190558-7436-1-git-send-email-tytso@mit.edu> <1324190558-7436-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab1LSK7F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Dec 2011 05:59:05 -0500
In-Reply-To: <1324190558-7436-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 18 Dec 2011, Theodore Ts'o wrote:

> These tests allow us to be sure that the new bitmap backends are
> correctly implemented.

This looks good, just two tiny comments.

Thanks!
-Lukas

> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  lib/ext2fs/Makefile.in        |   17 ++-
>  lib/ext2fs/tst_bitmaps.c      |  577 +++++++++++++++++++++++++++++++++++++++++
>  lib/ext2fs/tst_bitmaps_cmd.ct |   39 +++
>  lib/ext2fs/tst_bitmaps_cmds   |   46 ++++
>  lib/ext2fs/tst_bitmaps_exp    |   92 +++++++
>  5 files changed, 770 insertions(+), 1 deletions(-)
>  create mode 100644 lib/ext2fs/tst_bitmaps.c
>  create mode 100644 lib/ext2fs/tst_bitmaps_cmd.ct
>  create mode 100644 lib/ext2fs/tst_bitmaps_cmds
>  create mode 100644 lib/ext2fs/tst_bitmaps_exp
> 
> diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
> index 3d08095..37f5ee5 100644
> --- a/lib/ext2fs/Makefile.in
> +++ b/lib/ext2fs/Makefile.in
> @@ -347,6 +347,16 @@ filefrag.o: $(top_srcdir)/debugfs/filefrag.c
>  	$(E) "	CC $<"
>  	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
>  
> +tst_bitmaps_cmd.c: tst_bitmaps_cmd.ct
> +	$(E) "	MK_CMDS $@"
> +	$(Q) DIR=$(srcdir) $(MK_CMDS) $(srcdir)/tst_bitmaps_cmd.ct
> +
> +tst_bitmaps: tst_bitmaps.o tst_bitmaps_cmd.o $(STATIC_LIBEXT2FS) $(DEPLIBSS) \
> +		$(DEPLIBCOM_ERR)
> +	$(E) "	LD $@"
> +	$(Q) $(CC) -o $@ tst_bitmaps.o tst_bitmaps_cmd.o $(ALL_CFLAGS) \
> +		$(STATIC_LIBEXT2FS) $(LIBSS) $(LIBCOM_ERR)
> +
>  tst_extents: $(srcdir)/extent.c extent_dbg.c $(DEBUG_OBJS) $(DEPLIBSS) \
>  	$(LIBE2P) $(DEPLIBUUID) $(DEPLIBBLKID) $(DEPLIBCOM_ERR)
>  	$(E) "	LD $@"
> @@ -369,7 +379,8 @@ mkjournal: mkjournal.c $(STATIC_LIBEXT2FS) $(DEPLIBCOM_ERR)
>  	$(E) "	LD $@"
>  	$(Q) $(CC) -o mkjournal $(srcdir)/mkjournal.c -DDEBUG $(STATIC_LIBEXT2FS) $(LIBCOM_ERR) $(ALL_CFLAGS)
>  
> -check:: tst_bitops tst_badblocks tst_iscan tst_types tst_icount tst_super_size tst_types tst_inode_size tst_csum tst_crc32c
> +check:: tst_bitops tst_badblocks tst_iscan tst_types tst_icount \
> +    tst_super_size tst_types tst_inode_size tst_csum tst_crc32c tst_bitmaps
>  	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_bitops
>  	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_badblocks
>  	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_iscan
> @@ -379,6 +390,9 @@ check:: tst_bitops tst_badblocks tst_iscan tst_types tst_icount tst_super_size t
>  	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_inode_size
>  	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_csum
>  	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_crc32c
> +	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) \
> +		./tst_bitmaps -f $(srcdir)/tst_bitmaps_cmds > tst_bitmaps_out
> +	diff $(srcdir)/tst_bitmaps_exp tst_bitmaps_out
>  
>  installdirs::
>  	$(E) "	MKINSTALLDIRS $(libdir) $(includedir)/ext2fs"
> @@ -411,6 +425,7 @@ clean::
>  		tst_badblocks tst_iscan ext2_err.et ext2_err.c ext2_err.h \
>  		tst_byteswap tst_ismounted tst_getsize tst_sectgetsize \
>  		tst_bitops tst_types tst_icount tst_super_size tst_csum \
> +		tst_bitmaps tst_bitmaps_out tst_bitmaps_cmd.c \
>  		ext2_tdbtool mkjournal debug_cmds.c \
>  		../libext2fs.a ../libext2fs_p.a ../libext2fs_chk.a \
>  		crc32c_table.h gen_crc32ctable tst_crc32c
> diff --git a/lib/ext2fs/tst_bitmaps.c b/lib/ext2fs/tst_bitmaps.c
> new file mode 100644
> index 0000000..27722e5
> --- /dev/null
> +++ b/lib/ext2fs/tst_bitmaps.c
> @@ -0,0 +1,577 @@
> +/*
> + * tst_bitmaps.c
> + *
> + * Copyright (C) 2011 Theodore Ts'o.
> + *
> + * %Begin-Header%
> + * This file may be redistributed under the terms of the GNU Library
> + * General Public License, version 2.
> + * %End-Header%
> + */
> +
> +#include "config.h"
> +#include <unistd.h>
> +#include <stdlib.h>
> +#include <stdio.h>
> +#ifdef HAVE_GETOPT_H
> +#include <getopt.h>
> +#endif
> +#include <string.h>
> +#include <fcntl.h>
> +#include <time.h>
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +#include "ss/ss.h"
> +
> +#include "ext2_fs.h"
> +#include "ext2fs.h"
> +#include "ext2fsP.h"
> +
> +extern ss_request_table tst_bitmaps_cmds;
> +
> +static char subsystem_name[] = "tst_bitmaps";
> +static char version[] = "1.0";
> +
> +ext2_filsys	test_fs;
> +int		exit_status = 0;
> +
> +static int source_file(const char *cmd_file, int sci_idx)
> +{
> +	FILE		*f;
> +	char		buf[256];
> +	char		*cp;
> +	int		retval;
> +	int 		noecho;
> +
> +	if (strcmp(cmd_file, "-") == 0)
> +		f = stdin;
> +	else {
> +		f = fopen(cmd_file, "r");
> +		if (!f) {
> +			perror(cmd_file);
> +			exit(1);
> +		}
> +	}
> +	fflush(stdout);
> +	fflush(stderr);
> +	setbuf(stdout, NULL);
> +	setbuf(stderr, NULL);
> +	while (!feof(f)) {
> +		if (fgets(buf, sizeof(buf), f) == NULL)
> +			break;
> +		if (buf[0] == '#')
> +			continue;
> +		noecho = 0;
> +		if (buf[0] == '-') {
> +			noecho = 1;
> +			buf[0] = ' ';
> +		}
> +		cp = strchr(buf, '\n');
> +		if (cp)
> +			*cp = 0;
> +		cp = strchr(buf, '\r');
> +		if (cp)
> +			*cp = 0;

Since we are dealing with strings here I would rather use '\0' so it
make more obvious.

> +		if (!noecho)
> +			printf("%s: %s\n", subsystem_name, buf);
> +		retval = ss_execute_line(sci_idx, buf);
> +		if (retval) {
> +			ss_perror(sci_idx, retval, buf);
> +			exit_status++;
> +		}
> +	}
> +	return exit_status;
> +}
> +
> +
> +/*
> + * This function resets the libc getopt() function, which keeps
> + * internal state.  Bad design!  Stupid libc API designers!  No
> + * biscuit!
> + *
> + * BSD-derived getopt() functions require that optind be reset to 1 in
> + * order to reset getopt() state.  This used to be generally accepted
> + * way of resetting getopt().  However, glibc's getopt()
> + * has additional getopt() state beyond optind, and requires that
> + * optind be set zero to reset its state.  So the unfortunate state of
> + * affairs is that BSD-derived versions of getopt() misbehave if
> + * optind is set to 0 in order to reset getopt(), and glibc's getopt()
> + * will core dump if optind is set 1 in order to reset getopt().
> + *
> + * More modern versions of BSD require that optreset be set to 1 in
> + * order to reset getopt().   Sigh.  Standards, anyone?
> + *
> + * We hide the hair here.
> + */
> +void reset_getopt(void)
> +{
> +#if defined(__GLIBC__) || defined(__linux__)
> +	optind = 0;
> +#else
> +	optind = 1;
> +#endif
> +#ifdef HAVE_OPTRESET
> +	optreset = 1;		/* Makes BSD getopt happy */
> +#endif
> +}
> +
> +/*
> + * This function will convert a string to an unsigned long, printing
> + * an error message if it fails, and returning success or failure in err.
> + */
> +unsigned long parse_ulong(const char *str, const char *cmd,
> +			  const char *descr, int *err)
> +{
> +	char		*tmp;
> +	unsigned long	ret;
> +
> +	ret = strtoul(str, &tmp, 0);
> +	if (*tmp == 0) {
> +		if (err)
> +			*err = 0;
> +		return ret;
> +	}
> +	com_err(cmd, 0, "Bad %s - %s", descr, str);
> +	if (err)
> +		*err = 1;
> +	else
> +		exit(1);
> +	return 0;
> +}
> +
> +
> +int check_fs_open(char *name)
> +{
> +	if (!test_fs) {
> +		com_err(name, 0, "Filesystem not open");
> +		return 1;
> +	}
> +	return 0;
> +}
> +
> +static void setup_filesystem(const char *name,
> +			     unsigned int blocks, unsigned int inodes,
> +			     unsigned int type)
> +{
> +	struct ext2_super_block param;
> +	errcode_t retval;
> +
> +	memset(&param, 0, sizeof(param));
> +	ext2fs_blocks_count_set(&param, blocks);
> +	param.s_inodes_count = inodes;
> +
> +	retval = ext2fs_initialize("test fs", EXT2_FLAG_64BITS, &param,
> +				   test_io_manager, &test_fs);
> +
> +	if (retval) {
> +		com_err(name, retval, "while initializing filesystem");
> +		return;
> +	}
> +	test_fs->default_bitmap_type = type;
> +	ext2fs_free_block_bitmap(test_fs->block_map);
> +	test_fs->block_map = 0;
> +	ext2fs_free_inode_bitmap(test_fs->inode_map);
> +	test_fs->inode_map = 0;
> +	retval = ext2fs_allocate_block_bitmap(test_fs, "block bitmap",
> +					      &test_fs->block_map);
> +	if (retval) {
> +		com_err(name, retval, "while allocating block bitmap");
> +		goto errout;
> +	}
> +	retval = ext2fs_allocate_inode_bitmap(test_fs, "inode bitmap",
> +					      &test_fs->inode_map);
> +	if (retval) {
> +		com_err(name, retval, "while allocating inode bitmap");
> +		goto errout;
> +	}
> +	return;
> +
> +errout:
> +	ext2fs_close(test_fs);
> +	test_fs = 0;
> +}
> +
> +void setup_cmd(int argc, char **argv)
> +{
> +	errcode_t	retval;
> +	int		i, c, err;
> +	unsigned int	blocks = 128;
> +	unsigned int	inodes = 0;
> +	unsigned int	type = EXT2FS_BMAP64_BITARRAY;
> +
> +	if (test_fs) {
> +		ext2fs_close(test_fs);
> +		test_fs = 0;
> +	}
> +
> +	reset_getopt();
> +	while ((c = getopt(argc, argv, "b:i:t:")) != EOF) {
> +		switch (c) {
> +		case 'b':
> +			blocks = parse_ulong(optarg, argv[0],
> +					     "number of blocks", &err);
> +			if (err)
> +				return;
> +			break;
> +		case 'i':
> +			inodes = parse_ulong(optarg, argv[0],
> +					     "number of blocks", &err);
> +			if (err)
> +				return;
> +			break;
> +		case 't':
> +			type = parse_ulong(optarg, argv[0],
> +					   "bitmap backend type", &err);
> +			if (err)
> +				return;
> +			break;
> +		default:
> +			fprintf(stderr, "%s: usage: setup [-b blocks] "
> +				"[-i inodes] [-t type]\n", argv[0]);
> +			return;
> +		}
> +	}
> +	setup_filesystem(argv[0], blocks, inodes, type);
> +}
> +
> +void close_cmd(int argc, char **argv)
> +{
> +	if (check_fs_open(argv[0]))
> +		return;
> +
> +	ext2fs_close(test_fs);
> +	test_fs = 0;
> +}
> +
> +
> +void dump_bitmap(ext2fs_generic_bitmap bmap, unsigned int start, unsigned num)
> +{
> +	unsigned char	*buf;
> +	errcode_t	retval;
> +	int		i, len = (num - start + 7) / 8;
> +
> +	buf = malloc(len);
> +	if (!buf) {
> +		com_err("dump_bitmap", 0, "couldn't allocate buffer");
> +		return;
> +	}
> +	memset(buf, 0, len);
> +	retval = ext2fs_get_generic_bmap_range(bmap, (__u64) start, num, buf);
> +	if (retval) {
> +		com_err("dump_bitmap", retval, 
> +			"while calling ext2fs_generic_bmap_range");
> +		free(buf);
> +		return;
> +	}
> +	for (i=0; i < len; i++)
> +		printf("%02x", buf[i]);
> +	printf("\n");
> +	free(buf);
> +}
> +
> +void dump_inode_bitmap_cmd(int argc, char **argv)
> +{
> +	if (check_fs_open(argv[0]))
> +		return;
> +
> +	printf("inode bitmap: ");
> +	dump_bitmap(test_fs->inode_map, 1, test_fs->super->s_inodes_count);
> +}
> +	
> +void dump_block_bitmap_cmd(int argc, char **argv)
> +{
> +	if (check_fs_open(argv[0]))
> +		return;
> +
> +	printf("block bitmap: ");
> +	dump_bitmap(test_fs->block_map, test_fs->super->s_first_data_block,
> +		    test_fs->super->s_blocks_count);
> +}
> +	
> +void do_setb(int argc, char *argv[])
> +{
> +	unsigned int block, num;
> +	int err;
> +	int test_result, op_result;
> +
> +	if (check_fs_open(argv[0]))
> +		return;
> +
> +	if (argc != 2 && argc != 3) {
> +		com_err(argv[0], 0, "Usage: setb <block> [num]");
> +		return;
> +	}
> +
> +	block = parse_ulong(argv[1], argv[0], "block", &err);
> +	if (err)
> +		return;
> +
> +	if (argc == 3) {
> +		num = parse_ulong(argv[2], argv[0], "num", &err);
> +		if (err)
> +			return;
> +
> +		ext2fs_mark_block_bitmap_range2(test_fs->block_map,
> +						block, num);
> +		printf("Marking blocks %u to %u\n", block, block + num - 1);
> +		return;
> +	}
> +
> +	test_result = ext2fs_test_block_bitmap2(test_fs->block_map, block);
> +	op_result = ext2fs_mark_block_bitmap2(test_fs->block_map, block);
> +	printf("Setting block %u, was %s before\n", block, op_result ?
> +	       "set" : "clear");
> +	if (!test_result != !op_result)
> +		com_err(argv[0], 0, "*ERROR* test_result different! (%d, %d)",
> +			test_result, op_result);
> +}
> +
> +void do_clearb(int argc, char *argv[])
> +{
> +	unsigned int block, num;
> +	int err;
> +	int test_result, op_result;
> +
> +	if (check_fs_open(argv[0]))
> +		return;
> +
> +	if (argc != 2 && argc != 3) {
> +		com_err(argv[0], 0, "Usage: clearb <block> [num]");
> +		return;
> +	}
> +
> +	block = parse_ulong(argv[1], argv[0], "block", &err);
> +	if (err)
> +		return;
> +
> +	if (argc == 3) {
> +		num = parse_ulong(argv[2], argv[0], "num", &err);
> +		if (err)
> +			return;
> +
> +		ext2fs_unmark_block_bitmap_range2(test_fs->block_map,
> +						block, num);
> +		printf("Clearing blocks %u to %u\n", block, block + num - 1);
> +		return;
> +	}
> +
> +	test_result = ext2fs_test_block_bitmap2(test_fs->block_map, block);
> +	op_result = ext2fs_unmark_block_bitmap2(test_fs->block_map, block);
> +	printf("Clearing block %u, was %s before\n", block, op_result ?
> +	       "set" : "clear");
> +	if (!test_result != !op_result)
> +		com_err(argv[0], 0, "*ERROR* test_result different! (%d, %d)",
> +			test_result, op_result);
> +}
> +
> +void do_testb(int argc, char *argv[])
> +{
> +	unsigned int block, num;
> +	int err;
> +	int test_result, op_result;
> +
> +	if (check_fs_open(argv[0]))
> +		return;
> +
> +	if (argc != 2 && argc != 3) {
> +		com_err(argv[0], 0, "Usage: testb <block> [num]");
> +		return;
> +	}
> +
> +	block = parse_ulong(argv[1], argv[0], "block", &err);
> +	if (err)
> +		return;
> +
> +	if (argc == 3) {
> +		num = parse_ulong(argv[2], argv[0], "num", &err);
> +		if (err)
> +			return;
> +
> +		test_result =
> +			ext2fs_test_block_bitmap_range2(test_fs->block_map,
> +							block, num);
> +		printf("Blocks %u to %u are %sall clear.\n",
> +		       block, block + num - 1, test_result ? "" : "NOT ");
> +		return;
> +	}
> +
> +	test_result = ext2fs_test_block_bitmap2(test_fs->block_map, block);
> +	printf("Block %u is %s\n", block, test_result ? "set" : "clear");
> +}
> +
> +void do_zerob(int argc, char *argv[])
> +{
> +	if (check_fs_open(argv[0]))
> +		return;
> +
> +	printf("Clearing block bitmap.\n");
> +	ext2fs_clear_block_bitmap(test_fs->block_map);
> +}
> +
> +void do_seti(int argc, char *argv[])
> +{
> +	unsigned int inode;
> +	int err;
> +	int test_result, op_result;
> +
> +	if (check_fs_open(argv[0]))
> +		return;
> +
> +	if (argc != 2) {
> +		com_err(argv[0], 0, "Usage: seti <inode>");
> +		return;
> +	}
> +
> +	inode = parse_ulong(argv[1], argv[0], "inode", &err);
> +	if (err)
> +		return;
> +
> +	test_result = ext2fs_test_inode_bitmap2(test_fs->inode_map, inode);
> +	op_result = ext2fs_mark_inode_bitmap2(test_fs->inode_map, inode);
> +	printf("Setting inode %u, was %s before\n", inode, op_result ?
> +	       "set" : "clear");
> +	if (!test_result != !op_result) {
> +		com_err(argv[0], 0, "*ERROR* test_result different! (%d, %d)",
> +			test_result, op_result);
> +		exit_status++;
> +	}
> +}
> +
> +void do_cleari(int argc, char *argv[])
> +{
> +	unsigned int inode;
> +	int err;
> +	int test_result, op_result;
> +
> +	if (check_fs_open(argv[0]))
> +		return;
> +
> +	if (argc != 2) {
> +		com_err(argv[0], 0, "Usage: clearb <inode>");
> +		return;
> +	}
> +
> +	inode = parse_ulong(argv[1], argv[0], "inode", &err);
> +	if (err)
> +		return;
> +
> +	test_result = ext2fs_test_inode_bitmap2(test_fs->inode_map, inode);
> +	op_result = ext2fs_unmark_inode_bitmap2(test_fs->inode_map, inode);
> +	printf("Clearing inode %u, was %s before\n", inode, op_result ?
> +	       "set" : "clear");
> +	if (!test_result != !op_result) {
> +		com_err(argv[0], 0, "*ERROR* test_result different! (%d, %d)",
> +			test_result, op_result);
> +		exit_status++;
> +	}
> +}
> +
> +void do_testi(int argc, char *argv[])
> +{
> +	unsigned int inode;
> +	int err;
> +	int test_result, op_result;
> +
> +	if (check_fs_open(argv[0]))
> +		return;
> +
> +	if (argc != 2) {
> +		com_err(argv[0], 0, "Usage: testb <inode>");
> +		return;
> +	}
> +
> +	inode = parse_ulong(argv[1], argv[0], "inode", &err);
> +	if (err)
> +		return;
> +
> +	test_result = ext2fs_test_inode_bitmap2(test_fs->inode_map, inode);
> +	printf("Inode %u is %s\n", inode, test_result ? "set" : "clear");
> +}
> +
> +void do_zeroi(int argc, char *argv[])
> +{
> +	if (check_fs_open(argv[0]))
> +		return;
> +
> +	printf("Clearing inode bitmap.\n");
> +	ext2fs_clear_inode_bitmap(test_fs->inode_map);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	unsigned int	blocks = 128;
> +	unsigned int	inodes = 0;
> +	unsigned int	type = EXT2FS_BMAP64_BITARRAY;
> +	int		c, err, code;
> +	char		*request = (char *)NULL;
> +	char		*cmd_file = 0;
> +	int		sci_idx;
> +
> +	add_error_table(&et_ss_error_table);
> +	add_error_table(&et_ext2_error_table);
> +	while ((c = getopt (argc, argv, "b:i:t:R:f:")) != EOF) {
> +		switch (c) {
> +		case 'b':
> +			blocks = parse_ulong(optarg, argv[0],
> +					     "number of blocks", &err);
> +			if (err)
> +				return;
> +			break;
> +		case 'i':
> +			inodes = parse_ulong(optarg, argv[0],
> +					     "number of blocks", &err);
> +			if (err)
> +				return;
> +			break;
> +		case 't':
> +			type = parse_ulong(optarg, argv[0],
> +					   "bitmap backend type", &err);
> +			if (err)
> +				return;
> +			break;
> +		case 'R':
> +			request = optarg;
> +			break;
> +		case 'f':
> +			cmd_file = optarg;
> +			break;
> +		default:
> +			com_err(argv[0], 0, "Usage: %s [-R request] "
> +				"[-f cmd_file]", subsystem_name);

-b, -i and -t are missing in the Usage.

> +			exit(1);
> +		}
> +	}
> +
> +	sci_idx = ss_create_invocation(subsystem_name, version,
> +				       (char *)NULL, &tst_bitmaps_cmds, &code);
> +	if (code) {
> +		ss_perror(sci_idx, code, "creating invocation");
> +		exit(1);
> +	}
> +
> +	(void) ss_add_request_table (sci_idx, &ss_std_requests, 1, &code);
> +	if (code) {
> +		ss_perror(sci_idx, code, "adding standard requests");
> +		exit (1);
> +	}
> +
> +	printf("%s %s.  Type '?' for a list of commands.\n\n",
> +	       subsystem_name, version);
> +
> +	setup_filesystem(argv[0], blocks, inodes, type);
> +
> +	if (request) {
> +		code = ss_execute_line(sci_idx, request);
> +		if (code) {
> +			ss_perror(sci_idx, code, request);
> +			exit_status++;
> +		}
> +	} else if (cmd_file) {
> +		exit_status = source_file(cmd_file, sci_idx);
> +	} else {
> +		ss_listen(sci_idx);
> +	}
> +
> +	exit(exit_status);
> +}
> +
> diff --git a/lib/ext2fs/tst_bitmaps_cmd.ct b/lib/ext2fs/tst_bitmaps_cmd.ct
> new file mode 100644
> index 0000000..5a51d23
> --- /dev/null
> +++ b/lib/ext2fs/tst_bitmaps_cmd.ct
> @@ -0,0 +1,39 @@
> +command_table tst_bitmaps_cmds;
> +
> +request setup_cmd, "Setup file system",
> +	setup;
> +
> +request close_cmd, "Close file system",
> +	close;
> +
> +request dump_inode_bitmap_cmd, "Dump the inode bitmap",
> +	dump_inode_bitmap, dump_ib;
> +
> +request dump_block_bitmap_cmd, "Dump the block bitmap",
> +	dump_block_bitmap, dump_bb;
> +
> +request do_setb, "Set block",
> +	set_block, setb;
> +
> +request do_clearb, "Clear block",
> +	clear_block, clearb;
> +
> +request do_testb, "Test block",
> +	test_block, testb;
> +
> +request do_zerob, "Clear block bitmap",
> +	clear_block_bitmap, zerob;
> +
> +request do_seti, "Set inode",
> +	set_inode, seti;
> +
> +request do_cleari, "Clear inode",
> +	clear_inode, cleari;
> +
> +request do_testi, "Test inode",
> +	test_inode, testi;
> +
> +request do_zeroi, "Clear inode bitmap",
> +	clear_inode_bitmap, zeroi;
> +
> +end;
> diff --git a/lib/ext2fs/tst_bitmaps_cmds b/lib/ext2fs/tst_bitmaps_cmds
> new file mode 100644
> index 0000000..13f4ea8
> --- /dev/null
> +++ b/lib/ext2fs/tst_bitmaps_cmds
> @@ -0,0 +1,46 @@
> +setb 12
> +setb 12
> +clearb 12
> +clearb 12
> +setb 12
> +setb 14
> +setb 16
> +testb 13
> +testb 15
> +testb 12
> +testb 14
> +setb 13
> +setb 15
> +testb 12
> +testb 11
> +testb 15
> +testb 16
> +dump_bb
> +clearb 12 7
> +testb 12 7
> +setb 15
> +testb 12 7
> +clearb 15
> +testb 12 7
> +setb 12 7
> +dump_bb
> +seti 2
> +seti 5
> +seti 4
> +seti 3
> +seti 4
> +seti 5
> +testi 6
> +testi 1
> +dump_ib
> +zeroi
> +testi 5
> +seti 5
> +seti 5
> +cleari 5
> +cleari 5
> +testi 17
> +testi 6
> +testi 4
> +quit
> +
> diff --git a/lib/ext2fs/tst_bitmaps_exp b/lib/ext2fs/tst_bitmaps_exp
> new file mode 100644
> index 0000000..aa64ae7
> --- /dev/null
> +++ b/lib/ext2fs/tst_bitmaps_exp
> @@ -0,0 +1,92 @@
> +tst_bitmaps 1.0.  Type '?' for a list of commands.
> +
> +tst_bitmaps: setb 12
> +Setting block 12, was clear before
> +tst_bitmaps: setb 12
> +Setting block 12, was set before
> +tst_bitmaps: clearb 12
> +Clearing block 12, was set before
> +tst_bitmaps: clearb 12
> +Clearing block 12, was clear before
> +tst_bitmaps: setb 12
> +Setting block 12, was clear before
> +tst_bitmaps: setb 14
> +Setting block 14, was clear before
> +tst_bitmaps: setb 16
> +Setting block 16, was clear before
> +tst_bitmaps: testb 13
> +Block 13 is clear
> +tst_bitmaps: testb 15
> +Block 15 is clear
> +tst_bitmaps: testb 12
> +Block 12 is set
> +tst_bitmaps: testb 14
> +Block 14 is set
> +tst_bitmaps: setb 13
> +Setting block 13, was clear before
> +tst_bitmaps: setb 15
> +Setting block 15, was clear before
> +tst_bitmaps: testb 12
> +Block 12 is set
> +tst_bitmaps: testb 11
> +Block 11 is clear
> +tst_bitmaps: testb 15
> +Block 15 is set
> +tst_bitmaps: testb 16
> +Block 16 is set
> +tst_bitmaps: dump_bb
> +block bitmap: 00f80000000000000000000000000000
> +tst_bitmaps: clearb 12 7
> +Clearing blocks 12 to 18
> +tst_bitmaps: testb 12 7
> +Blocks 12 to 18 are all clear.
> +tst_bitmaps: setb 15
> +Setting block 15, was clear before
> +tst_bitmaps: testb 12 7
> +Blocks 12 to 18 are NOT all clear.
> +tst_bitmaps: clearb 15
> +Clearing block 15, was set before
> +tst_bitmaps: testb 12 7
> +Blocks 12 to 18 are all clear.
> +tst_bitmaps: setb 12 7
> +Marking blocks 12 to 18
> +tst_bitmaps: dump_bb
> +block bitmap: 00f80300000000000000000000000000
> +tst_bitmaps: seti 2
> +Setting inode 2, was clear before
> +tst_bitmaps: seti 5
> +Setting inode 5, was clear before
> +tst_bitmaps: seti 4
> +Setting inode 4, was clear before
> +tst_bitmaps: seti 3
> +Setting inode 3, was clear before
> +tst_bitmaps: seti 4
> +Setting inode 4, was set before
> +tst_bitmaps: seti 5
> +Setting inode 5, was set before
> +tst_bitmaps: testi 6
> +Inode 6 is clear
> +tst_bitmaps: testi 1
> +Inode 1 is clear
> +tst_bitmaps: dump_ib
> +inode bitmap: 1e000000
> +tst_bitmaps: zeroi
> +Clearing inode bitmap.
> +tst_bitmaps: testi 5
> +Inode 5 is clear
> +tst_bitmaps: seti 5
> +Setting inode 5, was clear before
> +tst_bitmaps: seti 5
> +Setting inode 5, was set before
> +tst_bitmaps: cleari 5
> +Clearing inode 5, was set before
> +tst_bitmaps: cleari 5
> +Clearing inode 5, was clear before
> +tst_bitmaps: testi 17
> +Inode 17 is clear
> +tst_bitmaps: testi 6
> +Inode 6 is clear
> +tst_bitmaps: testi 4
> +Inode 4 is clear
> +tst_bitmaps: quit
> +tst_bitmaps: 
> 

-- 
