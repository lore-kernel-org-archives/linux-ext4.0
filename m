From: Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [PATCH 2/2] Ext3: remove a useless check for the function ext3_free_blocks_sb
Date: Mon, 28 Jan 2013 22:01:21 -0800
Message-ID: <510765B1.7000100@gmail.com>
References: <51045F97.9070602@gmail.com> <20130128140757.GB32246@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f50.google.com ([209.85.210.50]:56121 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856Ab3A1O2J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jan 2013 09:28:09 -0500
Received: by mail-da0-f50.google.com with SMTP id h15so1281664dan.9
        for <linux-ext4@vger.kernel.org>; Mon, 28 Jan 2013 06:28:08 -0800 (PST)
In-Reply-To: <20130128140757.GB32246@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=E4=BA=8E 2013-1-28 6:07, Jan Kara =E5=86=99=E9=81=93:
> On Sat 26-01-13 14:58:31, Wang Shilong wrote:
>> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>>
>> Because 'block + count < block' always comes to false, it is useless
>> to have this check, just remove it.
>   As Andreas commented, the test is actually correct. BTW any reason =
why
> you sent the patch three times?
My linux run in the virtual machine..and the clock is wrong...so i send=
 the patch not clarified correctly
in marc.info..when i find it..I correct it, but first time i correct th=
e time as 2012....how stupid it was..:-[
so i send the patch three times...sorry to bother...

BTW =EF=BC=8C may i have a question....
As we know the block to be freed can not be superblock and GDT..
I don't see any check about it in ext2/ext3/ext4....

Thanks,
Wang
>
> 								Honza
>
>> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>> ---
>>  fs/ext3/balloc.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
>> index 22548f5..c557f22 100644
>> --- a/fs/ext3/balloc.c
>> +++ b/fs/ext3/balloc.c
>> @@ -507,7 +507,6 @@ void ext3_free_blocks_sb(handle_t *handle, struc=
t super_block *sb,
>>  	sbi =3D EXT3_SB(sb);
>>  	es =3D sbi->s_es;
>>  	if (block < le32_to_cpu(es->s_first_data_block) ||
>> -	    block + count < block ||
>>  	    block + count > le32_to_cpu(es->s_blocks_count)) {
>>  		ext3_error (sb, "ext3_free_blocks",
>>  			    "Freeing blocks not in datazone - "
>> -- 1.7.11.7
>>

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
