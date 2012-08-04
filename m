From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: Re: How to understand get_dx_countlimit?
Date: Sat, 04 Aug 2012 12:46:04 +0800
Message-ID: <501CA90C.7010901@gmail.com>
References: <50194231.5030303@gmail.com> <20120803183320.GU58276@kernel.stglabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37960 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab2HDEqK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 Aug 2012 00:46:10 -0400
Received: by pbbrp8 with SMTP id rp8so2388470pbb.19
        for <linux-ext4@vger.kernel.org>; Fri, 03 Aug 2012 21:46:10 -0700 (PDT)
In-Reply-To: <20120803183320.GU58276@kernel.stglabs.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012=E5=B9=B408=E6=9C=8804=E6=97=A5 02:33, Darrick J. Wong wrote:
> On Wed, Aug 01, 2012 at 10:50:25PM +0800, Wang Sheng-Hui wrote:
>> Dear all,
>>
>> Sorry to trouble you!=20
>>
>> I'm confused by the namei.c/get_dx_countlimit.
>> This function seems support metadata checksum for dir/dx.
>>
>> I wonder what kind of dirent would meet:
>>
>>     le16_to_cpu(dirent->rec_len) =3D=3D EXT4_BLOCK_SIZE(inode->i_sb)
>>
>> The tail dirent of one dir block?
>=20
> This case usually indicates that there's one big "empty" dirent that'=
s hiding
> some dx hash tree data.  These ought to be non-root dx tree nodes.
>=20
>> And the case "le16_to_cpu(dirent->rec_len) =3D=3D 12"?
>=20
> In a hashed directory, the first block (i.e. the root of the dx tree,=
 if there
> even is a tree) uses the first 24 bytes to present dirents for "." an=
d "..".  The
> remaining space is a big "empty" dirent that hides the root of the dx=
 tree.
>=20
>> I suspect these kinds of dirents are the tail ones, but
>> I cannot figure out the physical layout for one dir block
>> with metadat checksum, e.g in which case we would have dirents
>> meet the conditions in the function get_dx_countlimit?
>=20
> FYI, there's some (slightly out of date) additional reference data at
> https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout.
>=20
> Before hashed directories, a directory file consisted of variable-len=
gth
> dirents that weren't in any particular order.  The dirents are packed=
 in
> such a way that they do not cross $BLOCKSIZE (usually 4KiB) boundarie=
s.  To add
> metadata checksumming to one of these classic dirent blocks, I create=
 an empty
> "dirent" in the last 12 bytes of the block that looks deleted, and st=
uff the
> crc32 into the name field.  Obviously, if there's no room in the bloc=
k then
> e2fsck has to rebuild the directory.
>=20
> When hashed directories were added, it was desired to retrofit them i=
nto the
> existing directory file structure in such a way that the old code cou=
ld read
> the directory file without getting confused by the tree data.  Furthe=
rmore, it
> was decided that tree data should not be mixed in with regular dirent=
s, i.e.
> given a block in a directory, it either contains tree data or dirents=
 pointing
> to inodes, but not both.
>=20
> To accomplish that, a block containing tree data is given a dirent he=
ader that
> doesn't point to an inode ("null dirent"), since dirents that don't p=
oint to
> valid inodes are skipped over by the old ext2 code.  The dirent heade=
r claims
> to take up all the space in the block, and the tree data goes in the =
space that
> normally stores the file name.  If metadata checksumming is enabled, =
the last
> dx_entry in the tree block is reserved for storing the checksum.
>=20
> There is one exception to what I just wrote -- the old ext2 code expe=
cts the
> first block of a directory file to contain (at offset zero) two diren=
ts
> pointing to "." and "..".  Therefore, the root of the tree is encapsu=
lated
> inside a null dirent (just like the non-root nodes, as I describe abo=
ve) but
> the null dirent begins 24 bytes into that first block, instead of at =
the very
> beginning of the block.
>=20
> Hope that doesn't muddy the situation any more....
>=20
> --D

Thanks a lot, Darrick!

Regards,
Sheng-Hui
>>
>> Any explanations are welcomed!
>>
>> Thanks,
>> Sheng-Hui
>>
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
