From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 02/37] misc: coverity fixes
Date: Fri, 2 May 2014 13:17:49 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405021306530.2154@localhost.localdomain>
References: <20140501231222.31890.82860.stgit@birch.djwong.org> <20140501231236.31890.46904.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbaEBLR4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 May 2014 07:17:56 -0400
In-Reply-To: <20140501231236.31890.46904.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 1 May 2014, Darrick J. Wong wrote:

> Date: Thu, 01 May 2014 16:12:36 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: tytso@mit.edu, darrick.wong@oracle.com
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH 02/37] misc: coverity fixes
> 
> Fix various small resource leaks and error code handling issues that
> Coverity pointed out.
> 
> Fixes-Coverity-Bugs: 11919{39-45}, 1174118, 1049160, 1049144
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  debugfs/xattrs.c    |   38 ++++++++++++++++++++------------------
>  lib/ext2fs/extent.c |    7 ++++---
>  lib/ext2fs/punch.c  |    2 +-
>  misc/create_inode.c |   34 ++++++++++++++++++++--------------
>  4 files changed, 45 insertions(+), 36 deletions(-)
> 
> 
> diff --git a/debugfs/xattrs.c b/debugfs/xattrs.c
> index 0a29521..7109719 100644
> --- a/debugfs/xattrs.c
> +++ b/debugfs/xattrs.c
> @@ -122,26 +122,26 @@ void do_get_xattr(int argc, char **argv)
>  		default:
>  			printf("%s: Usage: %s <file> <attr> [-f outfile]\n",
>  			       argv[0], argv[0]);
> -			return;
> +			goto out2;
>  		}
>  	}
>  
>  	if (optind != argc - 2) {
>  		printf("%s: Usage: %s <file> <attr> [-f outfile]\n", argv[0],
>  		       argv[0]);
> -		return;
> +		goto out2;
>  	}
>  
>  	if (check_fs_open(argv[0]))
> -		return;
> +		goto out2;
>  
>  	ino = string_to_inode(argv[optind]);
>  	if (!ino)
> -		return;
> +		goto out2;
>  
>  	err = ext2fs_xattrs_open(current_fs, ino, &h);
>  	if (err)
> -		return;
> +		goto out2;
>  
>  	err = ext2fs_xattrs_read(h);
>  	if (err)
> @@ -153,18 +153,19 @@ void do_get_xattr(int argc, char **argv)
>  
>  	if (fp) {
>  		fwrite(buf, buflen, 1, fp);
> -		fclose(fp);
>  	} else {
>  		dump_xattr_string(stdout, buf, buflen);
>  		printf("\n");
>  	}
>  
> -	if (buf)
> -		ext2fs_free_mem(&buf);
> +	ext2fs_free_mem(&buf);
>  out:
>  	ext2fs_xattrs_close(&h);
>  	if (err)
>  		com_err(argv[0], err, "while getting extended attribute");
> +out2:
> +	if (fp)
> +		fclose(fp);
>  }
>  
>  void do_set_xattr(int argc, char **argv)
> @@ -190,30 +191,30 @@ void do_set_xattr(int argc, char **argv)
>  		default:
>  			printf("%s: Usage: %s <file> <attr> [-f infile | "
>  			       "value]\n", argv[0], argv[0]);
> -			return;
> +			goto out2;
>  		}
>  	}
>  
>  	if (optind != argc - 2 && optind != argc - 3) {
>  		printf("%s: Usage: %s <file> <attr> [-f infile | value>]\n",
>  		       argv[0], argv[0]);
> -		return;
> +		goto out2;
>  	}
>  
>  	if (check_fs_open(argv[0]))
> -		return;
> +		goto out2;
>  	if (check_fs_read_write(argv[0]))
> -		return;
> +		goto out2;
>  	if (check_fs_bitmaps(argv[0]))
> -		return;
> +		goto out2;
>  
>  	ino = string_to_inode(argv[optind]);
>  	if (!ino)
> -		return;
> +		goto out2;
>  
>  	err = ext2fs_xattrs_open(current_fs, ino, &h);
>  	if (err)
> -		return;
> +		goto out2;
>  
>  	err = ext2fs_xattrs_read(h);
>  	if (err)
> @@ -238,13 +239,14 @@ void do_set_xattr(int argc, char **argv)
>  		goto out;
>  
>  out:
> +	ext2fs_xattrs_close(&h);
> +	if (err)
> +		com_err(argv[0], err, "while setting extended attribute");
> +out2:
>  	if (fp) {
>  		fclose(fp);
>  		ext2fs_free_mem(&buf);
>  	}
> -	ext2fs_xattrs_close(&h);
> -	if (err)
> -		com_err(argv[0], err, "while setting extended attribute");
>  }
>  
>  void do_rm_xattr(int argc, char **argv)
> diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
> index 80ce88f..30673b5 100644
> --- a/lib/ext2fs/extent.c
> +++ b/lib/ext2fs/extent.c
> @@ -1482,7 +1482,7 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
>  			if (retval) {
>  				r2 = ext2fs_extent_goto(handle, orig_lblk);
>  				if (r2 == 0)
> -					ext2fs_extent_replace(handle, 0,
> +					(void)ext2fs_extent_replace(handle, 0,
>  							      &orig_extent);
>  				goto done;
>  			}
> @@ -1498,11 +1498,12 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
>  				r2 = ext2fs_extent_goto(handle,
>  							newextent.e_lblk);
>  				if (r2 == 0)
> -					ext2fs_extent_delete(handle, 0);
> +					(void)ext2fs_extent_delete(handle, 0);
>  			}
>  			r2 = ext2fs_extent_goto(handle, orig_lblk);
>  			if (r2 == 0)
> -				ext2fs_extent_replace(handle, 0, &orig_extent);
> +				(void)ext2fs_extent_replace(handle, 0,
> +							    &orig_extent);
>  			goto done;
>  		}
>  	}
> diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
> index 60cd2a3..c9250cd 100644
> --- a/lib/ext2fs/punch.c
> +++ b/lib/ext2fs/punch.c
> @@ -403,7 +403,7 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
>  			retval = 0;
>  
>  			/* Jump forward to the next extent. */
> -			ext2fs_extent_goto(handle, next_lblk);
> +			(void)ext2fs_extent_goto(handle, next_lblk);

