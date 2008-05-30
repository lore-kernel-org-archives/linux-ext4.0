From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH e2fsprogs] delete unused nodes in ext2fs_extent_delete
Date: Thu, 29 May 2008 20:11:47 -0500
Message-ID: <483F5453.5060400@redhat.com>
References: <48333F05.6080608@redhat.com> <20080529222401.GA19617@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333AbYE3BLu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 May 2008 21:11:50 -0400
In-Reply-To: <20080529222401.GA19617@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Tue, May 20, 2008 at 04:13:41PM -0500, Eric Sandeen wrote:
>> This patch causes ext2fs_extent_delete to remove an
>> extent node if the last record in it has been deleted.
> 
> I needed to apply this fix on top of your patch; otherwise, when
> deleting the last extent in the root node, the current extent pointer
> is left pointing at an invalid extent.

Looks good, sorry for missing that!

-Eric

> 					- Ted
> 
> diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
> index c3863b5..19d7feb 100644
> --- a/lib/ext2fs/extent.c
> +++ b/lib/ext2fs/extent.c
> @@ -1225,11 +1225,11 @@ errcode_t ext2fs_extent_delete(ext2_extent_handle_t handle, int flags)
>  		ix--;
>  		path->curr = ix;
>  	}
> -	path->entries--;
> -	/* if non-root node has no entries left, remove it & parent ptr to it */
> -	if (path->entries == 0 && handle->level) {
> +	if (--path->entries == 0)
>  		path->curr = 0;
>  
> +	/* if non-root node has no entries left, remove it & parent ptr to it */
> +	if (path->entries == 0 && handle->level) {
>  		if (!(flags & EXT2_EXTENT_DELETE_KEEP_EMPTY)) {
>  			struct ext2fs_extent	extent;
>  
> @@ -1251,7 +1251,6 @@ errcode_t ext2fs_extent_delete(ext2_extent_handle_t handle, int flags)
>  
>  		retval = update_path(handle);
>  	}
> -
>  	return retval;
>  }
>  

