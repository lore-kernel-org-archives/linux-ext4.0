From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: Re: [PATCH] jbd/jbd2: add pointer type conversion on void *arg from
 void * to journal_t * explicitly in kjournald/kjournald2
Date: Wed, 03 Aug 2011 10:17:38 +0800
Message-ID: <4E38AFC2.3070608@gmail.com>
References: <4E38AB50.9040804@gmail.com> <4E38AC92.4090501@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47066 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab1HCCSC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Aug 2011 22:18:02 -0400
In-Reply-To: <4E38AC92.4090501@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011=E5=B9=B408=E6=9C=8803=E6=97=A5 10:04, Li Zefan wrote:
> 09:58, Wang Sheng-Hui wrote:
>> The patch is against 3.0
>>
>> The arg of kjournald/kjournald2 is void *, and points to type
>> journal_t. We should convert it to journal_t * explicitly in
>> the kjournald/kjournald2 function body.
>>
>=20
> Why?
>=20
> Implicit convertion from void * to foo * is ok. Did the compiler
> complain about this to you?

I remember any * can be assigned directly to void * in ANSI C, but
void * should be converted to specific point * type. Right?

And I checked the code of kswapd, in which explicitly conversion is
taken on the arg *. I think it should do so in journal.c too.

>=20
>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
>> ---
>>  fs/jbd/journal.c  |    2 +-
>>  fs/jbd2/journal.c |    2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
>> index e2d4285..32956fd 100644
>> --- a/fs/jbd/journal.c
>> +++ b/fs/jbd/journal.c
>> @@ -116,7 +116,7 @@ static void commit_timeout(unsigned long __data)
>> =20
>>  static int kjournald(void *arg)
>>  {
>> -	journal_t *journal =3D arg;
>> +	journal_t *journal =3D (journal_t *)arg;
>>  	transaction_t *transaction;
>> =20
>>  	/*
>> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
>> index 0dfa5b5..c4f4bfc 100644
>> --- a/fs/jbd2/journal.c
>> +++ b/fs/jbd2/journal.c
>> @@ -129,7 +129,7 @@ static void commit_timeout(unsigned long __data)
>> =20
>>  static int kjournald2(void *arg)
>>  {
>> -	journal_t *journal =3D arg;
>> +	journal_t *journal =3D (journal_t *)arg;
>>  	transaction_t *transaction;
>> =20
>>  	/*

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
