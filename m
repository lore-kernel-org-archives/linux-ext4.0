From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH e2fsprogs] Add ZFS detection to libblkid
Date: Sat, 04 Apr 2009 15:25:07 -0600
Message-ID: <20090404212507.GC3199@webber.adilger.int>
References: <1212171647.7508.46.camel@localhost> <49D6C844.5070604@redhat.com>
 <49D75AD1.7060101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ricardo M. Correia" <Ricardo.M.Correia@sun.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Karel Zak <kzak@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:53173 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879AbZDDVZ0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 Apr 2009 17:25:26 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n34LPKuF017492
	for <linux-ext4@vger.kernel.org>; Sat, 4 Apr 2009 14:25:20 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KHL00400I4FEZ00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Sat,
 04 Apr 2009 14:25:20 -0700 (PDT)
In-reply-to: <49D75AD1.7060101@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 04, 2009  08:04 -0500, Eric Sandeen wrote:
> And from another report, another user's zfs partition:
>=20
> # hexdump -C first_400K | grep "0c b1 07 b0 f5 02 00 00"
> # hexdump -C first_400K | grep "00 00 02 f5 b0 07 b1 0c"
> # hexdump -C first_400K | grep "0c b1 ba 00"
> 00015e30  30 e8 ff ff 85 c0 5b 75  48 8b 06 35 0c b1 ba 00
>=20
> Should we be looking for 0x00babloc at offset 00015e30?

In probe.c I see the magic (that I've been assuming is correct, because
it isn't really that easy to read):

  { "zfs",       8,      0,  8, "\0\0\x02\xf5\xb0\x07\xb1\x0c", probe_z=
fs },
  { "zfs",       8,      0,  8, "\x0c\xb1\x07\xb0\xf5\x02\0\0", probe_z=
fs },
  { "zfs",     264,      0,  8, "\0\0\x02\xf5\xb0\x07\xb1\x0c", probe_z=
fs },
  { "zfs",     264,      0,  8, "\x0c\xb1\x07\xb0\xf5\x02\0\0", probe_z=
fs },

but looking at this I have no idea what this magic value is supposed
to represent, from reading the ondiskformat0822.pdf (ZFS spec) document=
=2E

According to that the __u64 ub_magic is supposed to be 0x0000000000bab1=
0c
(big endian) or 0x0xb1ba0000000000 (little endian), at 128kB offset, an=
d
128*1kB thereafter (assuming the filesystem has been used enough to
write 128 transactions).  This should repeat again at 256kB + 128kB.

In the zfs.img.bz2 that I have (and sent Karel recently for util-linux-=
ng)
I don't see the ub_magic at the right offset.  The NVpair data IS
in the right 16kB offset, and contains all of the expected data (versio=
n,
name, pool_guid, etc) so it isn't just an issue of the device having th=
e
wrong offset.  The ub_magic is at 0x21000, 0x21400, ..., and for the
second =FCberblock at 0x61000, 0x61400, so this is off by 0x1000 or 16k=
B.

I _suppose_ there is no hard requirement that the ub_magic is present i=
n
the first =FCberblock slot at 128kB, but that does make it harder to fi=
nd.
In theory we would need to add 256 magic value checks, which seems
unreasonable.  Ricardo, do you know why the zfs.img.bz2 has bad =FCberb=
locks
for the first 4 slots?



In any case, the ZFS magic above is completely broken and needs fixing,
as does the patch I sent Karel for util-linux-ng.  For e2fsprogs it see=
ms
it should be something like the following:

  { "zfs",     128,      0,  8, "\0\0\0\0\0\xba\xb1\xc",probe_zfs },
  { "zfs",     128,      0,  8, "\xc\xb1\xba\0\0\0\0\0",probe_zfs },
  { "zfs",     132,      0,  8, "\0\0\0\0\0\xba\xb1\xc",probe_zfs },
  { "zfs",     132,      0,  8, "\xc\xb1\xba\0\0\0\0\0",probe_zfs },
  { "zfs",     136,      0,  8, "\0\0\0\0\0\xba\xb1\xc",probe_zfs },
  { "zfs",     136,      0,  8, "\xc\xb1\xba\0\0\0\0\0",probe_zfs },
  { "zfs",     384,      0,  8, "\0\0\0\0\0\xba\xb1\xc",probe_zfs },
  { "zfs",     384,      0,  8, "\xc\xb1\xba\0\0\0\0\0",probe_zfs },
  { "zfs",     388,      0,  8, "\0\0\0\0\0\xba\xb1\xc",probe_zfs },
  { "zfs",     388,      0,  8, "\xc\xb1\xba\0\0\0\0\0",probe_zfs },
  { "zfs",     392,      0,  8, "\0\0\0\0\0\xba\xb1\xc",probe_zfs },
  { "zfs",     392,      0,  8, "\xc\xb1\xba\0\0\0\0\0",probe_zfs },

and for util-linux-ng it should be like the following:

               { .magic =3D "\0\0\0\0\0\xba\xb1\xc", .len =3D 8,
                 .kboff =3D 128, .sboff =3D 0 },
               { .magic =3D "\xc\xb1\xba\0\0\0\0\0", .len =3D 8,
                 .kboff =3D 128, .sboff =3D 0 },
               { .magic =3D "\0\0\0\0\0\xba\xb1\xc", .len =3D 8,
                 .kboff =3D 132, .sboff =3D 0 },
               { .magic =3D "\xc\xb1\xba\0\0\0\0\0", .len =3D 8,
                 .kboff =3D 132, .sboff =3D 0 },
               { .magic =3D "\0\0\0\0\0\xba\xb1\xc", .len =3D 8,
                 .kboff =3D 136, .sboff =3D 0 },
               { .magic =3D "\xc\xb1\xba\0\0\0\0\0", .len =3D 8,
                 .kboff =3D 136, .sboff =3D 0 },
               { .magic =3D "\0\0\0\0\0\xba\xb1\xc", .len =3D 8,
                 .kboff =3D 384, .sboff =3D 0 },
               { .magic =3D "\xc\xb1\xba\0\0\0\0\0", .len =3D 8,
                 .kboff =3D 384, .sboff =3D 0 },
               { .magic =3D "\0\0\0\0\0\xba\xb1\xc", .len =3D 8,
                 .kboff =3D 388, .sboff =3D 0 },
               { .magic =3D "\xc\xb1\xba\0\0\0\0\0", .len =3D 8,
                 .kboff =3D 388, .sboff =3D 0 },
               { .magic =3D "\0\0\0\0\0\xba\xb1\xc", .len =3D 8,
                 .kboff =3D 392, .sboff =3D 0 },
               { .magic =3D "\xc\xb1\xba\0\0\0\0\0", .len =3D 8,
                 .kboff =3D 392, .sboff =3D 0 },


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
