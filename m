From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] resize2fs: fix ENOSPC corruption case
Date: Wed, 20 May 2009 10:57:05 -0500
Message-ID: <4A142851.6000807@redhat.com>
References: <4A11D375.30709@redhat.com> <20090520113748.GC24836@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54001 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761AbZETP5H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 May 2009 11:57:07 -0400
In-Reply-To: <20090520113748.GC24836@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Mon, May 18, 2009 at 04:30:29PM -0500, Eric Sandeen wrote:
>> Index: e2fsprogs/lib/ext2fs/extent.c
>> ===================================================================
>> --- e2fsprogs.orig/lib/ext2fs/extent.c
>> +++ e2fsprogs/lib/ext2fs/extent.c
>> @@ -1068,16 +1068,17 @@ errcode_t ext2fs_extent_insert(ext2_exte
>>  
>>  	retval = ext2fs_extent_replace(handle, 0, extent);
>>  	if (retval)
>> -		goto errout;
>> +		goto errout_delete;
>>  
>>  	retval = update_path(handle);
>>  	if (retval)
>> -		goto errout;
>> +		goto errout_delete;
>>  
>>  	return 0;
>>  
>> -errout:
>> +errout_delete:
>>  	ext2fs_extent_delete(handle, 0);
>> +errout:
>>  	return retval;
>>  }
> 
> 
> Instead adding an errout_delete and changing what errout means, why
> not just change:
> 
> 			retval = extent_node_split(handle);
> 			if (retval)
> -				goto errout;
> +				return retval;
> 			path = handle->path + handle->level;

I guess there are other earlier direct returns, so sure, that'd be fine.

> I also took a quick scan of extent_node_split(), and I'm not 100%
> convinced it handles all of its error cases sanely.  But that should
> be the focus of a different patch....

yeah, it probably needs more careful inspection.  Who wrote that thing
anyway ... ;)

> 
>> @@ -1239,16 +1240,17 @@ again:
>>  #ifdef DEBUG
>>  		printf("(re/un)mapping last block in extent\n");
>>  #endif
>> -		extent.e_len--;
>> -		retval = ext2fs_extent_replace(handle, 0, &extent);
>> -		if (retval)
>> -			goto done;
>> +		/* Make sure insert works before replacing old extent */
>>  		if (physical) {
>>  			retval = ext2fs_extent_insert(handle,
>>  					EXT2_EXTENT_INSERT_AFTER, &newextent);
>>  			if (retval)
>>  				goto done;
>>  		}
>> +		extent.e_len--;
>> +		retval = ext2fs_extent_replace(handle, 0, &extent);
>> +		if (retval)
>> +			goto done;
>>  	} else if (logical == extent.e_lblk) {
> 
> Have you tested this by hand, using the tst_extents test progam?  

No, but I should.

> Code
> inspection says that ext2fs_extent_insert leaves extent handle
> pointing at the same place, but I admit the semantics need to be
> better documented and tested to make sure they are correct in all
> situations.  The extent code is new enough and tricky enough that I'm
> always cautious about changes to it.

yep, this likely needs more work to document the semantics, make sure
they're consistent, and check all those error cases.

For F11 I will likely put in the later 2 patches, to fix up the minimum
size reporting and then enforce that as the minimum size, so we
shouldn't(tm) get into these error paths.  Seems like the safer
last-minute change.

-Eric

> Looks good, though.
> 
> 							- Ted

