From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: Re: [PATCH] jbd/jbd2: add pointer type conversion on void *arg from
 void * to journal_t * explicitly in kjournald/kjournald2
Date: Wed, 03 Aug 2011 10:55:57 +0800
Message-ID: <4E38B8BD.10406@gmail.com>
References: <4E38AB50.9040804@gmail.com>	<4E38AC92.4090501@cn.fujitsu.com>	<4E38AFC2.3070608@gmail.com> <CAM_iQpXJSDvHXtGFET7SgQTXUpk-v+hD24RzSR-sanf=4oY1xA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Li Zefan <lizf@cn.fujitsu.com>, Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:61510 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab1HCC4S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Aug 2011 22:56:18 -0400
In-Reply-To: <CAM_iQpXJSDvHXtGFET7SgQTXUpk-v+hD24RzSR-sanf=4oY1xA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011=E5=B9=B408=E6=9C=8803=E6=97=A5 10:52, Am=C3=A9rico Wang wrote:
> On Wed, Aug 3, 2011 at 10:17 AM, Wang Sheng-Hui <shhuiw@gmail.com> wr=
ote:
>>
>> I remember any * can be assigned directly to void * in ANSI C, but
>> void * should be converted to specific point * type. Right?
>>
>=20
> C99 6.3.2.3

Got it. Thanks,

>=20
> A pointer to void may be converted to or from a pointer to any
> incomplete or object
> type. A pointer to any incomplete or object type may be converted to =
a
> pointer to void
> and back again; the result shall compare equal to the original pointe=
r.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
