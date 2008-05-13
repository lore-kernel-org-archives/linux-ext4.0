From: Tiger Yang <tiger.yang@oracle.com>
Subject: Re: [PATCH] ext3/4: fix uninitialized bs in ext3/4_xattr_set_handle()
Date: Tue, 13 May 2008 10:31:04 +0800
Message-ID: <4828FD68.40608@oracle.com>
References: <4827B878.50903@oracle.com> <20080512170254.f79fe869.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>,
	stable@kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:51898 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbYEMCjR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 May 2008 22:39:17 -0400
In-Reply-To: <20080512170254.f79fe869.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, Andrew

This situation only happens we format ext3/4 with inode size more than 
128 and we have put xattr entries both in ibody and block.
The consequences about this bug is we will lost the xattr block which 
pointed by i_file_acl with all xattr entires in it. We will alloc a new 
xattr block and put that large value entry in it. The old xattr block 
will become orphan block.

Best regards,
tiger

Andrew Morton wrote:
> On Mon, 12 May 2008 11:24:40 +0800
> Tiger Yang <tiger.yang@oracle.com> wrote:
>
>   
>> I met a bug when I try to replace a xattr entry in ibody with a big size 
>> value. But in ibody there has no space for the new value. So it should 
>> set new xattr entry in block and remove the old xattr entry in ibody.
>>
>> Best regards,
>> tiger
>>
>>
>> [xattr.patch  text/x-patch (1.3KB)]
>> This fix the uninitialized bs when we try to replace a xattr entry in ibody with the new value which require more than free space.
>>
>> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
>>
>> diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
>> index a6ea4d6..e1af9bd 100644
>> --- a/fs/ext3/xattr.c
>> +++ b/fs/ext3/xattr.c
>> @@ -1000,6 +1000,11 @@ ext3_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
>>  			i.value = NULL;
>>  			error = ext3_xattr_block_set(handle, inode, &i, &bs);
>>  		} else if (error == -ENOSPC) {
>> +			if (EXT3_I(inode)->i_file_acl && !bs.s.base) {
>> +				error = ext3_xattr_block_find(inode, &i, &bs);
>> +				if (error)
>> +					goto cleanup;
>> +			}
>>  			error = ext3_xattr_block_set(handle, inode, &i, &bs);
>>  			if (error)
>>  				goto cleanup;
>>     
>
> That sounds fairly bad.
>
> What are the consequences of this bug, when someone hits it?
>
> It appears that we should backport this fix into 2.6.25.x (and perhaps
> earlier).  What do you think?
>
>   
