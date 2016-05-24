From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v3] direct-io: fix direct write stale data exposure from concurrent buffered read
Date: Tue, 24 May 2016 12:41:13 -0400
Message-ID: <x49iny31k9i.fsf@segfault.boston.devel.redhat.com>
References: <1463156728-13357-1-git-send-email-guaneryu@gmail.com>
	<x49h9e1991u.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Eryu Guan <guaneryu@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755636AbcEXQlQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2016 12:41:16 -0400
In-Reply-To: <x49h9e1991u.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Fri, 13 May 2016 13:12:13 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jeff Moyer <jmoyer@redhat.com> writes:

> Eryu Guan <guaneryu@gmail.com> writes:
>
>> What we should really do is to disable block allocation for writes that
>> could result in filling holes inside i_size.
>>
>> Reviewed-by: Jan Kara <jack@suse.cz>
>> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
>
> This looks good to me, Eryu, and it passes the aio/dio test cases in
> xfstests and libaio.  Thanks a lot!
>
> Al, can you take this through your tree?

No response from Al.  Andrew, would you mind grabbing this?

Thanks,
Jeff

> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
>
>
>> ---
>>
>> v3:
>> - Kill unnecessary cleanup patch
>> - Update comments a bit accordingly
>>
>> v2:
>> - Fix the case Jeff pointed out as well
>> - Update commit log
>>
>>  fs/direct-io.c | 14 +++++++-------
>>  1 file changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/direct-io.c b/fs/direct-io.c
>> index 4720377..62921ce 100644
>> --- a/fs/direct-io.c
>> +++ b/fs/direct-io.c
>> @@ -627,11 +627,11 @@ static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
>>  		map_bh->b_size = fs_count << i_blkbits;
>>  
>>  		/*
>> -		 * For writes inside i_size on a DIO_SKIP_HOLES filesystem we
>> -		 * forbid block creations: only overwrites are permitted.
>> -		 * We will return early to the caller once we see an
>> -		 * unmapped buffer head returned, and the caller will fall
>> -		 * back to buffered I/O.
>> +		 * For writes that could fill holes inside i_size on a
>> +		 * DIO_SKIP_HOLES filesystem we forbid block creations: only
>> +		 * overwrites are permitted. We will return early to the caller
>> +		 * once we see an unmapped buffer head returned, and the caller
>> +		 * will fall back to buffered I/O.
>>  		 *
>>  		 * Otherwise the decision is left to the get_blocks method,
>>  		 * which may decide to handle it or also return an unmapped
>> @@ -639,8 +639,8 @@ static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
>>  		 */
>>  		create = dio->rw & WRITE;
>>  		if (dio->flags & DIO_SKIP_HOLES) {
>> -			if (sdio->block_in_file < (i_size_read(dio->inode) >>
>> -							sdio->blkbits))
>> +			if (fs_startblk <= ((i_size_read(dio->inode) - 1) >>
>> +							i_blkbits))
>>  				create = 0;
>>  		}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
