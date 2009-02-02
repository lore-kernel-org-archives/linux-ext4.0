From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH] ext2: Mark the buffer as unmapped before reading the next
	quota block
Date: Mon, 2 Feb 2009 16:35:21 +0530
Message-ID: <ea11fea30902020305n491f2875jeacee32af60dba65@mail.gmail.com>
References: <ea11fea30902020204t7a2db3a7tbf3f0b8d22b20cce@mail.gmail.com>
	 <20090202103429.GB7145@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>,
	cmm@us.ibm.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.190]:63413 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbZBBLFX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Feb 2009 06:05:23 -0500
Received: by ti-out-0910.google.com with SMTP id b6so715863tic.23
        for <linux-ext4@vger.kernel.org>; Mon, 02 Feb 2009 03:05:21 -0800 (PST)
In-Reply-To: <20090202103429.GB7145@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 2, 2009 at 4:04 PM, Jan Kara <jack@suse.cz> wrote:
> On Mon 02-02-09 15:34:27, Manish Katiyar wrote:
>> Hi Jan,
>>
>> This is in continuation with the previous patch
>> (http://patchwork.ozlabs.org/patch/20275/) . We also need to set the
>> buffer as unmapped before reading the next block. I don't think quota
>> files can have holes, but atleast for correctness, otherwise once we
>> have read a block, tmp_bh is always mapped even for holes.
>>
>>
>> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
>> ---
>>  fs/ext2/super.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
>> index da8bdea..b4e7633 100644
>> --- a/fs/ext2/super.c
>> +++ b/fs/ext2/super.c
>> @@ -1328,6 +1328,7 @@ static ssize_t ext2_quota_read(struct
>> super_block *sb, int type, char *data,
>>                               sb->s_blocksize - offset : toread;
>>
>>               tmp_bh.b_state = 0;
>> +             clear_buffer_mapped(&tmp_bh);
>  I don't get this. When b_state is 0, then in particuler the buffer is not
> mapped. So why clear the mapped bit explicitely?

Sorry for the noise.......my bad :-( !!

Thanks -
Manish

>
>>               err = ext2_get_block(inode, blk, &tmp_bh, 0);
>>               if (err < 0)
>>                       return err;
>
>                                                                        Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
