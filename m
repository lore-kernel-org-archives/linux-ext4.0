From: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Subject: Re: [PATCH 12/19] libext2fs: Bump default number of reserved inodes to 64
Date: Fri, 7 Aug 2015 21:11:55 +0300
Message-ID: <5DA1BF3A-32DC-4969-9C22-DF3DD3CDC89B@gmail.com>
References: <1438944689-24562-1-git-send-email-jack@suse.com> <1438944689-24562-13-git-send-email-jack@suse.com> <B63A9BEE-3A2D-4FD3-93E1-AE9C1F9F506C@gmail.com> <20150807110333.GA24829@quack.suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34357 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945911AbbHGSME convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Aug 2015 14:12:04 -0400
Received: by pawu10 with SMTP id u10so93707469paw.1
        for <linux-ext4@vger.kernel.org>; Fri, 07 Aug 2015 11:12:02 -0700 (PDT)
In-Reply-To: <20150807110333.GA24829@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It=E2=80=99s correct - i mean about it.=20
Same define may used on ext4 code to verify inode number correctness.=20


> On Aug 7, 2015, at 2:03 PM, Jan Kara <jack@suse.cz> wrote:
>=20
> On Fri 07-08-15 13:58:22, Alexey Lyashkov wrote:
>> May you don=E2=80=99t use a magic constants in code? It hard to main=
tain latter.
>=20
> I guess you mean the default number of reserved inodes. Yes, I guess =
I can
> create a define for that...
>=20
> 								Honza
>=20
>>> On Aug 7, 2015, at 1:51 PM, Jan Kara <jack@suse.com> wrote:
>>>=20
>>> From: Jan Kara <jack@suse.cz>
>>>=20
>>> We ran out of reserved inodes so bump the default number of reserve=
d
>>> inodes to 64 to get some breathing space. Otherwise we have to do a=
 full
>>> fs scan when increasing number of reserved inodes when some feature
>>> needing another reserved inode is enabled. This consumes 13.5 KB on=
 a
>>> filesystem which is negligible these days.
>>>=20
>>> Signed-off-by: Jan Kara <jack@suse.cz>
>>> ---
>>> lib/ext2fs/initialize.c | 2 +-
>>> misc/mke2fs.8.in        | 8 ++++----
>>> misc/mke2fs.conf.5.in   | 7 ++++---
>>> 3 files changed, 9 insertions(+), 8 deletions(-)
>>>=20
>>> diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
>>> index 75fbf8ee0061..0ecf4606ce48 100644
>>> --- a/lib/ext2fs/initialize.c
>>> +++ b/lib/ext2fs/initialize.c
>>> @@ -186,7 +186,7 @@ errcode_t ext2fs_initialize(const char *name, i=
nt flags,
>>>=20
>>> 	set_field(s_rev_level, EXT2_GOOD_OLD_REV);
>>> 	if (super->s_rev_level >=3D EXT2_DYNAMIC_REV) {
>>> -		set_field(s_first_ino, EXT2_GOOD_OLD_FIRST_INO);
>>> +		set_field(s_first_ino, 64);
>>> 		set_field(s_inode_size, EXT2_GOOD_OLD_INODE_SIZE);
>>> 		if (super->s_inode_size >=3D sizeof(struct ext2_inode_large)) {
>>> 			int extra_isize =3D sizeof(struct ext2_inode_large) -
>>> diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
>>> index 520a07185f9f..6eef1d97bfbf 100644
>>> --- a/misc/mke2fs.8.in
>>> +++ b/misc/mke2fs.8.in
>>> @@ -386,10 +386,10 @@ Do not attempt to discard blocks at mkfs time=
=2E
>>> @QUOTA_MAN_COMMENT@behavior is to initialize both user and group qu=
otas.
>>> .TP
>>> .BI reserved_inodes=3D number
>>> -Specify the number of inodes reserved for system files. This numbe=
r must be
>>> -at least 10. Currently 10 is enough but future features may requir=
e additional
>>> -reserved inodes. Reserving more inodes after file system is create=
d requires
>>> -full file system scan so it can take a long time.
>>> +Specify the number of inodes reserved for system files. This numbe=
r must be at
>>> +least 10, default is 64. Currently 10 is enough but future feature=
s may require
>>> +additional reserved inodes. Reserving more inodes after file syste=
m is created
>>> +requires full file system scan so it can take a long time.
>>> .RE
>>> .TP
>>> .BI \-f " fragment-size"
>>> diff --git a/misc/mke2fs.conf.5.in b/misc/mke2fs.conf.5.in
>>> index 06ca9e4eabc4..b35767bfedf2 100644
>>> --- a/misc/mke2fs.conf.5.in
>>> +++ b/misc/mke2fs.conf.5.in
>>> @@ -197,9 +197,10 @@ reserved ratio. This value can be a floating p=
oint number.
>>> .TP
>>> .I reserved_inodes
>>> This relation specifies the default number of inodes reserved for s=
ystem files.
>>> -The number must be at least 10. Currently 10 is enough but future =
features may
>>> -require additional reserved inodes. Reserving more inodes after fi=
le system is
>>> -created requires full file system scan so it can take a long time.
>>> +The number must be at least 10, default is 64. Currently 10 is eno=
ugh but
>>> +future features may require additional reserved inodes. Reserving =
more inodes
>>> +after file system is created requires full file system scan so it =
can take a
>>> +long time.
>>> .TP
>>> .I undo_dir
>>> This relation specifies the directory where the undo file should be
>>> --=20
>>> 2.1.4
>>>=20
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
> --=20
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
