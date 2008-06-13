From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: Re: [PATCH] ext4: fix online resize group descriptors corruption
Date: Fri, 13 Jun 2008 14:33:43 +0200
Message-ID: <1213360423.9222.41.camel@localhost>
References: <1213263754.6549.45.camel@localhost>
	 <20080612190427.GD18229@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43332 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbYFMMdN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jun 2008 08:33:13 -0400
In-Reply-To: <20080612190427.GD18229@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=EF=BB=BFTed,

Concerning flex_bg and uninit_bg : it's currently not possible to resiz=
e
a filesystem with those features. It seems there are issues with
resize2fs.
We have also used nomballoc switch when mounting because of the oops
when unmounting.

We have tried both physical hard disk drive and loop back devices.
We have tested several filesystem resize with few (adding 1 group) to
many (adding 250 groups) more groups. All give correct group descriptor=
s
using dump2fs and no problem when writing files and unmounting
filesystems.

This is a typical test case:

mkfs.ext4 -E test_fs -O ^flex_bg /dev/sdc1 10M
mount -t ext4dev -o nomballoc /dev/sdc1 /mnt/test
dumpe2fs /dev/sdc1
resize2fs /dev/sdc1 100M
dumpe2fs /dev/sdc1
dd if=3D/dev/urandom of=3D/mnt/test/data bs=3D95M count=3D1
umount /mnt/test
fsck.ext4 -f /dev/sdc1

This test being run for several sizes of filesystem (from 10M with 1K
blocks to 1G with 4K blocks).

Let me know if we have missed something or if you want more testings.

Regards




Le jeudi 12 juin 2008 =C3=A0 15:04 -0400, Theodore Tso a =C3=A9crit :
> On Thu, Jun 12, 2008 at 11:42:34AM +0200, Fr=C3=A9d=C3=A9ric Boh=C3=A9=
 wrote:
> > From: Frederic Bohe <frederic.bohe@bull.net>
>=20
> Frederic,
>=20
> Many thanks!  How much testing have you done with the patch?  Does it
> fix growing the filesystems from a filesystem with say, 18 block
> groups to 32 block groups?  Have you tried with with different
> filesystem features, including with and without flex_bg and uninit_bg=
?
>=20
> Regards,
>=20
> 	   	     	       	    			- Ted
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
