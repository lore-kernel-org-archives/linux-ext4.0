From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [PATCH, RFC2] vfs: teach llseek about custom EOF values
Date: Thu, 26 Apr 2012 18:42:30 -0500
Message-ID: <8D246A65-9F9D-4189-8EFB-59E19B5416A8@dilger.ca>
References: <4F98508A.2040506@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35228 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759501Ab2DZXmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Apr 2012 19:42:36 -0400
Received: by obbta14 with SMTP id ta14so233898obb.19
        for <linux-ext4@vger.kernel.org>; Thu, 26 Apr 2012 16:42:35 -0700 (PDT)
In-Reply-To: <4F98508A.2040506@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-04-25, at 2:29 PM, Eric Sandeen wrote:
> This is a pretty-much untested patch which lets ext4 tell the vfs
> llseek code that when someone goes to SEEK_END on a dx dir, they should
> go out to the max hash value, not to i_size.  It also contains changes
> to ext4_dir_llseek (from what is upstream) to send the appropriate
> max size for dx, non-dx, extent, non-extent, 32-bit, and 64-bit
> systems.  (!)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> This patch is mutually exclusive to the "remove ext4_dir_llseek"
> patch, of course)
> 
> /*
> + * ext4_dir_llseek() uses generic_file_llseek() routines.
> + * This handles both non-htree and htree directories, where the "offset"
> + * is in terms of the filename hash value instead of the byte offset.
> + *
> + * For htree/dx dirs, the max offset and SEEK_END are both at
> + * ext4_get_htree_eof.
>  *
>  * NOTE: offsets obtained *before* ext4_set_inode_flag(dir, EXT4_INODE_INDEX)
>  *       will be invalid once the directory was converted into a dx directory
> @@ -322,64 +325,23 @@ static inline loff_t ext4_get_htree_eof(struct file *filp)
> loff_t ext4_dir_llseek(struct file *file, loff_t offset, int origin)
> {
> 	struct inode *inode = file->f_mapping->host;
> 	int dx_dir = is_dx_dir(inode);

[Note: I trimmed the deleted lines, since it made the patch unreadable]

I like this patch, since it is quite clean and readable, and we aren't
reimplementing the generic_file_llseek code.

The reasons why I prefer the variant that SEEK_END returns a hash value
are twofold.  Firstly, it is just more consistent that if SEEK_CUR and
SEEK_SET are using hash-offset values that SEEN_END also does the same.

Secondly, as for usefulness, I'm thinking of the case where there is
a very large directory, and some application wants to process it in
parallel.  It can call SEEK_END to get the "end" of the directory,
regardless of whether this is a hash-offset directory or a file-offset
directory (assuming SEEK_END is implemented correctly as in this patch),
and then for each thread it can seek and process a part of the single
directory in parallel (for each thread n of N):

	loff_t end = llseek(dirfd, 0, SEEK_END);

	thread_off = llseek(dirfd, n * (end / N), SEEK_SET);

I think this is a useful programming model, and that parallel processing
of small directories has not been an issue in the past is no reason not
to allow this in the future.  The application can still use "stat()" to
find the actual file size, and it makes sense that the "seek space" for
a file be consistent is just good programming practise. 

Cheers, Andreas

> +	if (dx_dir) {
> +		loff_t htree_max = ext4_get_htree_eof(file);
> 
> +		return generic_file_llseek_size_eof(file, offset, origin,
> +				htree_max, htree_max); 
> +	} else {
> +		loff_t maxsize;
> 
> -		/* so only negative offsets are left, does that have a
> -		 * meaning for directories at all? */
> -		if (dx_dir)
> -			offset += ext4_get_htree_eof(file);
> +		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
> +			maxsize= EXT4_SB(inode->i_sb)->s_bitmap_maxbytes;
> 		else
> +			maxsize= inode->i_sb->s_maxbytes;
> 
> +		return generic_file_llseek_size(file, offset, origin, maxsize);
> 	}
> }
> 
> /*
> diff --git a/fs/read_write.c b/fs/read_write.c
> index ffc99d2..f67c3b7 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -51,14 +51,15 @@ static loff_t lseek_execute(struct file *file, struct inode *inode,
> }
> 
> /**
> files
> + * generic_file_llseek_size_eof - generic llseek implementation for regular files
>  * @file:	file structure to seek on
>  * @offset:	file offset to seek to
>  * @origin:	type of seek
>  * @size:	max size of file system
> + * @eof:	if > 0, use for SEEK_END position other than i_size_read()
>  *
>  * This is a variant of generic_file_llseek that allows passing in a custom
> + * file size and a custom EOF position.
>  *
>  * Synchronization:
>  * SEEK_SET and SEEK_END are unsynchronized (but atomic on 64bit platforms)
> @@ -66,14 +67,17 @@ static loff_t lseek_execute(struct file *file, struct inode *inode,
>  * read/writes behave like SEEK_SET against seeks.
>  */
> loff_t
> +generic_file_llseek_size_eof(struct file *file, loff_t offset, int origin,
> +		loff_t maxsize, loff_t eof)
> {
> 	struct inode *inode = file->f_mapping->host;
> 
> +	if (!eof)
> +		eof = i_size_read(inode);
> +
> 	switch (origin) {
> 	case SEEK_END:
> +		offset += eof;
> 		break;
> 	case SEEK_CUR:
> 		/*
> @@ -99,7 +103,7 @@ generic_file_llseek_size(struct file *file, loff_t offset, int origin,
> 		 * In the generic case the entire file is data, so as long as
> 		 * offset isn't at the end of the file then the offset is data.
> 		 */
> -		if (offset >= i_size_read(inode))
> +		if (offset >= eof)
> 			return -ENXIO;
> 		break;
> 	case SEEK_HOLE:
> @@ -107,14 +111,32 @@ generic_file_llseek_size(struct file *file, loff_t offset, int origin,
> 		 * There is a virtual hole at the end of the file, so as long as
> 		 * offset isn't i_size or larger, return i_size.
> 		 */
> +		if (offset >= eof)
> 			return -ENXIO;
> +		offset = eof;
> 		break;
> 	}
> 
> 	return lseek_execute(file, inode, offset, maxsize);
> }
> +EXPORT_SYMBOL(generic_file_llseek_size_eof);
> +
> +/**
> + * generic_file_llseek_size - generic llseek implementation for regular files
> + * @file:	file structure to seek on
> + * @offset:	file offset to seek to
> + * @origin:	type of seek
> + * @size:	max size of file system
> + *
> + * This is a variant of generic_file_llseek that allows passing in a custom
> + * file size.
> + */
> +loff_t
> +generic_file_llseek_size(struct file *file, loff_t offset, int origin,
> +		loff_t maxsize)
> +{
> +	return generic_file_llseek_size(file, offset, origin, maxsize, 0);
> +}
> EXPORT_SYMBOL(generic_file_llseek_size);
> 
> /**
> @@ -131,8 +153,8 @@ loff_t generic_file_llseek(struct file *file, loff_t offset, int origin)
> {
> 	struct inode *inode = file->f_mapping->host;
> 
> +	return generic_file_llseek_size_eof(file, offset, origin,
> +					inode->i_sb->s_maxbytes, 0);
> }
> EXPORT_SYMBOL(generic_file_llseek);
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8de6755..a6ae7a4 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2402,6 +2402,8 @@ extern loff_t no_llseek(struct file *file, loff_t offset, int origin);
> extern loff_t generic_file_llseek(struct file *file, loff_t offset, int origin);
> extern loff_t generic_file_llseek_size(struct file *file, loff_t offset,
> 		int origin, loff_t maxsize);
> +extern loff_t generic_file_llseek_size_eof(struct file *file, loff_t offset,
> +		int origin, loff_t maxsize, loff_t eof);
> extern int generic_file_open(struct inode * inode, struct file * filp);
> extern int nonseekable_open(struct inode * inode, struct file * filp);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





