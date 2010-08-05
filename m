From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: re-inline ext4_rec_len_(to|from)_disk functions
Date: Wed, 04 Aug 2010 19:28:20 -0500
Message-ID: <4C5A05A4.9030701@redhat.com>
References: <4C598CA5.70707@redhat.com> <20100805001116.GB2901@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007Ab0HEA20 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Aug 2010 20:28:26 -0400
In-Reply-To: <20100805001116.GB2901@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted Ts'o wrote:
> Thanks for the commit.  Since we don't have support for fs block size
>> page size (and having done a private investigation about what would
> be required, I'm not sure it's going to happen any time soon --- and
> if it does, yanking the #if statements is going to be a tiny part of
> the patch :-).
> 
> So I slightly modified your patch to only do the extra complexity if
> the page size is >= 65536.

I had resisted doing that because at least the original rationale in
the patch was for when the VM allows block size > page size ...

Side note, if you do this is PAGE_SIZE or PAGE_CACHE_SIZE the right macro?

-Eric

> 						- Ted
> 
> commit 097639d271f40376f3b3a94c7ab242c22ddc8bc1
> Author: Eric Sandeen <sandeen@redhat.com>
> Date:   Wed Aug 4 20:09:07 2010 -0400
> 
>     ext4: re-inline ext4_rec_len_(to|from)_disk functions
>     
>     commit 3d0518f4, "ext4: New rec_len encoding for very
>     large blocksizes" made several changes to this path, but from
>     a perf perspective, un-inlining ext4_rec_len_from_disk() seems
>     most significant.  This function is called from ext4_check_dir_entry(),
>     which on a file-creation workload is called extremely often.
>     
>     I tested this with bonnie:
>     
>     # bonnie++ -u root -s 0 -f -x 200 -d /mnt/test -n 32
>     
>     (this does 200 iterations) and got this for the file creations:
>     
>     ext4 stock:   Average =  21206.8 files/s
>     ext4 inlined: Average =  22346.7 files/s  (+5%)
>     
>     Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index ed14e1d..0f340bf 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1412,6 +1412,43 @@ struct ext4_dir_entry_2 {
>  #define EXT4_MAX_REC_LEN		((1<<16)-1)
>  
>  /*
> + * If we ever get support for fs block sizes > page_size, we'll need
> + * to remove the #if statements in the next two functions...
> + */
> +static inline unsigned int
> +ext4_rec_len_from_disk(__le16 dlen, unsigned blocksize)
> +{
> +	unsigned len = le16_to_cpu(dlen);
> +
> +#if (PAGE_SIZE >= 65536)
> +	if (len == EXT4_MAX_REC_LEN || len == 0)
> +		return blocksize;
> +	return (len & 65532) | ((len & 3) << 16);
> +#else
> +	return len;
> +#endif
> +}
> +
> +static inline __le16 ext4_rec_len_to_disk(unsigned len, unsigned blocksize)
> +{
> +	if ((len > blocksize) || (blocksize > (1 << 18)) || (len & 3))
> +		BUG();
> +#if (PAGE_SIZE >= 65536)
> +	if (len < 65536)
> +		return cpu_to_le16(len);
> +	if (len == blocksize) {
> +		if (blocksize == 65536)
> +			return cpu_to_le16(EXT4_MAX_REC_LEN);
> +		else
> +			return cpu_to_le16(0);
> +	}
> +	return cpu_to_le16((len & 65532) | ((len >> 16) & 3));
> +#else
> +	return cpu_to_le16(len);
> +#endif
> +}
> +
> +/*
>   * Hash Tree Directory indexing
>   * (c) Daniel Phillips, 2001
>   */
> @@ -1636,8 +1673,6 @@ extern long ext4_compat_ioctl(struct file *, unsigned int, unsigned long);
>  extern int ext4_ext_migrate(struct inode *);
>  
>  /* namei.c */
> -extern unsigned int ext4_rec_len_from_disk(__le16 dlen, unsigned blocksize);
> -extern __le16 ext4_rec_len_to_disk(unsigned len, unsigned blocksize);
>  extern int ext4_orphan_add(handle_t *, struct inode *);
>  extern int ext4_orphan_del(handle_t *, struct inode *);
>  extern int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index ea8b59d..314c0d3 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -179,30 +179,6 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
>  static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
>  			     struct inode *inode);
>  
> -unsigned int ext4_rec_len_from_disk(__le16 dlen, unsigned blocksize)
> -{
> -	unsigned len = le16_to_cpu(dlen);
> -
> -	if (len == EXT4_MAX_REC_LEN || len == 0)
> -		return blocksize;
> -	return (len & 65532) | ((len & 3) << 16);
> -}
> -
> -__le16 ext4_rec_len_to_disk(unsigned len, unsigned blocksize)
> -{
> -	if ((len > blocksize) || (blocksize > (1 << 18)) || (len & 3))
> -		BUG();
> -	if (len < 65536)
> -		return cpu_to_le16(len);
> -	if (len == blocksize) {
> -		if (blocksize == 65536)
> -			return cpu_to_le16(EXT4_MAX_REC_LEN);
> -		else
> -			return cpu_to_le16(0);
> -	}
> -	return cpu_to_le16((len & 65532) | ((len >> 16) & 3));
> -}
> -
>  /*
>   * p is at least 6 bytes before the end of page
>   */

