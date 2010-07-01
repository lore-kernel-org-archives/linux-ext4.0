From: Peter Pan <panweiping3@gmail.com>
Subject: Re: [PATCH] ext2:delete misused ext2_free_blocks
Date: Thu, 01 Jul 2010 09:56:41 +0800
Message-ID: <4C2BF5D9.8040100__35905.7726491757$1277949724$gmane$org@gmail.com>
References: <1277893287-25916-1-git-send-email-wppan@redflag-linux.com> <20100630225754.GT19184@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Dan Carpenter <error27@gmail.com>,
	Peter Pan <wppan@redflag-linux.com>, jack@suse.cz, hch@lst.de,
	viro@zeniv.linux.org.uk, npiggin@suse.de, jblunck@suse.de,
	linux-fsdevel@vger.kernel.
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:38985 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab0GACBg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jun 2010 22:01:36 -0400
In-Reply-To: <20100630225754.GT19184@bicker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/01/2010 06:57 AM, Dan Carpenter wrote:
> On Wed, Jun 30, 2010 at 06:21:27PM +0800, Peter Pan wrote:
>    
>> if ext2_new_blocks returns error, no blocks need to be freed.
>>
>>      
> Hi Peter,
>
> Your patch isn't right.  The original code is OK as is.
>
> Are you seeing a kernel panic?  Perhaps we can help you fix it.
>    
Oh, I know that the original code is good now.
I didn't see a kernel panic, thank you for your guide.
> regards,
> dan carpenter
>
>    
>> Signed-off-by: Peter Pan<wppan@redflag-linux.com>
>> ---
>>   fs/ext2/inode.c |    4 ++--
>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
>> index 3675088..f858847 100644
>> --- a/fs/ext2/inode.c
>> +++ b/fs/ext2/inode.c
>> @@ -385,6 +385,8 @@ static int ext2_alloc_blocks(struct inode *inode,
>>   	ext2_fsblk_t current_block = 0;
>>   	int ret = 0;
>>
>> +	*err = -ENOSPC;
>> +
>>   	/*
>>   	 * Here we try to allocate the requested multiple blocks at once,
>>   	 * on a best-effort basis.
>> @@ -421,8 +423,6 @@ static int ext2_alloc_blocks(struct inode *inode,
>>   	*err = 0;
>>   	return ret;
>>   failed_out:
>> -	for (i = 0; i<index; i++)
>> -		ext2_free_blocks(inode, new_blocks[i], 1);
>>   	return ret;
>>   }
>>
>> -- 
>> 1.6.6
>>      
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>    

Regards

-- 
Peter Pan
Red Flag Software Co.,Ltd

