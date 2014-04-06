From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: Re: [PATCH] fs/ext4/extents_status.c: fix 64-bit number truncation
 bug
Date: Mon, 07 Apr 2014 07:58:14 +0800
Message-ID: <5341EA16.6030705@gmail.com>
References: <53396AC1.10108@gmail.com> <CAMuHMdVT9O8C0fhMbaqS2nB1jfLAZtanp6YGPU6Q-T5b7=n20Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Guan Xuetao <gxt@mprc.pku.edu.cn>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:47248 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608AbaDFX6X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Apr 2014 19:58:23 -0400
In-Reply-To: <CAMuHMdVT9O8C0fhMbaqS2nB1jfLAZtanp6YGPU6Q-T5b7=n20Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On 04/06/2014 09:39 PM, Geert Uytterhoeven wrote:
> On Mon, Mar 31, 2014 at 3:16 PM, Chen Gang <gang.chen.5i5j@gmail.com>=
 wrote:
>> '0x7FDEADBEEF' will be truncated to 32-bit number under unicore32. N=
eed
>> append 'ULL' for it.
>>
>> The related warning (with allmodconfig under unicore32):
>>
>>     CC [M]  fs/ext4/extents_status.o
>>   fs/ext4/extents_status.c: In function =E2=80=98__es_remove_extent=E2=
=80=99:
>>   fs/ext4/extents_status.c:813: warning: integer constant is too lar=
ge for =E2=80=98long=E2=80=99 type
>=20
> Thanks! This is failing on all 32-bit architectures.
>=20

Yeah.

>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>=20
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
[...]

Thank you very much!

I will/should continue, and try to finish unicore32 within this month
(although, excuse me, in this week and next week, I will have no much
free time on open source).


Thanks.
--=20
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
