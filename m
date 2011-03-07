From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH V2] ext3: Always set dx_node's fake_dirent explicitly.
Date: Mon, 07 Mar 2011 10:32:21 -0600
Message-ID: <4D750895.4080503@redhat.com>
References: <4D71615D.30306@redhat.com> <4D7161D8.8010509@redhat.com> <20110307162647.GB3663@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Lachlan McIlroy <lmcilroy@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab1CGQcZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Mar 2011 11:32:25 -0500
In-Reply-To: <20110307162647.GB3663@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/7/11 10:26 AM, Jan Kara wrote:
> On Fri 04-03-11 16:04:08, Eric Sandeen wrote:
>> (crossport of 1f7bebb9e911d870fa8f997ddff838e82b5715ea
>> by Andreas Schlick <schlick@lavabit.com>)
>>
>> When ext3_dx_add_entry() has to split an index node, it has to ensure that
>> name_len of dx_node's fake_dirent is also zero, because otherwise e2fsck
>> won't recognise it as an intermediate htree node and consider the htree to
>> be corrupted.
>>     
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>   Thanks. Merged - and added CC to stable@kernel.org as Andreas suggested.

Thanks!

-Eric

>> While it's a simple one liner, this took me forever to (re-)find.
>   I feel with you :).
> 
> 								Honza
>>
>> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
>> index b27ba71..75c968e 100644
>> --- a/fs/ext3/namei.c
>> +++ b/fs/ext3/namei.c
>> @@ -1540,8 +1540,8 @@ static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
>>  			goto cleanup;
>>  		node2 = (struct dx_node *)(bh2->b_data);
>>  		entries2 = node2->entries;
>> +		memset(&node2->fake, 0, sizeof(struct fake_dirent));
>>  		node2->fake.rec_len = ext3_rec_len_to_disk(sb->s_blocksize);
>> -		node2->fake.inode = 0;
>>  		BUFFER_TRACE(frame->bh, "get_write_access");
>>  		err = ext3_journal_get_write_access(handle, frame->bh);
>>  		if (err)

