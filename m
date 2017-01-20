From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: kernel BUG at fs/ext4/inline.c:1943!
Date: Fri, 20 Jan 2017 12:17:34 -0700
Message-ID: <B36E2BBE-D64C-4E91-BB74-5729CE29BB03@dilger.ca>
References: <20170112144657.p33nf3u3ev27ixjq@thunk.org> <20170118082128.2402.qmail@ns.sciencehorizons.net> <20170119225830.ihoia75rhy2em27x@thunk.org> <58826195.60004@partition-saving.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_47F2FF99-4223-4952-8C22-F0CEF7E9A141"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Theodore Ts'o <tytso@mit.edu>,
        George Spelvin <linux@sciencehorizons.net>,
        linux-ext4@vger.kernel.org
To: Damien Guibouret <damien.guibouret@partition-saving.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35135 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753040AbdATTSY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Jan 2017 14:18:24 -0500
Received: by mail-io0-f193.google.com with SMTP id m98so8953471iod.2
        for <linux-ext4@vger.kernel.org>; Fri, 20 Jan 2017 11:17:40 -0800 (PST)
In-Reply-To: <58826195.60004@partition-saving.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_47F2FF99-4223-4952-8C22-F0CEF7E9A141
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 20, 2017, at 12:14 PM, Damien Guibouret =
<damien.guibouret@partition-saving.com> wrote:
> Theodore Ts'o wrote:
>> On Wed, Jan 18, 2017 at 03:21:28AM -0500, George Spelvin wrote:
>>> I was trying to rmdir an empty directory in lost+found that =
accumulated
>>> during my recent problems.
>>>=20
>>> EXT4-fs (md3): mounted filesystem with writeback data mode. Opts: =
data=3Dwriteback,delalloc
>>>=20
>>> $ cd /mountpoint/lost+found
>>> $ rmdir \#1625089/
>>>=20
>>> ------------[ cut here ]------------
>>> kernel BUG at fs/ext4/inline.c:1943!
>>> debugfs:  stat <1625089>
>>> Inode: 1625089   Type: directory    Mode:  0775   Flags: 0x10000000
>>> Generation: 927350643    Version: 0x00000000:00000004
>>> User:  1000   Group:   161   Project:     0   Size: 132
>>> File ACL: 1664090185    Directory ACL: 0
>>> Links: 0   Blockcount: 8
>>> Fragment:  Address: 0    Number: 0    Size: 0
>>> ctime: 0x587f2034:472c74ec -- Wed Jan 18 02:58:44 2017
>>> atime: 0x56b9e2f8:b68a7658 -- Tue Feb  9 08:00:40 2016
>>> mtime: 0x56c1bc4b:a7765de8 -- Mon Feb 15 06:53:47 2016
>>> crtime: 0x56ba9eb4:a51d90ac -- Tue Feb  9 21:21:40 2016
>>> Size of extra inode fields: 32
>>> Extended attributes:
>>> system.data (72)
>>> Inode checksum: 0xe2f12fc5
>>> Size of inline data: 132
>> OK, so the problem seems the inode in question has the INLINE_DATA
>> flag set, but i_blocks is non-zero.  And it looks like the data was
>> actually stored in an exernal data block, and the in-line xattr =
wasn't
>> present.
>> e2fsck should be checking and complaining if this is the case.  If
>> not, it's a bug in e2fsck.
>> And the kernel certainy shouldn't be BUG'ing when it comes across
>> what is clearly a case of file system corruption.
>> Cheers,
>> 					- Ted
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Hello,
>=20
> Perhaps I am wrong, but as the inode has a file ACL, the blockcount =
should be
> different from 0?  So it seems valid on this point. Or is there =
something that
> prevent inlined file to have ACL?

The "File ACL" label is misleading.  ACLs are stored as xattrs, (along =
with other
xattrs like SELinux labels), and also inline data.  However, unless the =
ACL is
very large it would also be stored inside the inode itself.  If there =
isn't space
inside the inode to store both the inline data and other xattrs, the =
inline data
should be bumped to an external block first (i.e. stored as a regular =
file),
since there is no benefit to doing the reverse.


Cheers, Andreas






--Apple-Mail=_47F2FF99-4223-4952-8C22-F0CEF7E9A141
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWIJiUHKl2rkXzB/gAQjhQw/9EdlHznDq1epuhF+WOisaAMzYR9DUvz6P
7hGNCdlFwgvbSnnJNA8APKMjdwUvvUaIKO+Cx4/V/TRIfRWnXNdDoK+IBWrV4fCV
5DzNDKeq+BGny3AAVWZMs/ke/w3nfXpzkZonwRLaTDPFODVCkgQNSEiPJq2+9Lnu
K6TaKmfRa28rg0Wg90bgVqSI+Qbr5IqY4QZfvgsV5fzDHHEHzzvTu19yLzhPzTPG
r9TrItNDErRI1PRS6tX4ZKaCCCEm7m2xLAkOwP4IObTA0YknSwmf1pi6q+bZKlGl
cvXttr9JoYT+6iphfnMaIYCqjs6+WOOFYMBcQAKP8X1bNw5zTeztGUrNFB1/5Izu
NzMhbhHTiJbvLCiM+ORzYh67jNRU/kv0shXyMoDLcYA2n47HOVQh8JJLdjHS43v2
/qlUn5sNySGydkQHLI4HuTcO1Xyx26bgGyr91xb0UWSsRzwcvzT/PzihrVodTdiy
11HSG/PhgUYsWaD5BFFU3C6xrkL8rH2iIOaBKu793yxTyBWJ6S6AtsfhrGPTdkmt
wwwg+QnMwthjsZVnydaUKjPodPHmuXaaiEmX03NbccgMXuTNqPV4Bz5OcNQLj6OD
c+J53CQoc+9ZAVkCZc7er/UOZjKz6hK04TcLSNkzX/8pwrXC8R6pPfdB0Lc/JGLE
+WcA1iolnaA=
=A9Mb
-----END PGP SIGNATURE-----

--Apple-Mail=_47F2FF99-4223-4952-8C22-F0CEF7E9A141--
