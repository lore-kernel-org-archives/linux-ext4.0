From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] ext2: Don't export ext2_mask_flags() to user space
Date: Sat, 24 Mar 2012 02:50:38 -0400
Message-ID: <CAMjpGUdnisfawUNThOu_+kbH54SWXCf6PhZwyWrV=B8SNjMRNg@mail.gmail.com>
References: <1332366608-2695-1-git-send-email-thierry.reding@avionic-design.de>
 <20120321222357.GB24330@quack.suse.cz> <20120321231651.GC32041@thunk.org>
 <20120322055354.GA3942@avionic-0098.mockup.avionic-design.de>
 <1332396053.3058.2.camel@koala> <20120322162825.GA4028@thunk.org> <20120322173150.GY6589@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>, Artem Bityutskiy <dedekind1@gmail.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, stable@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50885 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab2CXGvA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Mar 2012 02:51:00 -0400
In-Reply-To: <20120322173150.GY6589@ZenIV.linux.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 22, 2012 at 13:31, Al Viro wrote:
> On Thu, Mar 22, 2012 at 12:28:25PM -0400, Ted Ts'o wrote:
>> On Thu, Mar 22, 2012 at 08:00:41AM +0200, Artem Bityutskiy wrote:
>> > On Thu, 2012-03-22 at 06:53 +0100, Thierry Reding wrote:
>> > > What's the recommended fix for packages that cannot or will not =
use
>> > > libext2fs, like busybox? Copy the required parts into a private =
header
>> > > and use that instead?
>> >
>> > The normal way is to just keep a private copy of the whole header =
file.
>> > Because the on-disk format stays compatible, those programs do not=
 have
>> > to update the header very often - only rarely if they want to supp=
ort
>> > some new feature.
>>
>> Even if they're not iwlling to use libext2fs (for space reasons, I
>> would assume? =C2=A0It can't be because of license compatibility iss=
ues
>> since they are both GPLv2), they could just simply grab the ext2_fs.=
h
>> from e2fsprogs. =C2=A0That has all of the file system definitions fo=
r ext2,
>> ext3, and ext4.
>
> Ho-hum... =C2=A0Then we could kill a lot of lines in include/linux/ex=
t2_fs.h.
> I wonder how much of what remains has any business being outside of
> fs/ext2, actually - AFAICS, there are very few places that might poss=
ibly
> care:
>
> arch/blackfin/kernel/setup.c:595: =C2=A0 =C2=A0 =C2=A0 if (*((unsigne=
d short *)(mtd_phys + 0x438)) =3D=3D EXT2_SUPER_MAGIC)
> fs/nfsd/nfs3proc.c:599: =C2=A0 =C2=A0 =C2=A0 =C2=A0 case EXT2_SUPER_M=
AGIC:
> fs/nfsd/nfs3proc.c:600: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 resp->p_link_max =3D EXT2_LINK_MAX;
> fs/nfsd/nfs3proc.c:601: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 resp->p_name_max =3D EXT2_NAME_LEN;
> init/do_mounts_rd.c:57: struct ext2_super_block *ext2sb;
> init/do_mounts_rd.c:70: ext2sb =3D (struct ext2_super_block *) buf;
> init/do_mounts_rd.c:153: =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ext2sb->s_mag=
ic =3D=3D cpu_to_le16(EXT2_SUPER_MAGIC)) {
> init/do_mounts_rd.c:155: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "RAMDISK: ext2 filesystem found at bloc=
k %d\n",
> init/do_mounts_rd.c:157: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0nblocks =3D le32_to_cpu(ext2sb->s_blocks_count) <<
> init/do_mounts_rd.c:158: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0le32_to_cpu(ext2sb->s_log_block_s=
ize);
> security/selinux/hooks.c:2974: =C2=A0case EXT2_IOC_GETFLAGS:
> security/selinux/hooks.c:2976: =C2=A0case EXT2_IOC_GETVERSION:
> security/selinux/hooks.c:2980: =C2=A0case EXT2_IOC_SETFLAGS:
> security/selinux/hooks.c:2982: =C2=A0case EXT2_IOC_SETVERSION:
>
> and that's it. =C2=A0blackfin and do_mounts_rd are doing the same thi=
ng (blackfin -
> buggy, AFAICS).

buggy how ?  they're not exactly the same as the Blackfin code is
setting things up for the uClinux MTD map.  it isn't parsing the
filesystem itself (ignoring the size extraction from the superblock).

>=C2=A0Looks like both are =C2=A0asking for something along the lines o=
f
> sector_t detect_ext2(void *image), returning 0 if it's not one and si=
ze in
> kilobytes if it is...

yes, that would be fine
-mike
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
