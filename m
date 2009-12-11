From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] replaced BUG() with return -EIO from	ext4_ext_get_blocks
Date: Fri, 11 Dec 2009 14:02:58 -0600
Message-ID: <4B22A572.5010201@redhat.com>
References: <1260540418-11844-1-git-send-email-surbhi.palande@canonical.com> <1260554859.21896.8.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Surbhi Palande <surbhi.palande@canonical.com>,
	linux-ext4@vger.kernel.org
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760988AbZLKUC7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Dec 2009 15:02:59 -0500
In-Reply-To: <1260554859.21896.8.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Frank Mayhar wrote:
> On Fri, 2009-12-11 at 16:06 +0200, Surbhi Palande wrote:
>> This patch fixes the upstream bug# 14286. When the address of an extent
>> corresponding to a given block is NULL and the tree is being traversed for
>> fetching such an address, a -EIO should be reported instead of a BUG(). This
>> situation should normally not occur. However if it does, then the system
>> should be rendered usable.
>>
>> Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
>> ---
>>  fs/ext4/extents.c |    7 ++++++-
>>  1 files changed, 6 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 3a7928f..51f87f3 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -3190,7 +3190,12 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
>>  	 * this situation is possible, though, _during_ tree modification;
>>  	 * this is why assert can't be put in ext4_ext_find_extent()
>>  	 */
>> -	BUG_ON(path[depth].p_ext == NULL && depth != 0);
>> +	if (path[depth].p_ext == NULL && depth != 0) {
>> +		err = -EIO;
>> +		printk(KERN_ERR "\n ext4 fs error in %s,%s,%s while reading a block ", \
>> +					__FILE__, __func__, __LINE__);
>> +		goto out2;
>> +	}
>>  	eh = path[depth].p_hdr;
>>  
>>  	ex = path[depth].p_ext;
> 
> As it happens, I fixed this locally but, as I considered it a band-aid
> fix at the time, I never pushed it to you guys.  My version of the fix
> is below; it dumps more information before returning the EIO.  I don't
> have a strong preference between the two versions but I would like to
> see the commentary included and the extra information is often useful
> during debugging.

My first thought was that this was a bandaid too, but I guess it can
come about due to on-disk corruption for any reason, so it should
be handled gracefully, and I suppose this approach seems fine.

I think the original plan was that a BUG() should be primarily for things
that would arise from a programming error, though EIO & graceful shutdown
even for that class of errors would probably be best.

Since this is catching on-disk corruption, though, it'd be better to call
ext4_error() and let the mount-time error-handling policy decide what to do.

I like having more info but below seems awfully wordy ;)  Maybe the first
printk would suffice, and switching it to an ext4_error() would be best,
I think.

-Eric


> Signed-off-by:  Frank Mayhar <fmayhar@google.com>
> 
>  fs/ext4/extents.c |   18 +++++++++++++++++-
>  1 files changed, 17 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index f7bdd55..7aa0bf6 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2859,8 +2859,24 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
>  	 * consistent leaf must not be empty;
>  	 * this situation is possible, though, _during_ tree modification;
>  	 * this is why assert can't be put in ext4_ext_find_extent()
> +	 *
> +	 * We don't want to panic in this case, as it can lead to a crash
> +	 * loop; instead we want to catch the error and abort.
>  	 */
> -	BUG_ON(path[depth].p_ext == NULL && depth != 0);
> +	if (path[depth].p_ext == NULL && depth != 0) {
> +		printk(KERN_ERR
> +		       "EXT4-fs (%s): corrupt extent node ino %lu iblock %d"
> +		       " depth %d pblock %lld\n",
> +		       inode->i_sb->s_id, inode->i_ino, iblock, depth,
> +		       path[depth].p_block);
> +		if (!path[depth].p_hdr)
> +			path[depth].p_hdr = ext_block_hdr(path[depth].p_bh);
> +		printk(KERN_ERR "EXT4-fs (%s): eh_entries %d eh_max %d\n",
> +		       inode->i_sb->s_id, path[depth].p_hdr->eh_entries,
> +		       path[depth].p_hdr->eh_max);
> +		err = -EIO;
> +		goto out2;
> +	}
>  	eh = path[depth].p_hdr;
>  
>  	ex = path[depth].p_ext;

