From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: Creating a >32bit blocks filesystem.
Date: Wed, 9 May 2007 11:34:28 -0500
Message-ID: <20070509113428.760f453a@gara>
References: <20070503140804.463b20e1@naruto>
	<463B4A1B.4070201@bull.net>
	<20070507111952.7868bc1c@gara>
	<4641BBB7.8020904@bull.net>
	<20070509085547.4785bf7d@gara>
	<4641E13D.906@bull.net>
	<4641E708.1090109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Valerie Clement <valerie.clement@bull.net>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:37179 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191AbXEIQgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 May 2007 12:36:21 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l49GaKaW031114
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 12:36:20 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l49GaBtM155254
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 10:36:20 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l49GYSXp030669
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 10:34:28 -0600
In-Reply-To: <4641E708.1090109@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 09 May 2007 10:21:44 -0500
Eric Sandeen <sandeen@redhat.com> wrote:

> Valerie Clement wrote:
> > Jose R. Santos wrote:
> >> I think this has more to do with the fact that I'm on a 32bit
> >> architecture and there are still a couple places where blocks are
> >> represented using "unsigned long".  I'm trying to get access to a =
64bit
> >> arch to confirm this.
> >>
> >> -JRS
> >>
> > Oh, I didn't catch that you use a 32-bit system.
> > On 32-bit architectures, the page cache index size imposes a 16TB l=
imit=20
> > on the filesystem size (with 4KB blocksize). So you need a 64-bit s=
ystem=20
> > for your test.
> >    Val=C3=A9rie
>=20
> hm, the mount never should have gotten far enough to fail due to this=
,
> should it have?
>=20
> Jose, what exactly failed?  I see references to debugfs failing, but
> also kernel logs...

debugfs 1.39-tyt3 (29-Apr-2007)
/dev/mapper/testdb: Can't read an inode bitmap while reading inode bitm=
ap

dumpe2fs 1.39-tyt3 (29-Apr-2007)
=46ilesystem volume name:   <none>
Last mounted on:          <not available>
=46ilesystem UUID:          1377370d-bc15-42c0-90bc-50e86bd86198
=46ilesystem magic number:  0xEF53
=46ilesystem revision #:    1 (dynamic)
=46ilesystem features:      has_journal resize_inode dir_index filetype=
 64bit spar
=2E..
Journal backup:           inode blocks
misc/dumpe2fs: Attempt to read block from filesystem resulted in short =
read whil
e reading journal inode


> Jose, you mentioned that some blocks are still "unsigned long" on
> 32-bits... they shouldn't be, the LBD work should have fixed all thos=
e
> long ago.  But there is still the 16TB page cache limit in force.

=46ound this in mke2fs.c
                unsigned long blocks =3D EXT2_BLOCKS_COUNT(fs->super);
                unsigned long start;

which are later uses to wipe out any MD RAID metadata at the end of the
device. and in parse_extended_opts()

		unsigned long resize, bpg, rsv_groups;
		...
		if (resize <=3D EXT2_BLOCKS_COUNT(param)) {

Both of these cases should not affect what I was doing since I'm not
resizing or my device did not have any RAID metadata on the partition.
I believe I spotted similar cases yesterday in libext2fs but I don't
recall where.  I will check.

-JRS
