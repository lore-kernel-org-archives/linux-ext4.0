From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] fuse2fs: improve command-line parsing
Date: Tue, 15 Mar 2016 11:42:25 -0700
Message-ID: <20160315184225.GB5826@birch.djwong.org>
References: <1457766876-23519-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43927 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbcCOSmc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Mar 2016 14:42:32 -0400
Content-Disposition: inline
In-Reply-To: <1457766876-23519-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 12, 2016 at 02:14:36AM -0500, Theodore Ts'o wrote:
> Use libfuse's command line parsing, which is much more powerful and
> flexible than what we had before, and to allow the user to have more
> fine-grained control over FUSE's run-time options.

Looks reasonable enough to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  misc/fuse2fs.c | 185 +++++++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 120 insertions(+), 65 deletions(-)
> 
> diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
> index 1cbdcb7..4412fe3 100644
> --- a/misc/fuse2fs.c
> +++ b/misc/fuse2fs.c
> @@ -36,6 +36,8 @@
>  #include "ext2fs/ext2fs.h"
>  #include "ext2fs/ext2_fs.h"
>  
> +#include "../version.h"
> +
>  #ifdef ENABLE_NLS
>  #include <libintl.h>
>  #include <locale.h>
> @@ -303,6 +305,10 @@ struct fuse2fs {
>  	unsigned long magic;
>  	ext2_filsys fs;
>  	pthread_mutex_t bfl;
> +	char *device;
> +	int ro;
> +	int debug;
> +	int no_default_opts;
>  	int panic_on_error;
>  	int minixdf;
>  	int alloc_all_blocks;
> @@ -3624,49 +3630,100 @@ static int get_random_bytes(void *p, size_t sz)
>  	return (size_t) r == sz;
>  }
>  
> -static void print_help(const char *progname)
> +enum {
> +	FUSE2FS_VERSION,
> +	FUSE2FS_HELP,
> +	FUSE2FS_HELPFULL,
> +};
> +
> +#define FUSE2FS_OPT(t, p, v) { t, offsetof(struct fuse2fs, p), v }
> +
> +static struct fuse_opt fuse2fs_opts[] = {
> +	FUSE2FS_OPT("ro",		ro,			1),
> +	FUSE2FS_OPT("errors=panic",	panic_on_error,		1),
> +	FUSE2FS_OPT("minixdf",		minixdf,		1),
> +	FUSE2FS_OPT("fuse2fs_debug",	debug,			1),
> +	FUSE2FS_OPT("no_default_opts",	no_default_opts,	1),
> +
> +	FUSE_OPT_KEY("-V",             FUSE2FS_VERSION),
> +	FUSE_OPT_KEY("--version",      FUSE2FS_VERSION),
> +	FUSE_OPT_KEY("-h",             FUSE2FS_HELP),
> +	FUSE_OPT_KEY("--help",         FUSE2FS_HELP),
> +	FUSE_OPT_KEY("--helpfull",     FUSE2FS_HELPFULL),
> +	FUSE_OPT_END
> +};
> +
> +
> +static int fuse2fs_opt_proc(void *data, const char *arg,
> +			    int key, struct fuse_args *outargs)
>  {
> -	printf(_("Usage: %s dev mntpt [-o options] [fuse_args]\n"), progname);
> +	struct fuse2fs *ff = data;
> +
> +	switch (key) {
> +	case FUSE_OPT_KEY_NONOPT:
> +		if (!ff->device) {
> +			ff->device = strdup(arg);
> +			return 0;
> +		}
> +		return 1;
> +	case FUSE2FS_HELP:
> +	case FUSE2FS_HELPFULL:
> +		fprintf(stderr,
> +	"usage: %s device/image mountpoint [options]\n"
> +	"\n"
> +	"general options:\n"
> +	"    -o opt,[opt...]  mount options\n"
> +	"    -h   --help      print help\n"
> +	"    -V   --version   print version\n"
> +	"\n"
> +	"fuse2fs options:\n"
> +	"    -o ro                  read-only mount\n"
> +	"    -o errors=panic        dump core on error\n"
> +	"    -o minixdf             minix-style df\n"
> +	"    -o no_default_opts     do not include default fuse options\n"
> +	"    -o fuse2fs_debug       enable fuse2fs debugging\n"
> +	"\n",
> +			outargs->argv[0]);
> +		if (key == FUSE2FS_HELPFULL) {
> +			fuse_opt_add_arg(outargs, "-ho");
> +			fuse_main(outargs->argc, outargs->argv, &fs_ops, NULL);
> +		} else {
> +			fprintf(stderr, "Try --helpfull to get a list of "
> +				"all flags, including the FUSE options.\n");
> +		}
> +		exit(1);
> +
> +	case FUSE2FS_VERSION:
> +		fprintf(stderr, "fuse2fs %s (%s)\n", E2FSPROGS_VERSION,
> +			E2FSPROGS_DATE);
> +		fuse_opt_add_arg(outargs, "--version");
> +		fuse_main(outargs->argc, outargs->argv, &fs_ops, NULL);
> +		exit(0);
> +	}
> +	return 1;
>  }
>  
>  int main(int argc, char *argv[])
>  {
> +	struct fuse_args args = FUSE_ARGS_INIT(argc, argv);
> +	struct fuse2fs fctx;
>  	errcode_t err;
>  	char *tok, *arg, *logfile;
>  	int i;
> -	int readwrite = 1, panic_on_error = 0, minixdf = 0;
> -	struct fuse2fs *ff;
>  	char extra_args[BUFSIZ];
>  	int ret = 0, flags = EXT2_FLAG_64BITS | EXT2_FLAG_EXCLUSIVE;
>  
> -	if (argc < 2) {
> -		print_help(argv[0]);
> -		return 1;
> -	}
> +	memset(&fctx, 0, sizeof(fctx));
> +	fctx.magic = FUSE2FS_MAGIC;
>  
> -	for (i = 1; i < argc; i++) {
> -		if (strcmp(argv[i], "--help") == 0) {
> -			print_help(argv[0]);
> -			return 1;
> -		}
> -	}
> -
> -	for (i = 1; i < argc - 1; i++) {
> -		if (strcmp(argv[i], "-o"))
> -			continue;
> -		arg = argv[i + 1];
> -		while ((tok = strtok(arg, ","))) {
> -			arg = NULL;
> -			if (!strcmp(tok, "ro"))
> -				readwrite = 0;
> -			else if (!strcmp(tok, "errors=panic"))
> -				panic_on_error = 1;
> -			else if (!strcmp(tok, "minixdf"))
> -				minixdf = 1;
> -		}
> +	fuse_opt_parse(&args, &fctx, fuse2fs_opts, fuse2fs_opt_proc);
> +	if (fctx.device == NULL) {
> +		fprintf(stderr, "Missing ext4 device/image\n");
> +		fprintf(stderr, "See '%s -h' for usage\n", argv[0]);
> +		exit(1);
>  	}
>  
> -	if (!readwrite)
> +	if (fctx.ro)
>  		printf("%s", _("Mounting read-only.\n"));
>  
>  #ifdef ENABLE_NLS
> @@ -3678,57 +3735,48 @@ int main(int argc, char *argv[])
>  #endif
>  	add_error_table(&et_ext2_error_table);
>  
> -	ff = calloc(1, sizeof(*ff));
> -	if (!ff) {
> -		perror("init");
> -		return 1;
> -	}
> -	ff->magic = FUSE2FS_MAGIC;
> -	ff->panic_on_error = panic_on_error;
> -	ff->minixdf = minixdf;
> -
>  	/* Set up error logging */
>  	logfile = getenv("FUSE2FS_LOGFILE");
>  	if (logfile) {
> -		ff->err_fp = fopen(logfile, "a");
> -		if (!ff->err_fp) {
> +		fctx.err_fp = fopen(logfile, "a");
> +		if (!fctx.err_fp) {
>  			perror(logfile);
>  			goto out_nofs;
>  		}
>  	} else
> -		ff->err_fp = stderr;
> +		fctx.err_fp = stderr;
>  
>  	/* Will we allow users to allocate every last block? */
>  	if (getenv("FUSE2FS_ALLOC_ALL_BLOCKS")) {
>  		printf(_("%s: Allowing users to allocate all blocks. "
> -		       "This is dangerous!\n"), argv[1]);
> -		ff->alloc_all_blocks = 1;
> +		       "This is dangerous!\n"), fctx.device);
> +		fctx.alloc_all_blocks = 1;
>  	}
>  
>  	/* Start up the fs (while we still can use stdout) */
>  	ret = 2;
> -	if (readwrite)
> +	if (!fctx.ro)
>  		flags |= EXT2_FLAG_RW;
> -	err = ext2fs_open2(argv[1], NULL, flags, 0, 0, unix_io_manager,
> +	err = ext2fs_open2(fctx.device, NULL, flags, 0, 0, unix_io_manager,
>  			   &global_fs);
>  	if (err) {
> -		printf(_("%s: %s.\n"), argv[1], error_message(err));
> -		printf(_("Please run e2fsck -fy %s.\n"), argv[1]);
> +		printf(_("%s: %s.\n"), fctx.device, error_message(err));
> +		printf(_("Please run e2fsck -fy %s.\n"), fctx.device);
>  		goto out_nofs;
>  	}
> -	ff->fs = global_fs;
> -	global_fs->priv_data = ff;
> +	fctx.fs = global_fs;
> +	global_fs->priv_data = &fctx;
>  
>  	ret = 3;
>  	if (ext2fs_has_feature_journal_needs_recovery(global_fs->super)) {
> -		if (readwrite) {
> -			printf(_("%s: recovering journal\n"), argv[1]);
> +		if (!fctx.ro) {
> +			printf(_("%s: recovering journal\n"), fctx.device);
>  			err = ext2fs_run_ext3_journal(&global_fs);
>  			if (err) {
> -				printf(_("%s: %s.\n"), argv[1],
> +				printf(_("%s: %s.\n"), fctx.device,
>  				       error_message(err));
>  				printf(_("Please run e2fsck -fy %s.\n"),
> -				       argv[1]);
> +				       fctx.device);
>  				goto out;
>  			}
>  			ext2fs_clear_feature_journal_needs_recovery(global_fs->super);
> @@ -3740,10 +3788,10 @@ int main(int argc, char *argv[])
>  		}
>  	}
>  
> -	if (readwrite) {
> +	if (!fctx.ro) {
>  		if (ext2fs_has_feature_journal(global_fs->super))
>  			printf(_("%s: Writing to the journal is not supported.\n"),
> -			       argv[1]);
> +			       fctx.device);
>  		err = ext2fs_read_inode_bitmap(global_fs);
>  		if (err) {
>  			translate_error(global_fs, 0, err);
> @@ -3779,19 +3827,27 @@ int main(int argc, char *argv[])
>  	}
>  
>  	/* Initialize generation counter */
> -	get_random_bytes(&ff->next_generation, sizeof(unsigned int));
> +	get_random_bytes(&fctx.next_generation, sizeof(unsigned int));
>  
> -	/* Stuff in some fuse parameters of our own */
> +	/* Set up default fuse parameters */
>  	snprintf(extra_args, BUFSIZ, "-okernel_cache,subtype=ext4,use_ino,"
> -		 "fsname=%s,attr_timeout=0,allow_other" FUSE_PLATFORM_OPTS,
> +		 "fsname=%s,attr_timeout=0" FUSE_PLATFORM_OPTS,
>  		 argv[1]);
> -	argv[0] = argv[1];
> -	argv[1] = argv[2];
> -	argv[2] = extra_args;
> +	if (fctx.no_default_opts == 0)
> +		fuse_opt_add_arg(&args, extra_args);
> +
> +	if (fctx.debug) {
> +		int	i;
> +
> +		printf("fuse arguments:");
> +		for (i = 0; i < args.argc; i++)
> +			printf(" '%s'", args.argv[i]);
> +		printf("\n");
> +	}
>  
> -	pthread_mutex_init(&ff->bfl, NULL);
> -	fuse_main(argc, argv, &fs_ops, ff);
> -	pthread_mutex_destroy(&ff->bfl);
> +	pthread_mutex_init(&fctx.bfl, NULL);
> +	fuse_main(args.argc, args.argv, &fs_ops, &fctx);
> +	pthread_mutex_destroy(&fctx.bfl);
>  
>  	ret = 0;
>  out:
> @@ -3800,7 +3856,6 @@ out:
>  		com_err(argv[0], err, "while closing fs");
>  	global_fs = NULL;
>  out_nofs:
> -	free(ff);
>  
>  	return ret;
>  }
> -- 
> 2.5.0
> 
