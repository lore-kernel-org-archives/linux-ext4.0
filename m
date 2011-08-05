From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/4] fs/ext3/balloc.c: delete useless initialization
Date: Fri, 05 Aug 2011 12:24:45 -0500
Message-ID: <4E3C275D.1030307@redhat.com>
References: <1312453774-23333-1-git-send-email-julia@diku.dk> <1312453774-23333-2-git-send-email-julia@diku.dk> <20110804104003.GH17196@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Julia Lawall <julia@diku.dk>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab1HERZB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Aug 2011 13:25:01 -0400
In-Reply-To: <20110804104003.GH17196@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/4/11 5:40 AM, Jan Kara wrote:
> On Thu 04-08-11 12:29:31, Julia Lawall wrote:
>> From: Julia Lawall <julia@diku.dk>
>>
>> Delete nontrivial initialization that is immediately overwritten by the
>> result of an allocation function.
>   Thanks. Merged.

Just FWIW, I was curious how this ended up here.

It looks like this has been there since 2005, and both
lines went in in the same commit (i.e. it didn't creep in over time).

http://git.kernel.org/?p=linux/kernel/git/torvalds/old-2.6-bkcvs.git;a=commitdiff;h=a66d457d8878fe8d09bc81f0d5e6ac40caec6eb7

-Eric

> 								Honza
> 
>>
>> The semantic match that makes this change is as follows:
>> (http://coccinelle.lip6.fr/)
>>
>> // <smpl>
>> @@
>> type T;
>> identifier i;
>> expression e;
>> @@
>>
>> (
>> T i = \(0\|NULL\|ERR_PTR(...)\);
>> |
>> -T i = e;
>> +T i;
>> )
>> ... when != i
>> i = \(kzalloc\|kcalloc\|kmalloc\)(...);
>>
>> // </smpl>
>>
>> Signed-off-by: Julia Lawall <julia@diku.dk>
>>
>> ---
>>  fs/ext3/balloc.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff -u -p a/fs/ext3/balloc.c b/fs/ext3/balloc.c
>> --- a/fs/ext3/balloc.c
>> +++ b/fs/ext3/balloc.c
>> @@ -427,7 +427,7 @@ static inline int rsv_is_empty(struct ex
>>  void ext3_init_block_alloc_info(struct inode *inode)
>>  {
>>  	struct ext3_inode_info *ei = EXT3_I(inode);
>> -	struct ext3_block_alloc_info *block_i = ei->i_block_alloc_info;
>> +	struct ext3_block_alloc_info *block_i;
>>  	struct super_block *sb = inode->i_sb;
>>  
>>  	block_i = kmalloc(sizeof(*block_i), GFP_NOFS);
>>

