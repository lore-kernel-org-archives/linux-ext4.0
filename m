From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH -v2] ext4: limit xattr size to INT_MAX
Date: Fri, 30 Mar 2018 12:50:16 -0700
Message-ID: <20180330195016.GC180083@gmail.com>
References: <20180329194125.GC3790@thunk.org>
 <20180330191320.7270-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        adilger@dilger.ca, wen.xu@gatech.edu, ebiggers@google.com,
        stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180330191320.7270-1-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

On Fri, Mar 30, 2018 at 03:13:20PM -0400, Theodore Ts'o wrote:
>
> Also if the xattr block is corrupted, mark the file system as
> containing an error.

Weren't we doing that already?

> 
> This issue has been assigned CVE-2018-1095.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=199185
> https://bugzilla.redhat.com/show_bug.cgi?id=1560793
> 
> Reported-by: Wen Xu <wen.xu@gatech.edu>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@vger.kernel.org

I'm still confused why you removed my Fixes: line and the mentions of the bug
affecting external inode xattrs only.  Wasn't the size validation correct before
then?  We might want to send d7614cc16146 to the stable trees, but after that
the sizes were being validated correctly, right?

> ---
>  fs/ext4/xattr.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 63656dbafdc4..d2a9b078e121 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -195,10 +195,14 @@ ext4_xattr_check_entries(struct ext4_xattr_entry *entry, void *end,
>  
>  	/* Check the values */
>  	while (!IS_LAST_ENTRY(entry)) {
> +		u32 size = le32_to_cpu(entry->e_value_size);
> +
> +		if (size > INT_MAX)
> +			return -EFSCORRUPTED;
> +
>  		if (entry->e_value_size != 0 &&
>  		    entry->e_value_inum == 0) {

Use 'size' instead of 'entry->e_value_size' here, like in my original patch?

>  			u16 offs = le16_to_cpu(entry->e_value_offs);
> -			u32 size = le32_to_cpu(entry->e_value_size);
>  			void *value;
>  
>  			/*
> @@ -523,8 +527,10 @@ ext4_xattr_block_get(struct inode *inode, int name_index, const char *name,
>  	if (error)
>  		goto cleanup;
>  	size = le32_to_cpu(entry->e_value_size);
> +	error = -ERANGE;
> +	if (unlikely(size > INT_MAX))
> +		goto cleanup;


>  	if (buffer) {
> -		error = -ERANGE;
>  		if (size > buffer_size)
>  			goto cleanup;
>  		if (entry->e_value_inum) {
> @@ -572,8 +578,10 @@ ext4_xattr_ibody_get(struct inode *inode, int name_index, const char *name,
>  	if (error)
>  		goto cleanup;
>  	size = le32_to_cpu(entry->e_value_size);
> +	error = -ERANGE;
> +	if (unlikely(size > INT_MAX))
> +		goto cleanup;

I still think the new checks here are misleading and shouldn't be added.  If
someone can actually modify the buffer_head concurrently then they could just
make the size larger than the block but <= INT_MAX, so that the following
page(s) are also copied to the xattr, disclosing memory or crashing.  Or they
could modify ->e_value_offs to point past the block.  Also since this is not
using a volatile memory access, the compiler is free to reload the value and
assume it's the same.

- Eric
