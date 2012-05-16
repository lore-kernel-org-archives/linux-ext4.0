From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] ext4: Protect group inode free counting with group lock.
Date: Wed, 16 May 2012 23:10:16 +0800
Message-ID: <4FB3C358.7010806@tao.ma>
References: <1337158192-4591-1-git-send-email-tm@tao.ma> <67D3F8EA-D06F-4691-A1E0-CA519CF581C5@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:53884 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752746Ab2EPPK3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 May 2012 11:10:29 -0400
In-Reply-To: <67D3F8EA-D06F-4691-A1E0-CA519CF581C5@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/16/2012 10:58 PM, Andreas Dilger wrote:
> On 2012-05-16, at 2:49 AM, Tao Ma wrote:
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> Now when we set the group inode free count, we don't have a proper
>> group lock so that multiple threads may decrease the inode free
>> count at the same time. And e2fsck will complain something like:
>>
>> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
>> index 409c2ee..25595e2 100644
>> --- a/fs/ext4/ialloc.c
>> +++ b/fs/ext4/ialloc.c
>> @@ -772,7 +772,9 @@ got:
>> 			ext4_itable_unused_set(sb, gdp,
>> 					(EXT4_INODES_PER_GROUP(sb) - ino));
>> 		up_read(&grp->alloc_sem);
>> -	}
>> +	} else
>> +		ext4_lock_group(sb, group);
> 
> Minor coding style fix - when one half of if/else is using braces
> then the other half should also use braces, like:
> 
> 	if {
> 		:
> 	} else {
> 		:
> 	}
thank you Andreas, and I will change it in the next version.

Thanks
Tao
> 
>> +
>> 	ext4_free_inodes_set(sb, gdp, ext4_free_inodes_count(sb, gdp) - 1);
>> 	if (S_ISDIR(mode)) {
>> 		ext4_used_dirs_set(sb, gdp, ext4_used_dirs_count(sb, gdp) + 1);
>> @@ -782,10 +784,9 @@ got:
>> 			atomic_inc(&sbi->s_flex_groups[f].used_dirs);
>> 		}
>> 	}
>> -	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
>> +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
>> 		gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
>> -		ext4_unlock_group(sb, group);
>> -	}
>> +	ext4_unlock_group(sb, group);
>>
>> 	BUFFER_TRACE(inode_bitmap_bh, "call ext4_handle_dirty_metadata");
>> 	err = ext4_handle_dirty_metadata(handle, NULL, inode_bitmap_bh);
>> -- 
>> 1.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

