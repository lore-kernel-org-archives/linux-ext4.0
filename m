From: Robert Yang <liezhi.yang@windriver.com>
Subject: Re: [PATCH V2 09/11] misc/create_inode.c: handle hardlinks
Date: Wed, 25 Dec 2013 11:14:05 +0800
Message-ID: <52BA4D7D.1020803@windriver.com>
References: <1387874847-4922-1-git-send-email-liezhi.yang@windriver.com> <1387874847-4922-10-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>
To: Robert Yang <liezhi.yang@windriver.com>, <tytso@mit.edu>,
	<dvhart@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:46813 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab3LYDOL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Dec 2013 22:14:11 -0500
In-Reply-To: <1387874847-4922-10-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sorry, this patch should be updated a little, please see my comments inline ...

On 12/24/2013 04:47 PM, Robert Yang wrote:
> Create the inode and save the native inode number when we meet the hard
> link (st_nlink > 1) at the first time, use ext2fs_link() to link the
> name to the target inode number when we meet the same native inode
> number again.
>
> This algorithm is referred this from the genext2fs.
>
> Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
> Reviewed-by: Darren Hart <dvhart@linux.intel.com>
> ---
>   misc/create_inode.c |   87 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   misc/create_inode.h |   18 +++++++++++
>   misc/mke2fs.c       |   12 +++++++
>   3 files changed, 117 insertions(+)
>
> diff --git a/misc/create_inode.c b/misc/create_inode.c
> index f1af6a9..7462413 100644
> --- a/misc/create_inode.c
> +++ b/misc/create_inode.c
> @@ -10,6 +10,44 @@
>   #define S_BLKSIZE 512
>   #endif
>
> +/* For saving the hard links */
> +int hdlink_cnt = HDLINK_CNT;
> +
> +/* Link an inode number to a directory */
> +static errcode_t add_link(ext2_ino_t parent_ino, ext2_ino_t ino, const char *name)
> +{
> +	struct ext2_inode	inode;
> +	errcode_t		retval;
> +
> +	retval = ext2fs_read_inode(current_fs, ino, &inode);
> +        if (retval) {
> +		com_err(__FUNCTION__, retval, "while reading inode %u", ino);
> +		return retval;
> +	}
> +
> +	retval = ext2fs_link(current_fs, parent_ino, name, ino, inode.i_flags);
> +	if (retval == EXT2_ET_DIR_NO_SPACE) {
> +		retval = ext2fs_expand_dir(current_fs, parent_ino);
> +		if (retval) {
> +			com_err(__FUNCTION__, retval, "while expanding directory");
> +			return retval;
> +		}
> +		retval = ext2fs_link(current_fs, parent_ino, name, ino, inode.i_flags);
> +	}
> +	if (retval) {
> +		com_err(__FUNCTION__, retval, "while linking %s", name);
> +		return retval;
> +	}
> +
> +	inode.i_links_count++;
> +
> +	retval = ext2fs_write_inode(current_fs, ino, &inode);
> +	if (retval)
> +		com_err(__FUNCTION__, retval, "while writing inode %u", ino);
> +
> +	return retval;
> +}
> +
>   /* Fill the uid, gid, mode and time for the inode */
>   static void fill_inode(struct ext2_inode *inode, struct stat *st)
>   {
> @@ -270,6 +308,17 @@ fail:
>   	return retval;
>   }
>
> +int is_hardlink(ext2_ino_t ino)
> +{
> +	int i;
> +
> +	for(i = 0; i < hdlinks.count; i++) {
> +		if(hdlinks.hdl[i].src_ino == ino)
> +			return i;
> +	}
> +	return -1;
> +}
> +
>   /* Copy the native file to the fs */
>   errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest)
>   {
> @@ -380,9 +429,11 @@ errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
>   	struct dirent	*dent;
>   	struct stat	st;
>   	char		ln_target[PATH_MAX];
> +	unsigned int	save_inode = 0;

The save_inode = 0 should be set before read each file (inside the while
loop), otherwise it will be 1 for other files after we meet the first
hardlink.

// Robert

>   	ext2_ino_t	ino;
>   	errcode_t	retval;
>   	int		read_cnt;
> +	int		hdlink;
>
>   	root = EXT2_ROOT_INO;
>
> @@ -404,6 +455,21 @@ errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
>   		lstat(dent->d_name, &st);
>   		name = dent->d_name;
>
> +		/* Check for hardlinks */
> +		if (!S_ISDIR(st.st_mode) && !S_ISLNK(st.st_mode) && st.st_nlink > 1) {
> +			hdlink = is_hardlink(st.st_ino);
> +			if (hdlink >= 0) {
> +				retval = add_link(parent_ino,
> +						hdlinks.hdl[hdlink].dst_ino, name);
> +				if (retval) {
> +					com_err(__FUNCTION__, retval, "while linking %s", name);
> +					return retval;
> +				}
> +				continue;
> +			} else
> +				save_inode = 1;
> +		}
> +
>   		switch(st.st_mode & S_IFMT) {
>   			case S_IFCHR:
>   			case S_IFBLK:
> @@ -472,6 +538,27 @@ errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
>   				_("while setting inode for \"%s\""), name);
>   			return retval;
>   		}
> +
> +		/* Save the hardlink ino */
> +		if (save_inode) {
> +			/*
> +			 * Check whether need more memory, and we don't need
> +			 * free() since the lifespan will be over after the fs
> +			 * populated.
> +			 */
> +			if (hdlinks.count == hdlink_cnt) {
> +				if ((hdlinks.hdl = realloc (hdlinks.hdl,
> +						(hdlink_cnt + HDLINK_CNT) *
> +						sizeof (struct hdlink_s))) == NULL) {
> +					com_err(name, errno, "Not enough memory");
> +					return errno;
> +				}
> +				hdlink_cnt += HDLINK_CNT;
> +			}
> +			hdlinks.hdl[hdlinks.count].src_ino = st.st_ino;
> +			hdlinks.hdl[hdlinks.count].dst_ino = ino;
> +			hdlinks.count++;
> +		}
>   	}
>   	closedir(dh);
>   	return retval;
> diff --git a/misc/create_inode.h b/misc/create_inode.h
> index 9fc97fa..2b6d429 100644
> --- a/misc/create_inode.h
> +++ b/misc/create_inode.h
> @@ -6,9 +6,27 @@
>   #include "ext2fs/ext2fs.h"
>   #include "nls-enable.h"
>
> +struct hdlink_s
> +{
> +	ext2_ino_t src_ino;
> +	ext2_ino_t dst_ino;
> +};
> +
> +struct hdlinks_s
> +{
> +	int count;
> +	struct hdlink_s *hdl;
> +};
> +
> +struct hdlinks_s hdlinks;
> +
>   ext2_filsys    current_fs;
>   ext2_ino_t     root;
>
> +/* For saving the hard links */
> +#define HDLINK_CNT     4
> +extern int hdlink_cnt;
> +
>   /* For populating the filesystem */
>   extern errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir);
>   extern errcode_t do_mknod_internal(ext2_ino_t cwd, const char *name, struct stat *st);
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index eab5463..10cdfd2 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -2802,6 +2802,18 @@ no_journal:
>   		if (!quiet)
>   			printf("%s", _("Copying files into the device: "));
>
> +		/*
> +		 * Allocate memory for the hardlinks, we don't need free()
> +		 * since the lifespan will be over after the fs populated.
> +		 */
> +		if ((hdlinks.hdl = (struct hdlink_s *)
> +				malloc(hdlink_cnt * sizeof(struct hdlink_s))) == NULL) {
> +			fprintf(stderr, "%s", _("\nNot enough memory\n"));
> +			retval = ext2fs_close(fs);
> +			return retval;
> +		}
> +
> +		hdlinks.count = 0;
>   		current_fs = fs;
>   		root = EXT2_ROOT_INO;
>   		retval = populate_fs(root, root_dir);
>
