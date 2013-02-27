From: "gnehzuil.liu" <gnehzuil.liu@gmail.com>
Subject: Re: [GIT PULL] ext4 updates for 3.9
Date: Thu, 28 Feb 2013 01:38:13 +0800
Message-ID: <7BFB2135-A1F0-4B6D-9962-16E75E5560F8@gmail.com>
References: <nsxr4k2kdwv.fsf@closure.thunk.org> <20130227124727.GA225@x4> <20130227153435.GB5609@thunk.org> <20130227154450.GA23402@x4> <20130227170157.GA222@x4> <98C6DE45-F050-4AAD-82E2-7352F5BB0A5D@gmail.com> <20130227172256.GA236@x4>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Jones <davej@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130227172256.GA236@x4>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

=D4=DA 2013-2-28=A3=AC=C9=CF=CE=E71:22=A3=ACMarkus Trippelsdorf <markus=
@trippelsdorf.de> =D0=B4=B5=C0=A3=BA

> On 2013.02.28 at 01:10 +0800, gnehzuil.liu wrote:
>> =D4=DA 2013-2-28=A3=AC=C9=CF=CE=E71:01=A3=ACMarkus Trippelsdorf <mar=
kus@trippelsdorf.de> =D0=B4=B5=C0=A3=BA
>>=20
>>> On 2013.02.27 at 16:44 +0100, Markus Trippelsdorf wrote:
>>>> On 2013.02.27 at 10:34 -0500, Theodore Ts'o wrote:
>>>>> On Wed, Feb 27, 2013 at 01:47:27PM +0100, Markus Trippelsdorf wro=
te:
>>>>>> Just booted todays Linux tree and got the following errors:
>>>>>>=20
>>>>>> ...
>>>>>> Feb 27 13:33:31 x4 kernel: EXT4-fs (sda): mounted filesystem wit=
h ordered data mode. Opts: (null)
>>>>>> ...
>>>>>> Feb 27 13:33:32 x4 kernel: EXT4-fs error (device sda): ext4_find=
_dest_de:1657: inode #70647809: block 14164000: comm cupsd: bad entry i=
n directory: rec_len % 4 !=3D 0 - offset=3D0(0), inode=3D2569822761, re=
c_len=3D3837, name_len=3D1
>>>>>> Feb 27 13:33:32 x4 kernel: EXT4-fs error (device sda): ext4_find=
_dest_de:1657: ignore#70911401: block 15213579: comm pdnsd: bad entry i=
n directory: rec_len % 4 !=3D 0 - offset=3D0(0), inode=3D2000846358, re=
c_len=3D36782, name_len=3D120
>>>>>=20
>>>>> Is this reproducible?=20
>>>=20
>>> The issue is caused by:
>>>=20
>>> commit d100eef2440fea13e4f09e88b1c8bcbca64beb9f
>>> Author: Zheng Liu <wenqing.lz@taobao.com>
>>> Date:   Mon Feb 18 00:29:59 2013 -0500
>>>=20
>>>   ext4: lookup block mapping in extent status tree
>>=20
>> Thanks for the report.  I am very sorry about that.  Now I am trying=
 to fix it.
>>=20
> Thank you.
>=20
> Please note that if I run a kernel build with:=20
> "git reset --hard f7fec032aa782d3fd7e51fbdf08aa3a296c01500"=20
> (the commit before d100eef24) I get a different but similar error:
>=20
>  EXT4-fs (sda): error count: 4
>  EXT4-fs (sda): initial error at 1361983458: ext4_find_dest_de:1657: =
inode 70911401: block 15213579=20
>  EXT4-fs (sda): last error at 1361983663: ext4_find_dest_de:1658: ino=
de 70647809: block 14164000

Yup, thanks for the note.  Could you please revert to this commit a25a4=
e1a5d5dc0f97dddbca44e695c532d8228c1 (the commit before f7fec032)?  I su=
spect that commit f7fec032 is the root cause.  Thanks for your help.

Regards,
                                                - Zheng--
To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
