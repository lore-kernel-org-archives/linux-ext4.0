From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH e2fsprogs] Add ZFS detection to libblkid
Date: Mon, 06 Apr 2009 00:25:02 -0600
Message-ID: <20090406062502.GE3199@webber.adilger.int>
References: <1212171647.7508.46.camel@localhost> <49D6C844.5070604@redhat.com>
 <49D75AD1.7060101@redhat.com> <20090404212507.GC3199@webber.adilger.int>
 <49D7D537.50502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ricardo M. Correia" <Ricardo.M.Correia@sun.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Karel Zak <kzak@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:51149 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbZDFGZJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Apr 2009 02:25:09 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n366P5u6002931
	for <linux-ext4@vger.kernel.org>; Sun, 5 Apr 2009 23:25:05 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KHO000001LRER00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Sun,
 05 Apr 2009 23:25:05 -0700 (PDT)
In-reply-to: <49D7D537.50502@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 04, 2009  16:46 -0500, Eric Sandeen wrote:
> Andreas Dilger wrote:
> > On Apr 04, 2009  08:04 -0500, Eric Sandeen wrote:
> >> And from another report, another user's zfs partition:
> >>
> >> # hexdump -C first_400K | grep "0c b1 07 b0 f5 02 00 00"
> >> # hexdump -C first_400K | grep "00 00 02 f5 b0 07 b1 0c"
> >> # hexdump -C first_400K | grep "0c b1 ba 00"
> >> 00015e30  30 e8 ff ff 85 c0 5b 75  48 8b 06 35 0c b1 ba 00
> >>
> >> Should we be looking for 0x00babloc at offset 00015e30?
> >=20
> > In probe.c I see the magic (that I've been assuming is correct, bec=
ause
> > it isn't really that easy to read):
> >=20
> >   { "zfs",       8,      0,  8, "\0\0\x02\xf5\xb0\x07\xb1\x0c", pro=
be_zfs },
> >   { "zfs",       8,      0,  8, "\x0c\xb1\x07\xb0\xf5\x02\0\0", pro=
be_zfs },
> >   { "zfs",     264,      0,  8, "\0\0\x02\xf5\xb0\x07\xb1\x0c", pro=
be_zfs },
> >   { "zfs",     264,      0,  8, "\x0c\xb1\x07\xb0\xf5\x02\0\0", pro=
be_zfs },
>=20
> Yep and that's different from the patch you originally submitted, And=
reas...
>=20
> > but looking at this I have no idea what this magic value is suppose=
d
> > to represent, from reading the ondiskformat0822.pdf (ZFS spec) docu=
ment.
>=20
> VDEV_BOOT_MAGIC ...
>=20
>   333 /* ZFS boot block */
>   334 #define VDEV_BOOT_MAGIC         0x2f5b007b10cULL
>=20
> but I can't find much in that spec about where it's supposed to be, a=
t
> least from a very quick skim.

According to ondiskformat0822.pdf this is supposed to be at an 8kB
offset in each of the 4 per-disk labels, but it isn't clear that this
will be in every ZFS filesystem:

	Section 1.3.2: Boot Block Header

	The boot block header is an 8K structure that is reserved for
	future use. The contents of this block will be described in a
	future appendix of this paper.

so I'd prefer to just stick with the =FCberblock magic, which should
be present in all versions of ZFS.

> I'll let you IBM er... SUN guys sort it out  ;)

I'll defer to Ricardo, he is the ZFS expert.

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
