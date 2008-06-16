From: Shen Feng <shen@cn.fujitsu.com>
Subject: Re: [PATCH -v2] ext4: Use inode preallocation with -o noextents
Date: Mon, 16 Jun 2008 11:41:38 +0800
Message-ID: <4855E0F2.9070207@cn.fujitsu.com>
References: <1211229262-11012-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>	 <20080604022356.GA7094@mit.edu> <20080604040101.GA22348@skywalker>	 <20080605032220.GC10488@mit.edu>  <20080605084329.GB8942@skywalker> <1212677741.3645.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59827 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbYFPDpN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Jun 2008 23:45:13 -0400
In-Reply-To: <1212677741.3645.44.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Mingming Cao Wrote:
> On Thu, 2008-06-05 at 14:13 +0530, Aneesh Kumar K.V wrote:
>> On Wed, Jun 04, 2008 at 11:22:20PM -0400, Theodore Tso wrote:
>>> when I moved this patch to the beginning of the unstable patch queue,
>>> it didn't apply.  When I tried to look at it, my head started
>>> spinning.  The patch applied to the wrong function, apparently,
>>> because there is so much code duplication "patch" got confused.  I
>>> can't blame it, though, because *I* got confused.  
>>>

...snip...

>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index 09922ae..a810a21 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -4048,7 +4048,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
>>  	sbi = EXT4_SB(sb);
>>
>>  	if (!test_opt(sb, MBALLOC)) {
>> -		block = ext4_new_blocks_old(handle, ar->inode, ar->goal,
>> +		block = ext4_orlov_new_blocks(handle, ar->inode, ar->goal,
>>  					    &(ar->len), errp);
>>  		return block;
>>  	}
> 
> when we get to ext4_mb_new_blocks, don't we already tested MBALLOC is
> turned on?
> 

ext4_ext_get_blocks calls ext4_mb_new_blocks. So we have to check this.
So maybe ext4_ext_get_blocks should call ext4_new_blocks and 
we can remove this check.

-Shen Feng

