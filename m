From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: clean up ext2fs_bg_flags_ interfaces
Date: Wed, 09 Sep 2009 14:26:39 -0500
Message-ID: <4AA8016F.1050600@redhat.com>
References: <4AA7FC13.6060109@redhat.com> <8893.1252523964@alphaville.usa.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: nicholas.dokos@hp.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbZIIT0l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Sep 2009 15:26:41 -0400
In-Reply-To: <8893.1252523964@alphaville.usa.hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nick Dokos wrote:
>> ...  				}
>> diff --git a/e2fsck/super.c b/e2fsck/super.c
>> index 409d472..b8eee6b 100644
>> --- a/e2fsck/super.c
>> +++ b/e2fsck/super.c
>> @@ -637,8 +637,8 @@ void check_super_block(e2fsck_t ctx)
>>  		should_be = 0;
>>  		if (!ext2fs_group_desc_csum_verify(fs, i)) {
>>  			if (fix_problem(ctx, PR_0_GDT_CSUM, &pctx)) {
>> -				ext2fs_bg_flag_clear (fs, i, EXT2_BG_BLOCK_UNINIT);
>> -				ext2fs_bg_flag_clear (fs, i, EXT2_BG_INODE_UNINIT);
>> +				ext2fs_bg_flags_clear(fs, i, EXT2_BG_BLOCK_UNINIT);
>> +				ext2fs_bg_flags_clear(fs, i, EXT2_BG_INODE_UNINIT);
>>  				ext2fs_bg_itable_unused_set(fs, i, 0);
>>  				should_be = 1;
>>  			}
> 
> Wouldn't something like this be better? There are a few places where this
> could be done:

thought about that, but it goes over 80cols and only a couple places, 
*shrug*

-Eric

> 
>> -				ext2fs_bg_flag_clear (fs, i, EXT2_BG_BLOCK_UNINIT);
>> -				ext2fs_bg_flag_clear (fs, i, EXT2_BG_INODE_UNINIT);
>> +				ext2fs_bg_flags_clear(fs, i, EXT2_BG_BLOCK_UNINIT | EXT2_BG_INODE_UNINIT);
> 
> 
> Thanks,
> Nick

