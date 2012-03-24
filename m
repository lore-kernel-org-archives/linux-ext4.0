From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] ext2: Don't export ext2_mask_flags() to user space
Date: Sat, 24 Mar 2012 02:51:35 -0400
Message-ID: <CAMjpGUcqSSSVy1MSRa_41UkKWc4VOn2yetxLOa=RbE0L7YGHYg@mail.gmail.com>
References: <1332366608-2695-1-git-send-email-thierry.reding@avionic-design.de>
 <20120321222357.GB24330@quack.suse.cz> <20120321231651.GC32041@thunk.org>
 <20120322055354.GA3942@avionic-0098.mockup.avionic-design.de>
 <1332396053.3058.2.camel@koala> <20120322162825.GA4028@thunk.org>
 <20120322173150.GY6589@ZenIV.linux.org.uk> <43D088FE-7FB5-4C9F-A4FF-2B01DB392F43@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	ThierryReding <thierry.reding@avionic-design.de>,
	Jan Kara <jack@suse.cz>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <43D088FE-7FB5-4C9F-A4FF-2B01DB392F43@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Mar 22, 2012 at 20:25, Andreas Dilger wrote:
> On 2012-03-22, at 11:31, Al Viro wrote:
>> On Thu, Mar 22, 2012 at 12:28:25PM -0400, Ted Ts'o wrote:
>>> Even if they're not iwlling to use libext2fs (for space reasons, I
>>> would assume? =C2=A0It can't be because of license compatibility is=
sues
>>> since they are both GPLv2), they could just simply grab the ext2_fs=
=2Eh
>>> from e2fsprogs. =C2=A0That has all of the file system definitions f=
or ext2,
>>> ext3, and ext4.
>>
>> Ho-hum... =C2=A0Then we could kill a lot of lines in include/linux/e=
xt2_fs.h.
>> I wonder how much of what remains has any business being outside of
>> fs/ext2, actually - AFAICS, there are very few places that might pos=
sibly
>> care:
>>
>> arch/blackfin/kernel/setup.c:595: =C2=A0 =C2=A0 =C2=A0 if (*((unsign=
ed short *)(mtd_phys + 0x438)) =3D=3D EXT2_SUPER_MAGIC)
>> fs/nfsd/nfs3proc.c:599: =C2=A0 =C2=A0 =C2=A0 =C2=A0 case EXT2_SUPER_=
MAGIC:
>> fs/nfsd/nfs3proc.c:600: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 resp->p_link_max =3D EXT2_LINK_MAX;
>> fs/nfsd/nfs3proc.c:601: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 resp->p_name_max =3D EXT2_NAME_LEN;
>
> These don't really make sense to be using ext2 constants.

i'm guessing your quoting is over zealous and you're not actually
talking about the Blackfin code here ... just the nfsd code
-mike
