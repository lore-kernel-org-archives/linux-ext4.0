From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: fix ENOSPC corruption case
Date: Wed, 20 May 2009 07:37:48 -0400
Message-ID: <20090520113748.GC24836@mit.edu>
References: <4A11D375.30709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48609 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761AbZETLht (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 May 2009 07:37:49 -0400
Content-Disposition: inline
In-Reply-To: <4A11D375.30709@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 18, 2009 at 04:30:29PM -0500, Eric Sandeen wrote:
> 
> Index: e2fsprogs/lib/ext2fs/extent.c
> ===================================================================
> --- e2fsprogs.orig/lib/ext2fs/extent.c
> +++ e2fsprogs/lib/ext2fs/extent.c
> @@ -1068,16 +1068,17 @@ errcode_t ext2fs_extent_insert(ext2_exte
>  
>  	retval = ext2fs_extent_replace(handle, 0, extent);
>  	if (retval)
> -		goto errout;
> +		goto errout_delete;
>  
>  	retval = update_path(handle);
>  	if (retval)
> -		goto errout;
> +		goto errout_delete;
>  
>  	return 0;
>  
> -errout:
> +errout_delete:
>  	ext2fs_extent_delete(handle, 0);
> +errout:
>  	return retval;
>  }


Instead adding an errout_delete and changing what errout means, why
not just change:

			retval = extent_node_split(handle);
			if (retval)
-				goto errout;
+				return retval;
			path = handle->path + handle->level;

I also took a quick scan of extent_node_split(), and I'm not 100%
convinced it handles all of its error cases sanely.  But that should
be the focus of a different patch....


> @@ -1239,16 +1240,17 @@ again:
>  #ifdef DEBUG
>  		printf("(re/un)mapping last block in extent\n");
>  #endif
> -		extent.e_len--;
> -		retval = ext2fs_extent_replace(handle, 0, &extent);
> -		if (retval)
> -			goto done;
> +		/* Make sure insert works before replacing old extent */
>  		if (physical) {
>  			retval = ext2fs_extent_insert(handle,
>  					EXT2_EXTENT_INSERT_AFTER, &newextent);
>  			if (retval)
>  				goto done;
>  		}
> +		extent.e_len--;
> +		retval = ext2fs_extent_replace(handle, 0, &extent);
> +		if (retval)
> +			goto done;
>  	} else if (logical == extent.e_lblk) {

Have you tested this by hand, using the tst_extents test progam?  Code
inspection says that ext2fs_extent_insert leaves extent handle
pointing at the same place, but I admit the semantics need to be
better documented and tested to make sure they are correct in all
situations.  The extent code is new enough and tricky enough that I'm
always cautious about changes to it.

Looks good, though.

							- Ted
