From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: [PATCH] fix file system corruption [ was Re: mballoc errors ]
Date: Tue, 01 Apr 2008 10:38:50 +0200
Message-ID: <47F1F49A.7020102@bull.net>
References: <47EAC302.5040109@redhat.com> <47ECFAC7.3050404@bull.net> <20080331065802.GA19456@skywalker> <47F0FBFE.7060404@bull.net> <20080331201819.GA30646@skywalker> <20080331205030.GB30646@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:52274 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbYDAIib (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Apr 2008 04:38:31 -0400
In-Reply-To: <20080331205030.GB30646@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> I found one case where it could fail. We are returning total extent size
> in case of converting from uninitialized extent to initialized one. 
> Now if we have the below layout
> 
> [p --------x--------]
> 
> where p is the start block and x is the location where we intent to
> write. If converting the above uninit extent resulted in 
> 
> [p zeroed-out][uninit].
> 
> We should not be returning the size of
> zeroed-out-extent. That is because in ext4_ext_get_blocks we cache
> the extent information as below
> 
> out_new:
> 		....
> /* Cache only when it is _not_ an uninitialized extent */
> if (create != EXT4_CREATE_UNINITIALIZED_EXT)
> 	ext4_ext_put_in_cache(inode, iblock, allocated, newblock,
> 						EXT4_EXT_CACHE_EXTENT);
> out:
> 
> 
> That would mean we are caching an extent starting from newblock of
> size allocated where allocated would be the size of zeroout extent,
> which is actually wrong.
> 
> I am yet to test the patch. If you have time can you test the below
> change

Hi Aneesh,
I tested your patch but unfortunately I still reproduced the problem with it:
EXT4-fs error (device sdc1): ext4_valid_block_bitmap: Invalid block bitmap - 
block_group = 6233, block = 51060737

Is there another thing I could do to help debugging the problem?
   Valerie

> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 964d2c1..91f8f72 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2264,7 +2264,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  		ex->ee_len   = orig_ex.ee_len;
>  		ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
>  		ext4_ext_dirty(handle, inode, path + depth);
> -		return le16_to_cpu(ex->ee_len);
> +		/* zeroed the full extent */
> +		return allocated;
>  	}
>  
>  	/* ex1: ee_block to iblock - 1 : uninitialized */
> @@ -2309,11 +2310,13 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  				ex->ee_len   = orig_ex.ee_len;
>  				ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
>  				ext4_ext_dirty(handle, inode, path + depth);
> -				return le16_to_cpu(ex->ee_len);
> +				/* zeroed the full extent */
> +				return allocated;
>  
>  			} else if (err)
>  				goto fix_extent_len;
>  
> +			/* zeroed the second half */
>  			return allocated;
>  		}
>  		ex3 = &newex;
> @@ -2331,7 +2334,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  			ex->ee_len   = orig_ex.ee_len;
>  			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
>  			ext4_ext_dirty(handle, inode, path + depth);
> -			return le16_to_cpu(ex->ee_len);
> +			/* zeroed the full extent */
> +			return allocated;
>  
>  		} else if (err)
>  			goto fix_extent_len;
> @@ -2379,7 +2383,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  			ex->ee_len   = orig_ex.ee_len;
>  			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
>  			ext4_ext_dirty(handle, inode, path + depth);
> -			return le16_to_cpu(ex->ee_len);
> +			/* zero out the first half */
> +			return allocated;
>  		}
>  	}
>  	/*
> @@ -2446,7 +2451,8 @@ insert:
>  		ex->ee_len   = orig_ex.ee_len;
>  		ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
>  		ext4_ext_dirty(handle, inode, path + depth);
> -		return le16_to_cpu(ex->ee_len);
> +		/* zero out the first half */
> +		return allocated;
>  	} else if (err)
>  		goto fix_extent_len;
>  out:
> 
> 

