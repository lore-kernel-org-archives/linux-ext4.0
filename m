From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: recalculate s_blockfile_groups during resize2fs
Date: Sun, 05 May 2013 21:08:14 -0500
Message-ID: <5187108E.5000105@redhat.com>
References: <518426F0.1000103@redhat.com> <1822783755.19193156.1367800576698.JavaMail.root@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Lachlan McIlroy <lmcilroy@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864Ab3EFCIM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 May 2013 22:08:12 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r4628CED031319
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Sun, 5 May 2013 22:08:12 -0400
In-Reply-To: <1822783755.19193156.1367800576698.JavaMail.root@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/5/13 7:36 PM, Lachlan McIlroy wrote:
> ----- Original Message -----
>> s_blockfile_groups is used to limit allocations for non-extent
>> files to block groups with block numbers less than 2^32.
>> However, it's not updated when the filesystem is resized online,
>> so the new groups are unavailable to non-extent files until a remount.
>>
>> Fix this by updating the value in ext4_update_super() at
>> resize time.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
>> index c169477..1357260 100644
>> --- a/fs/ext4/resize.c
>> +++ b/fs/ext4/resize.c
>> @@ -1341,6 +1341,8 @@ static void ext4_update_super(struct super_block *sb,
>>  
>>  	/* Update the global fs size fields */
>>  	sbi->s_groups_count += flex_gd->count;
>> +	sbi->s_blockfile_groups = min_t(ext4_group_t, sbi->s_groups_count,
>> +			(EXT4_MAX_BLOCK_FILE_PHYS / EXT4_BLOCKS_PER_GROUP(sb)));
>>  
>>  	/* Update the reserved block counts only once the new group is
>>  	 * active. */
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> Good catch Eric - this would have prevented the bug in
> ext4_mb_regular_allocator() too.  Looks good to me.

Yep - at least until the filesystem grows > 16TB :)

-Eric

