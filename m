From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: Journal file fragmentation
Date: Wed, 27 Aug 2008 15:12:45 -0500
Message-ID: <20080827151245.761d38b0@ichigo>
References: <1219858567.3591.64.camel@frecb007923.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: =?UTF-8?B?RnLDqWTDqXJpYyBCb2jDqQ==?= <frederic.bohe@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48921 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbYH0UOE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Aug 2008 16:14:04 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7RKE3fK030966
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 16:14:03 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7RKClPH231716
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 16:12:47 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7RKCkqr007276
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 16:12:47 -0400
In-Reply-To: <1219858567.3591.64.camel@frecb007923.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 27 Aug 2008 19:36:07 +0200
=46r=C3=A9d=C3=A9ric Boh=C3=A9 <frederic.bohe@bull.net> wrote:

> While playing with filesystems using flex bg, I noticed that the jour=
nal
> file may be fragmented when there are a lots of meta-data in  the fir=
st
> flex-group.
> For example, with this command : mkfs.ext4 -t ext4dev -G512 /dev/sdb1
> The journal file is reported by "stat <8>" in debugfs to be like this=
 :
>=20
> Inode: 8   Type: regular    Mode:  0600   Flags: 0x0
> Generation: 0    Version: 0x00000000
> User:     0   Group:     0   Size: 134217728
> File ACL: 0    Directory ACL: 0
> Links: 1   Blockcount: 262416
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x48b4a426 -- Wed Aug 27 02:47:34 2008
> atime: 0x00000000 -- Thu Jan  1 01:00:00 1970
> mtime: 0x48b4a426 -- Wed Aug 27 02:47:34 2008
> Size of extra inode fields: 0
> BLOCKS:
> (0-11):28679-28690, (IND):28691, (12-1035):28692-29715, (DIND):29716,
> (IND):29717, (1036-2059):29718-30741, (IND):30742,
> (2060-3083):30743-31766, (IND):31767, (3084-4083):31768-32767,
> (4084-4107):94209-94232, (IND):94233, (4108-5131):94234-95257,
> (IND):95258, (5132-6155):95259-96282, (IND):96283,
> (6156-7179):96284-97307, (IND):97308, (7180-8174):97309-98303,
> (8175-8203):159745-159773, (IND):159774, (8204-9227):159775-160798,
> (IND):160799, (9228-10251):160800-161823, (IND):161824,
> (10252-11275):161825-162848, (IND):162849, (11276-12265):162850-16383=
9,
> (12266-12299):225281-225314, (IND):225315, (12300-13323):225316-22633=
9,
> (IND):226340, (13324-14347):226341-227364, (IND):227365,
> (14348-15371):227366-228389, (IND):228390, (15372-16356):228391-22937=
5,
> (16357-16395):284673-284711, (IND):284712, (16396-17419):284713-28573=
6,
> (IND):285737, (17420-18443):285738-286761, (IND):286762,
> (18444-19467):286763-287786, (IND):287787, (19468-20491):287788-28881=
1,
> (IND):288812, (20492-21515):288813-289836, (IND):289837,
> (21516-22539):289838-290861, (IND):290862, (22540-23563):290863-29188=
6,
> (IND):291887, (23564-24587):291888-292911, (IND):292912,
> (24588-25611):292913-293936, (IND):293937, (25612-26585):293938-29491=
1,
> (26586-26635):295937-295986, (IND):295987, (26636-27659):295988-29701=
1,
> (IND):297012, (27660-28683):297013-298036, (IND):298037,
> (28684-29707):298038-299061, (IND):299062, (29708-30731):299063-30008=
6,
> (IND):300087, (30732-31755):300088-301111, (IND):301112,
> (31756-32768):301113-302125
> TOTAL: 32802
>=20
> This journal file is splited in 5 parts : some blocks at 28679-32767,
> then 94209-98303, then 159745-163839, then 225281-229375 and finally
> 284673-302125
>=20
> Of course "-G512" in the mkfs commad line is an extreme case but it
> shows clearly the fragmentation.
>=20
> I've tried to find if this fragmentation has any performance impact. =
So
> I've quickly wrote the following patch for the mkfs program :
>=20
> Index: e2fsprogs/lib/ext2fs/mkjournal.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.orig/lib/ext2fs/mkjournal.c       2008-08-27 02:37:59.0=
00000000 +0200
> +++ e2fsprogs/lib/ext2fs/mkjournal.c    2008-08-27 14:51:02.000000000=
 +0200
> @@ -220,7 +220,11 @@ static int mkjournal_proc(ext2_filsys      fs
>                 last_blk =3D *blocknr;
>                 return 0;
>         }
> -       retval =3D ext2fs_new_block(fs, last_blk, 0, &new_blk);
> +       retval =3D ext2fs_get_free_blocks(fs, ref_block,
> +                                       fs->super->s_blocks_count,
> +                                       es->num_blocks, fs->block_map=
,
> +                                       &new_blk);
> +
>         if (retval) {
>                 es->err =3D retval;
>                 return BLOCK_ABORT;
>=20
> This makes the mkfs time a bit longer but ends up with an unfragmente=
d
> journal file : debugfs stat<8> reports that the journal file uses
> contiguous blocks from 295937 to 328738.

The problem with this approach is that mkfs will take longer still as
you make -G xxx larger since ext2fs_get_free_blocks() is not very smart
at finding a large number of contiguous blocks.  If I understand this
correctly, the main problem we have here is that we start the new block
search from block 0.  A better approach would be to start
ext2fs_new_block() from the last block of the last inode table in a
flex_bg.  This way we avoid the fragmentation issues we see when the
inode tables for a flexbg are larger that the capacity of a single
block group.


> Then I've launched bonnie++ for testing performance impact.This is my
> test script :
>=20
> mkfs.ext4 -t ext4dev -G512 /dev/sdb1
> mount -t ext4dev -o data=3Djournal /dev/sdb1 /mnt/test
> bonnie++ -u root -s 0 -n 4000 -d /mnt/test/
>=20
> And the results:
>=20
> Without patch :
>=20
> Version 1.03d       ------Sequential Create------ --------Random Crea=
te--------
>                     -Create-- --Read--- -Delete-- -Create-- --Read---=
 -Delete--
>               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP=
  /sec %CP
>                4000  3978   7   602   0   518   1  3962   8   520   0=
   326   1
>=20
> With patch :
>=20
> Version 1.03d       ------Sequential Create------ --------Random Crea=
te--------
>                     -Create-- --Read--- -Delete-- -Create-- --Read---=
 -Delete--
>               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP=
  /sec %CP
>                4000  4180   8   736   1   543   1  4029   8   556   0=
   335   1
>=20
> Difference :
>                     =20
>                      +5.0      +22%     +4.8%      +1.6%     +6.9%   =
  +2.7%
>=20
> Conclusion :
>=20
> First, the higher performance enhancement are on read operation, whic=
h,
> if i am not wrong, has nothing to do with the journal file. This is
> surprising and may indicate that those results are wrong, but I can't
> see why right now.
> Second, there is a slight enhancement on write operations so the jour=
nal
> file defragmentation seems to have a positive impact in this test.
>=20
> I'm still bothered by the performance increase in read. So I will lau=
nch
> some more tests and see if it is consistant.
>=20
> Please, feel free to give me any comments you may have on this subjec=
t.
>=20
> Thanks.
>=20
> Frederic

-JRS
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
