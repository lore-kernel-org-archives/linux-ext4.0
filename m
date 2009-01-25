From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] : make sure the buffer head members are zeroed out before
 	using them.
Date: Sun, 25 Jan 2009 10:15:58 -0600
Message-ID: <497C903E.5080108@redhat.com>
References: <ea11fea30901200906m4dfb5060ya82104519b4984bb@mail.gmail.com> <ea11fea30901250753j6db5158dj9082d57aa9469685@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
	cmm@us.ibm.com
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42311 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbZAYQQ0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 Jan 2009 11:16:26 -0500
In-Reply-To: <ea11fea30901250753j6db5158dj9082d57aa9469685@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Manish Katiyar wrote:
> On Tue, Jan 20, 2009 at 10:36 PM, Manish Katiyar <mkatiyar@gmail.com> wrote:
>> ext2_quota_read doesn't bzeroes tmp_bh before calling ext2_get_block()
>> where we access the b_size of it. Since it is a local variable it
>> might contain some garbage. Make sure it is filled with zero before
>> passing.
> 
> Hi Ted/mingming,
> 
> Any feedback on this ??

This looks ok to me, Manish.  I'm curious, did you see this fail in real
life, and if so, what'd the failure look like?

With the change, the tmp_bh bh_size is 0, so maxblocks down the
get_block path is also 0, but I guess that works out ok.

-Eric

> Thanks -
> Manish
> 
>> Signed-off-by : Manish Katiyar <mkatiyar@gmail.com>
>> ---
>>  fs/ext2/super.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
>> index da8bdea..d10aa44 100644
>> --- a/fs/ext2/super.c
>> +++ b/fs/ext2/super.c
>> @@ -1327,7 +1327,7 @@ static ssize_t ext2_quota_read(struct
>> super_block *sb, int type, char *data,
>>                tocopy = sb->s_blocksize - offset < toread ?
>>                                sb->s_blocksize - offset : toread;
>>
>> -               tmp_bh.b_state = 0;
>> +               memset(&tmp_bh, 0, sizeof(struct buffer_head));
>>                err = ext2_get_block(inode, blk, &tmp_bh, 0);
>>                if (err < 0)
>>                        return err;
>> @@ -1366,7 +1366,7 @@ static ssize_t ext2_quota_write(struct
>> super_block *sb, int type,
>>                tocopy = sb->s_blocksize - offset < towrite ?
>>                                sb->s_blocksize - offset : towrite;
>>
>> -               tmp_bh.b_state = 0;
>> +               memset(&tmp_bh, 0, sizeof(struct buffer_head));
>>                err = ext2_get_block(inode, blk, &tmp_bh, 1);
>>                if (err < 0)
>>                        goto out;
>> --
>> 1.5.4.3
>>
>>
>> Thanks -
>> Manish
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

