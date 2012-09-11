From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: do not enable delalloc by default for ext2
Date: Tue, 11 Sep 2012 11:07:46 -0500
Message-ID: <504F61D2.9@redhat.com>
References: <4F71C4B3.9090402@redhat.com> <50002F5A.90908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <esandeen@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>
To: Brian Foster <bfoster@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab2IKQHs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Sep 2012 12:07:48 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8BG7lWc028902
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 11 Sep 2012 12:07:48 -0400
In-Reply-To: <50002F5A.90908@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/13/12 9:23 AM, Brian Foster wrote:
> On 03/27/2012 09:46 AM, Brian Foster wrote:
>> Use traditional ext2 mount options. Do not enable delalloc by default for ext2.
>>
>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>> ---
>>  fs/ext4/super.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 9339009..b08a547 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -3229,7 +3229,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>>  	 * enable delayed allocation by default
>>  	 * Use -o nodelalloc to turn it off
>>  	 */
>> -	if (!IS_EXT3_SB(sb) &&
>> +	if (!IS_EXT3_SB(sb) && !IS_EXT2_SB(sb) &&
>>  	    ((def_mount_opts & EXT4_DEFM_NODELALLOC) == 0))
>>  		set_opt(sb, DELALLOC);
>>  
>>
> 
> Ping... Any comments on this? Thanks.

Ping again?

Ted, this has my reviewed-by, I think it really makes sense to push in to keep ext2 behavior close to the same as it was in ext2.ko.

Thanks,
-Eric

> Brian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

