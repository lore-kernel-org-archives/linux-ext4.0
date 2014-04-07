From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: Re: [PATCH] fs/ext4/extents_status.c: fix 64-bit number truncation
 bug
Date: Mon, 07 Apr 2014 13:00:23 +0800
Message-ID: <534230E7.3040800@gmail.com>
References: <53396AC1.10108@gmail.com> <CAMuHMdVT9O8C0fhMbaqS2nB1jfLAZtanp6YGPU6Q-T5b7=n20Q@mail.gmail.com> <20140407041431.GA8468@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Ts'o <tytso@mit.edu>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Guan Xuetao <gxt@mprc.pku.edu.cn>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140407041431.GA8468@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


On 04/07/2014 12:14 PM, Theodore Ts'o wrote:
> On Sun, Apr 06, 2014 at 03:39:09PM +0200, Geert Uytterhoeven wrote:
>> On Mon, Mar 31, 2014 at 3:16 PM, Chen Gang <gang.chen.5i5j@gmail.com=
> wrote:
>>> '0x7FDEADBEEF' will be truncated to 32-bit number under unicore32. =
Need
>>> append 'ULL' for it.
>>>
>>> The related warning (with allmodconfig under unicore32):
>>>
>>>     CC [M]  fs/ext4/extents_status.o
>>>   fs/ext4/extents_status.c: In function =E2=80=98__es_remove_extent=
=E2=80=99:
>>>   fs/ext4/extents_status.c:813: warning: integer constant is too la=
rge for =E2=80=98long=E2=80=99 type
>>
>> Thanks! This is failing on all 32-bit architectures.
>=20
> Yes, it's harmless (since we don't actually check the value anywhere;
> this is just so humans could easily spot bugs when debugging), but
> I'll make sure this gets queued for 3.15 fixes in the ext4 tree.
>=20
> Thanks!!
>=20

OK, thanks. Also thank for the related Application usage information.

Next, in open source, welcome to provide related Application usage
information, when review my patches. It will be useful to evaluate my
contributions (at least, it can let myself more clearer).

It will also be useful to me (in fact, for most of my patches, I am not
familiar with the related Application's usage case).


Thanks.
--=20
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
