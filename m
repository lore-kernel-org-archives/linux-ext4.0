From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] e2fsprogs: introduce ext2fs_close_free() helper
Date: Thu, 20 Feb 2014 11:39:24 -0800
Message-ID: <20140220193924.GL9176@birch.djwong.org>
References: <1392908549-32318-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32360 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaBTTje (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Feb 2014 14:39:34 -0500
Content-Disposition: inline
In-Reply-To: <1392908549-32318-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 20, 2014 at 04:02:29PM +0100, Lukas Czerner wrote:
> Currently there are many uses of ext2fs_close() which might be wrong.
> First of all ext2fs_close() does not set the ext2_filsys pointer to NULL
> so the caller is responsible for clearing it, however there are some
> cases there we do not do it.
> 
> Second of all very small number of users of ext2fs_close() actually
> check the return value. If there is a problem in ext2fs_close() it will
> not even free the ext2_filsys structure, but majority of users expect it
> to do so.
> 
> To fix both problems this commit introduces a new helper
> ext2fs_close_free() which will not only check for the return value and
> free the ext2_filsys structure if the call to ext2fs_close2() failed,
> but it will also set the ext2_filsys pointer to NULL.
> 
> Replace every use of ext2fs_close() in e2fsprogs tools with
> ext2fs_close_free() - there is no real reason to keep using
> ext2fs_close().

I think I like this. :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  debugfs/debugfs.c        |  6 ++----
>  e2fsck/scantest.c        |  2 +-
>  e2fsck/unix.c            | 20 ++++++++------------
>  e2fsck/util.c            |  2 +-
>  lib/ext2fs/closefs.c     | 12 ++++++++++++
>  lib/ext2fs/ext2fs.h      |  1 +
>  lib/ext2fs/mkjournal.c   |  2 +-
>  lib/ext2fs/tst_bitmaps.c | 12 ++++--------
>  misc/dumpe2fs.c          |  6 +++---
>  misc/e2freefrag.c        |  2 +-
>  misc/e2image.c           |  4 ++--
>  misc/e4defrag.c          |  2 +-
>  misc/mke2fs.c            |  8 ++++----
>  misc/tune2fs.c           |  6 +++---
>  resize/main.c            |  2 +-
>  resize/resize2fs.c       |  2 +-
>  16 files changed, 46 insertions(+), 43 deletions(-)
> 
> diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
> index d8d6d76..7db6bda 100644
> --- a/debugfs/debugfs.c
> +++ b/debugfs/debugfs.c
> @@ -131,10 +131,9 @@ static void open_filesystem(char *device, int open_flags, blk64_t superblock,
>  	return;
>  
>  errout:
> -	retval = ext2fs_close(current_fs);
> +	retval = ext2fs_close_free(&current_fs);
>  	if (retval)
>  		com_err(device, retval, "while trying to close filesystem");
> -	current_fs = NULL;
>  }
>  
>  void do_open_filesys(int argc, char **argv)
> @@ -238,10 +237,9 @@ static void close_filesystem(NOARGS)
>  		if (retval)
>  			com_err("ext2fs_write_block_bitmap", retval, 0);
>  	}
> -	retval = ext2fs_close(current_fs);
> +	retval = ext2fs_close_free(&current_fs);
>  	if (retval)
>  		com_err("ext2fs_close", retval, 0);
> -	current_fs = NULL;
>  	return;
>  }
>  
> diff --git a/e2fsck/scantest.c b/e2fsck/scantest.c
> index 16380b3..6131141 100644
> --- a/e2fsck/scantest.c
> +++ b/e2fsck/scantest.c
> @@ -133,7 +133,7 @@ int main (int argc, char *argv[])
>  	}
>  
>  
> -	ext2fs_close(fs);
> +	ext2fs_close_free(&fs);
>  
>  	print_resource_track(&global_rtrack);
>  
> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> index 429f1cd..593106b 100644
> --- a/e2fsck/unix.c
> +++ b/e2fsck/unix.c
> @@ -451,8 +451,7 @@ static void check_if_skip(e2fsck_t ctx)
>  	}
>  	log_out(ctx, "\n");
>  skip:
> -	ext2fs_close(fs);
> -	ctx->fs = NULL;
> +	ext2fs_close_free(&fs);
>  	e2fsck_free_context(ctx);
>  	exit(FSCK_OK);
>  }
> @@ -1304,12 +1303,12 @@ restart:
>  			orig_superblock = ctx->superblock;
>  			get_backup_sb(ctx, fs, ctx->filesystem_name, io_ptr);
>  			if (fs)
> -				ext2fs_close(fs);
> +				ext2fs_close_free(&fs);
>  			orig_retval = retval;
>  			retval = try_open_fs(ctx, flags, io_ptr, &fs);
>  			if ((orig_retval == 0) && retval != 0) {
>  				if (fs)
> -					ext2fs_close(fs);
> +					ext2fs_close_free(&fs);
>  				log_out(ctx, _("%s: %s while using the "
>  					       "backup blocks"),
>  					ctx->program_name,
> @@ -1403,7 +1402,7 @@ failure:
>  		 * reopen the filesystem after we get the device size.
>  		 */
>  		if (pctx.errcode == EBUSY) {
> -			ext2fs_close(fs);
> +			ext2fs_close_free(&fs);
>  			need_restart++;
>  			pctx.errcode =
>  				ext2fs_get_device_size2(ctx->filesystem_name,
> @@ -1460,8 +1459,7 @@ failure:
>  		/*
>  		 * Restart in order to reopen fs but this time start mmp.
>  		 */
> -		ext2fs_close(fs);
> -		ctx->fs = NULL;
> +		ext2fs_close_free(&fs);
>  		flags &= ~EXT2_FLAG_SKIP_MMP;
>  		goto restart;
>  	}
> @@ -1511,8 +1509,7 @@ failure:
>  					ctx->device_name);
>  				fatal_error(ctx, 0);
>  			}
> -			ext2fs_close(ctx->fs);
> -			ctx->fs = 0;
> +			ext2fs_close_free(&ctx->fs);
>  			ctx->flags |= E2F_FLAG_RESTARTED;
>  			goto restart;
>  		}
> @@ -1691,7 +1688,7 @@ no_journal:
>  				_("while resetting context"));
>  			fatal_error(ctx, 0);
>  		}
> -		ext2fs_close(fs);
> +		ext2fs_close_free(&fs);
>  		goto restart;
>  	}
>  	if (run_result & E2F_FLAG_CANCEL) {
> @@ -1773,8 +1770,7 @@ no_journal:
>  	io_channel_flush(ctx->fs->io);
>  	print_resource_track(ctx, NULL, &ctx->global_rtrack, ctx->fs->io);
>  
> -	ext2fs_close(fs);
> -	ctx->fs = NULL;
> +	ext2fs_close_free(&fs);
>  	free(ctx->journal_name);
>  
>  	e2fsck_free_context(ctx);
> diff --git a/e2fsck/util.c b/e2fsck/util.c
> index e7e8704..784577f 100644
> --- a/e2fsck/util.c
> +++ b/e2fsck/util.c
> @@ -321,7 +321,7 @@ void preenhalt(e2fsck_t ctx)
>  	if (fs != NULL) {
>  		fs->super->s_state |= EXT2_ERROR_FS;
>  		ext2fs_mark_super_dirty(fs);
> -		ext2fs_close(fs);
> +		ext2fs_close_free(&fs);
>  	}
>  	exit(FSCK_UNCORRECTED);
>  }
> diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
> index c2eaec1..e7ec0ae 100644
> --- a/lib/ext2fs/closefs.c
> +++ b/lib/ext2fs/closefs.c
> @@ -450,6 +450,18 @@ errout:
>  	return retval;
>  }
>  
> +errcode_t ext2fs_close_free(ext2_filsys *fs_ptr)
> +{
> +	errcode_t ret;
> +	ext2_filsys fs = *fs_ptr;
> +
> +	ret = ext2fs_close2(fs, 0);
> +	if (ret)
> +		ext2fs_free(fs);
> +	*fs_ptr = NULL;
> +	return ret;
> +}
> +
>  errcode_t ext2fs_close(ext2_filsys fs)
>  {
>  	return ext2fs_close2(fs, 0);
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 7f7fd1f..253244d 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -945,6 +945,7 @@ extern errcode_t ext2fs_check_desc(ext2_filsys fs);
>  /* closefs.c */
>  extern errcode_t ext2fs_close(ext2_filsys fs);
>  extern errcode_t ext2fs_close2(ext2_filsys fs, int flags);
> +extern errcode_t ext2fs_close_free(ext2_filsys *fs);
>  extern errcode_t ext2fs_flush(ext2_filsys fs);
>  extern errcode_t ext2fs_flush2(ext2_filsys fs, int flags);
>  extern int ext2fs_bg_has_super(ext2_filsys fs, dgrp_t group_block);
> diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
> index 884d9c0..2331e9e 100644
> --- a/lib/ext2fs/mkjournal.c
> +++ b/lib/ext2fs/mkjournal.c
> @@ -642,7 +642,7 @@ main(int argc, char **argv)
>  	if (retval) {
>  		printf("Warning, had trouble writing out superblocks.\n");
>  	}
> -	ext2fs_close(fs);
> +	ext2fs_close_free(&fs);
>  	exit(0);
>  
>  }
> diff --git a/lib/ext2fs/tst_bitmaps.c b/lib/ext2fs/tst_bitmaps.c
> index 4e02ade..574fb7a 100644
> --- a/lib/ext2fs/tst_bitmaps.c
> +++ b/lib/ext2fs/tst_bitmaps.c
> @@ -187,8 +187,7 @@ static void setup_filesystem(const char *name,
>  	return;
>  
>  errout:
> -	ext2fs_close(test_fs);
> -	test_fs = 0;
> +	ext2fs_close_free(&test_fs);
>  }
>  
>  void setup_cmd(int argc, char **argv)
> @@ -199,10 +198,8 @@ void setup_cmd(int argc, char **argv)
>  	unsigned int	type = EXT2FS_BMAP64_BITARRAY;
>  	int		flags = EXT2_FLAG_64BITS;
>  
> -	if (test_fs) {
> -		ext2fs_close(test_fs);
> -		test_fs = 0;
> -	}
> +	if (test_fs)
> +		ext2fs_close_free(&test_fs);
>  
>  	reset_getopt();
>  	while ((c = getopt(argc, argv, "b:i:lt:")) != EOF) {
> @@ -242,8 +239,7 @@ void close_cmd(int argc, char **argv)
>  	if (check_fs_open(argv[0]))
>  		return;
>  
> -	ext2fs_close(test_fs);
> -	test_fs = 0;
> +	ext2fs_close_free(&test_fs);
>  }
>  
>  
> diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
> index ae54f8a..f2f62bf 100644
> --- a/misc/dumpe2fs.c
> +++ b/misc/dumpe2fs.c
> @@ -651,7 +651,7 @@ int main (int argc, char ** argv)
>  		if (fs->super->s_feature_incompat &
>  		      EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) {
>  			print_journal_information(fs);
> -			ext2fs_close(fs);
> +			ext2fs_close_free(&fs);
>  			exit(0);
>  		}
>  		if ((fs->super->s_feature_compat &
> @@ -660,7 +660,7 @@ int main (int argc, char ** argv)
>  			print_inline_journal_information(fs);
>  		list_bad_blocks(fs, 0);
>  		if (header_only) {
> -			ext2fs_close (fs);
> +			ext2fs_close_free(&fs);
>  			exit (0);
>  		}
>  		retval = ext2fs_read_bitmaps (fs);
> @@ -671,7 +671,7 @@ int main (int argc, char ** argv)
>  			       error_message(retval));
>  		}
>  	}
> -	ext2fs_close (fs);
> +	ext2fs_close_free(&fs);
>  	remove_error_table(&et_ext2_error_table);
>  	exit (0);
>  }
> diff --git a/misc/e2freefrag.c b/misc/e2freefrag.c
> index 612ca44..bb72c70 100644
> --- a/misc/e2freefrag.c
> +++ b/misc/e2freefrag.c
> @@ -215,7 +215,7 @@ static errcode_t get_chunk_info(ext2_filsys fs, struct chunk_info *info,
>  
>  static void close_device(char *device_name, ext2_filsys fs)
>  {
> -	int retval = ext2fs_close(fs);
> +	int retval = ext2fs_close_free(&fs);
>  
>  	if (retval)
>  		com_err(device_name, retval, "while closing the filesystem.\n");
> diff --git a/misc/e2image.c b/misc/e2image.c
> index b768826..f8457ab 100644
> --- a/misc/e2image.c
> +++ b/misc/e2image.c
> @@ -1415,7 +1415,7 @@ static void install_image(char *device, char *image_fn, int type)
>  	}
>  
>  	close(fd);
> -	ext2fs_close (fs);
> +	ext2fs_close_free(&fs);
>  }
>  
>  static struct ext2_qcow2_hdr *check_qcow2_image(int *fd, char *name)
> @@ -1648,7 +1648,7 @@ skip_device:
>  	else
>  		write_image_file(fs, fd);
>  
> -	ext2fs_close (fs);
> +	ext2fs_close_free(&fs);
>  	if (check)
>  		printf(_("%d blocks already contained the data to be copied.\n"),
>  		       skipped_blocks);
> diff --git a/misc/e4defrag.c b/misc/e4defrag.c
> index c2695e8..89bdfb9 100644
> --- a/misc/e4defrag.c
> +++ b/misc/e4defrag.c
> @@ -1852,7 +1852,7 @@ int main(int argc, char *argv[])
>  			feature_incompat = fs->super->s_feature_incompat;
>  			log_groups_per_flex = fs->super->s_log_groups_per_flex;
>  
> -			ext2fs_close(fs);
> +			ext2fs_close_free(&fs);
>  		}
>  
>  		switch (arg_type) {
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index facbe4c..90c214e 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1774,7 +1774,7 @@ profile_error:
>  		printf(_("Using journal device's blocksize: %d\n"), blocksize);
>  		fs_param.s_log_block_size =
>  			int_log2(blocksize >> EXT2_MIN_BLOCK_LOG_SIZE);
> -		ext2fs_close(jfs);
> +		ext2fs_close_free(&jfs);
>  	}
>  
>  	if (optind < argc) {
> @@ -2789,7 +2789,7 @@ int main (int argc, char *argv[])
>  	if (fs->super->s_feature_incompat &
>  	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) {
>  		create_journal_dev(fs);
> -		exit(ext2fs_close(fs) ? 1 : 0);
> +		exit(ext2fs_close_free(&fs) ? 1 : 0);
>  	}
>  
>  	if (bad_blocks_filename)
> @@ -2909,7 +2909,7 @@ int main (int argc, char *argv[])
>  		}
>  		if (!quiet)
>  			printf("%s", _("done\n"));
> -		ext2fs_close(jfs);
> +		ext2fs_close_free(&jfs);
>  		free(journal_device);
>  	} else if ((journal_size) ||
>  		   (fs_param.s_feature_compat &
> @@ -2973,7 +2973,7 @@ no_journal:
>  		       "filesystem accounting information: "));
>  	checkinterval = fs->super->s_checkinterval;
>  	max_mnt_count = fs->super->s_max_mnt_count;
> -	retval = ext2fs_close(fs);
> +	retval = ext2fs_close_free(&fs);
>  	if (retval) {
>  		fprintf(stderr, "%s",
>  			_("\nWarning, had trouble writing out superblocks."));
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index 8ff47d2..c651d55 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -1205,7 +1205,7 @@ static int add_journal(ext2_filsys fs)
>  		fflush(stdout);
>  
>  		retval = ext2fs_add_journal_device(fs, jfs);
> -		ext2fs_close(jfs);
> +		ext2fs_close_free(&jfs);
>  		if (retval) {
>  			com_err(program_name, retval,
>  				_("while adding filesystem to journal on %s"),
> @@ -2512,7 +2512,7 @@ retry_open:
>  			goto closefs;
>  		}
>  		if (io_ptr != io_ptr_orig) {
> -			ext2fs_close(fs);
> +			ext2fs_close_free(&fs);
>  			goto retry_open;
>  		}
>  	}
> @@ -2805,5 +2805,5 @@ closefs:
>  		exit(1);
>  	}
>  
> -	return (ext2fs_close(fs) ? 1 : 0);
> +	return (ext2fs_close_free(&fs) ? 1 : 0);
>  }
> diff --git a/resize/main.c b/resize/main.c
> index 2b7abff..c575220 100644
> --- a/resize/main.c
> +++ b/resize/main.c
> @@ -468,7 +468,7 @@ int main (int argc, char ** argv)
>  			_("Please run 'e2fsck -fy %s' to fix the filesystem\n"
>  			  "after the aborted resize operation.\n"),
>  			device_name);
> -		ext2fs_close(fs);
> +		ext2fs_close_free(&fs);
>  		exit(1);
>  	}
>  	printf(_("The filesystem on %s is now %llu blocks long.\n\n"),
> diff --git a/resize/resize2fs.c b/resize/resize2fs.c
> index 8353338..9a51733 100644
> --- a/resize/resize2fs.c
> +++ b/resize/resize2fs.c
> @@ -202,7 +202,7 @@ errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
>  	rfs->new_fs->flags &= ~EXT2_FLAG_MASTER_SB_ONLY;
>  
>  	print_resource_track(rfs, &overall_track, fs->io);
> -	retval = ext2fs_close(rfs->new_fs);
> +	retval = ext2fs_close_free(&rfs->new_fs);
>  	if (retval)
>  		goto errout;
>  
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
