From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] jbd/jbd2: add pointer type conversion on void *arg from
 void * to journal_t * explicitly in kjournald/kjournald2
Date: Wed, 03 Aug 2011 10:31:13 +0800
Message-ID: <4E38B2F1.8040903@cn.fujitsu.com>
References: <4E38AB50.9040804@gmail.com> <4E38AC92.4090501@cn.fujitsu.com> <4E38AFC2.3070608@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Wang Sheng-Hui <shhuiw@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50972 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753836Ab1HCCbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Aug 2011 22:31:09 -0400
In-Reply-To: <4E38AFC2.3070608@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Wang Sheng-Hui wrote:
> On 2011=E5=B9=B408=E6=9C=8803=E6=97=A5 10:04, Li Zefan wrote:
>> 09:58, Wang Sheng-Hui wrote:
>>> The patch is against 3.0
>>>
>>> The arg of kjournald/kjournald2 is void *, and points to type
>>> journal_t. We should convert it to journal_t * explicitly in
>>> the kjournald/kjournald2 function body.
>>>
>>
>> Why?
>>
>> Implicit convertion from void * to foo * is ok. Did the compiler
>> complain about this to you?
>=20
> I remember any * can be assigned directly to void * in ANSI C, but
> void * should be converted to specific point * type. Right?
>=20

No.

> And I checked the code of kswapd, in which explicitly conversion is
> taken on the arg *. I think it should do so in journal.c too.
>=20

Please check more similar code.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