Why do we not want to check the return value of this ? There might
be an error right ?

>  			op = EXT2_EXTENT_CURRENT;
>  		}
>  		if (retval)
> diff --git a/misc/create_inode.c b/misc/create_inode.c
> index 964c66a..4bb5e5b 100644
> --- a/misc/create_inode.c
> +++ b/misc/create_inode.c
> @@ -465,7 +465,7 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
>  	char		ln_target[PATH_MAX];
>  	unsigned int	save_inode;
>  	ext2_ino_t	ino;
> -	errcode_t	retval;
> +	errcode_t	retval = 0;
>  	int		read_cnt;
>  	int		hdlink;
>  
> @@ -486,7 +486,11 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
>  		if ((!strcmp(dent->d_name, ".")) ||
>  		    (!strcmp(dent->d_name, "..")))
>  			continue;
> -		lstat(dent->d_name, &st);
> +		if (lstat(dent->d_name, &st)) {
> +			com_err(__func__, errno, _("while lstat \"%s\""),
> +				dent->d_name);
> +			goto out;
> +		}
>  		name = dent->d_name;
>  
>  		/* Check for hardlinks */
> @@ -501,7 +505,7 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
>  				if (retval) {
>  					com_err(__func__, retval,
>  						"while linking %s", name);
> -					return retval;
> +					goto out;
>  				}
>  				continue;
>  			} else
> @@ -517,7 +521,7 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
>  				com_err(__func__, retval,
>  					_("while creating special file "
>  					  "\"%s\""), name);
> -				return retval;
> +				goto out;
>  			}
>  			break;
>  		case S_IFSOCK:
> @@ -527,7 +531,7 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
>  			continue;
>  		case S_IFLNK:
>  			read_cnt = readlink(name, ln_target,
> -					    sizeof(ln_target));
> +					    sizeof(ln_target) - 1);
>  			if (read_cnt == -1) {
>  				com_err(__func__, errno,
>  					_("while trying to readlink \"%s\""),
> @@ -541,7 +545,7 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
>  				com_err(__func__, retval,
>  					_("while writing symlink\"%s\""),
>  					name);
> -				return retval;
> +				goto out;
>  			}
>  			break;
>  		case S_IFREG:
> @@ -550,7 +554,7 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
>  			if (retval) {
>  				com_err(__func__, retval,
>  					_("while writing file \"%s\""), name);
> -				return retval;
> +				goto out;
>  			}
>  			break;
>  		case S_IFDIR:
> @@ -559,25 +563,25 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
>  			if (retval) {
>  				com_err(__func__, retval,
>  					_("while making dir \"%s\""), name);
> -				return retval;
> +				goto out;
>  			}
>  			retval = ext2fs_namei(fs, root, parent_ino,
>  					      name, &ino);
>  			if (retval) {
>  				com_err(name, retval, 0);
> -					return retval;
> +					goto out;
>  			}
>  			/* Populate the dir recursively*/
>  			retval = __populate_fs(fs, ino, name, root, hdlinks);
>  			if (retval) {
>  				com_err(__func__, retval,
>  					_("while adding dir \"%s\""), name);
> -				return retval;
> +				goto out;
>  			}
>  			if (chdir("..")) {
>  				com_err(__func__, errno,
>  					_("during cd .."));
> -				return errno;

you probably wan to store errno in retval because that's what we
return from the function.

> +				goto out;
>  			}
>  			break;
>  		default:
> @@ -588,14 +592,14 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
>  		retval =  ext2fs_namei(fs, root, parent_ino, name, &ino);
>  		if (retval) {
>  			com_err(name, retval, 0);
> -			return retval;
> +			goto out;
>  		}
>  
>  		retval = set_inode_extra(fs, parent_ino, ino, &st);
>  		if (retval) {
>  			com_err(__func__, retval,
>  				_("while setting inode for \"%s\""), name);
> -			return retval;
> +			goto out;
>  		}
>  
>  		/* Save the hardlink ino */
> @@ -612,7 +616,7 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
>  				if (p == NULL) {
>  					com_err(name, errno,
>  						_("Not enough memory"));
> -					return errno;
> +					goto out;

same here.

Thanks!
-Lukas

>  				}
>  				hdlinks->hdl = p;
>  				hdlinks->size += HDLINK_CNT;
> @@ -623,6 +627,8 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
>  			hdlinks->count++;
>  		}
>  	}
> +
> +out:
>  	closedir(dh);
>  	return retval;
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
