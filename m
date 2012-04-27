From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: [PATCH] vfs: allow custom EOF in generic_file_llseek code
Date: Sat, 28 Apr 2012 00:47:53 +0200
Message-ID: <4F9B2219.6090302@itwm.fraunhofer.de>
References: <4F9AC770.8080004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39332 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643Ab2D0Wr4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Apr 2012 18:47:56 -0400
In-Reply-To: <4F9AC770.8080004@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/27/2012 06:21 PM, Eric Sandeen wrote:
> For ext3/4 htree directories, using the vfs llseek function with
> SEEK_END goes to i_size like for any other file, but in reality
> we want the maximum possible hash value.  Recent changes
> in ext4 have cut & pasted generic_file_llseek() back into fs/ext4/dir.c,
> but replicating this core code seems like a bad idea, especially
> since the copy has already diverged from the vfs.
> 
> This patch implements a version of generic_file_llseek which can accept
> both a custom maximum offset, and a custom EOF position.  With this
> in place, ext4_dir_llseek can pass in the appropriate maximum hash
> position for both maxsize and eof, and get what it wants.
> 
> As far as I know, this does not fix any bugs - nfs in the kernel
> doesn't use SEEK_END, and I don't know of any user who does.  But
> some ext4 folks seem keen on doing the right thing here, and I can't
> really argue.
> 
> (Patch also fixes up some comments slightly)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index ffc99d2..ecd1828 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -51,14 +51,15 @@ static loff_t lseek_execute(struct file *file, struct inode *inode,
>  }
>  
>  /**
> - * generic_file_llseek_size - generic llseek implementation for regular files
> + * generic_file_llseek_size_eof - generic llseek implementation for regular files
>   * @file:	file structure to seek on
>   * @offset:	file offset to seek to
>   * @origin:	type of seek
> - * @size:	max size of file system
> + * @size:	max size of this file in file system
> + * @eof:	offset used for SEEK_END position
>   *
>   * This is a variant of generic_file_llseek that allows passing in a custom
> - * file size.
> + * maximum file size and a custom EOF position, for e.g. hashed directories
>   *
>   * Synchronization:
>   * SEEK_SET and SEEK_END are unsynchronized (but atomic on 64bit platforms)
> @@ -66,14 +67,14 @@ static loff_t lseek_execute(struct file *file, struct inode *inode,
>   * read/writes behave like SEEK_SET against seeks.
>   */
>  loff_t
> -generic_file_llseek_size(struct file *file, loff_t offset, int origin,
> -		loff_t maxsize)
> +generic_file_llseek_size_eof(struct file *file, loff_t offset, int origin,
> +		loff_t maxsize, loff_t eof)
>  {
>  	struct inode *inode = file->f_mapping->host;
>  
>  	switch (origin) {
>  	case SEEK_END:
> -		offset += i_size_read(inode);
> +		offset += eof;
>  		break;

Here is the only glitch I can see. As Andreas already said before, it
might overflow here. Do we need do care about that? As you already said,
SEEK_END is unlikely to be ever called for directories. But then we also
cannot keep user space from doing weird calls...


>  	case SEEK_CUR:
>  		/*
> @@ -99,7 +100,7 @@ generic_file_llseek_size(struct file *file, loff_t offset, int origin,
>  		 * In the generic case the entire file is data, so as long as
>  		 * offset isn't at the end of the file then the offset is data.
>  		 */
> -		if (offset >= i_size_read(inode))
> +		if (offset >= eof)
>  			return -ENXIO;
>  		break;
>  	case SEEK_HOLE:
> @@ -107,14 +108,35 @@ generic_file_llseek_size(struct file *file, loff_t offset, int origin,
>  		 * There is a virtual hole at the end of the file, so as long as
>  		 * offset isn't i_size or larger, return i_size.
>  		 */
> -		if (offset >= i_size_read(inode))
> +		if (offset >= eof)
>  			return -ENXIO;
> -		offset = i_size_read(inode);
> +		offset = eof;
>  		break;
>  	}
>  
>  	return lseek_execute(file, inode, offset, maxsize);
>  }
> +EXPORT_SYMBOL(generic_file_llseek_size_eof);
> +
> +/**
> + * generic_file_llseek_size - generic llseek implementation for regular files
> + * @file:	file structure to seek on
> + * @offset:	file offset to seek to
> + * @origin:	type of seek
> + * @size:	max size of this file in file system
> + *
> + * This is a variant of generic_file_llseek that allows passing in a custom
> + * maximum file size.
> + */
> +loff_t
> +generic_file_llseek_size(struct file *file, loff_t offset, int origin,
> +		loff_t maxsize)
> +{
> +	struct inode *inode = file->f_mapping->host;
> +
> +	return generic_file_llseek_size_eof(file, offset, origin, maxsize,
> +					i_size_read(inode));
> +}
>  EXPORT_SYMBOL(generic_file_llseek_size);
>  
>  /**
> @@ -131,8 +153,9 @@ loff_t generic_file_llseek(struct file *file, loff_t offset, int origin)
>  {
>  	struct inode *inode = file->f_mapping->host;
>  
> -	return generic_file_llseek_size(file, offset, origin,
> -					inode->i_sb->s_maxbytes);
> +	return generic_file_llseek_size_eof(file, offset, origin,
> +					inode->i_sb->s_maxbytes,
> +					i_size_read(inode));
>  }
>  EXPORT_SYMBOL(generic_file_llseek);
>  
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8de6755..a6ae7a4 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2402,6 +2402,8 @@ extern loff_t no_llseek(struct file *file, loff_t offset, int origin);
>  extern loff_t generic_file_llseek(struct file *file, loff_t offset, int origin);
>  extern loff_t generic_file_llseek_size(struct file *file, loff_t offset,
>  		int origin, loff_t maxsize);
> +extern loff_t generic_file_llseek_size_eof(struct file *file, loff_t offset,
> +		int origin, loff_t maxsize, loff_t eof);
>  extern int generic_file_open(struct inode * inode, struct file * filp);
>  extern int nonseekable_open(struct inode * inode, struct file * filp);

Another question, wouldn't it be better to entirely move
generic_file_llseek_size() and generic_file_llseek() into fs.h to make
sure it gets inlined?


Cheers,
Bernd
