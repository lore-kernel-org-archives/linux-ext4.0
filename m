From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: debugfs: dump a sparse file as a new sparse file
Date: Mon, 31 Dec 2012 21:08:41 -0500
Message-ID: <20130101020841.GA9641@thunk.org>
References: <20121115144613.GA11706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: George Spelvin <linux@horizon.com>, linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41128 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab3AAEfU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Dec 2012 23:35:20 -0500
Content-Disposition: inline
In-Reply-To: <20121115144613.GA11706@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 15, 2012 at 04:46:13AM -0000, Zheng Liu wrote:
> --- a/debugfs/dump.c
> +++ b/debugfs/dump.c
> @@ -105,10 +105,11 @@ static void dump_file(const char *cmdname, ext2_ino_t ino, int fd,
>  {
>  	errcode_t retval;
>  	struct ext2_inode	inode;
> -	char 		buf[8192];
> +	char 		buf[current_fs->blocksize];

Note: this is a non-standard/non-portable GCC extension.  The best way
to fix this is to explicitly malloc the buffer and then free it before
dump_file exits.

Also, fixing the hard-coded maximum 8k block size, so these sorts of
changes should be done in a separate commit.

>  extern errcode_t ext2fs_file_llseek(ext2_file_t file, __u64 offset,
> diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
> index 1f7002c..d25ebb4 100644
> --- a/lib/ext2fs/fileio.c
> +++ b/lib/ext2fs/fileio.c
> @@ -176,23 +176,26 @@ static errcode_t sync_buffer_position(ext2_file_t file)
>   * This function loads the file's block buffer with valid data from
>   * the disk as necessary.
>   *
> - * If dontfill is true, then skip initializing the buffer since we're
> + * If flags is true, then skip initializing the buffer since we're
>   * going to be replacing its entire contents anyway.  If set, then the
>   * function basically only sets file->physblock and EXT2_FILE_BUF_VALID
>   */
>  #define DONTFILL 1

The comment "If flags is true..." should be changed to "if the
DONTFILL flag is set..."  

@@ -202,7 +205,11 @@ static errcode_t load_buffer(ext2_file_t file, int dontfill)
 			} else
 				memset(file->buf, 0, fs->blocksize);
 		}
-		file->flags |= EXT2_FILE_BUF_VALID;
+		if (flags == SEEK && ((ret_flags & BMAP_RET_UNINIT) ||
+		    file->physblock == 0))
+			valid = 0;
+		if (valid)
+			file->flags |= EXT2_FILE_BUF_VALID;


valid is initialized to 1, and then set to zero above.  So I'm not
sure what the point is having the valid variable.  Why not do
something like this:

		if (!(flags == SEEK && ((ret_flags & BMAP_RET_UNINIT) ||
				      file->physblock == 0)))
			file->flags |= EXT2_FILE_BUF_VALID;

or...
		if (((flags != SEEK) ||
		     (!(ret_flags & BMAP_RET_UNINIT) && file->physblock)))
			file->flags |= EXT2_FILE_BUF_VALID;


Also, can you add a definition of what SEEK actually means in the
context of load_buffer()?

					- Ted
