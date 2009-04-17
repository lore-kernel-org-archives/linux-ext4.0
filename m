From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH e2fsprogs] Add ZFS detection to libblkid
Date: Fri, 17 Apr 2009 11:51:36 +0200
Message-ID: <20090417095136.GA12255@nb.net.home>
References: <1212171647.7508.46.camel@localhost> <49D6C844.5070604@redhat.com> <49D75AD1.7060101@redhat.com> <20090404212507.GC3199@webber.adilger.int> <1239045758.7486.80.camel@localhost> <20090407074033.GM3204@webber.adilger.int> <1239650962.18123.44.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@Sun.COM>,
	Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45046 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759411AbZDQJvm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Apr 2009 05:51:42 -0400
Content-Disposition: inline
In-Reply-To: <1239650962.18123.44.camel@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 13, 2009 at 08:29:22PM +0100, Ricardo M. Correia wrote:
> On Ter, 2009-04-07 at 00:40 -0700, Andreas Dilger wrote:
> > > However, even though currently it's txg nr 4 that gets written fi=
rst,
> > > this is an implementation-specific detail that we cannot (or shou=
ld not)
> > > rely upon.
> >=20
> > So my proposal to check the 0th, 4th, and 8th =C3=BCberblock in bot=
h
> > the first and second VDEV label should be pretty safe.
>=20
> Yes, that should be relatively safe :)
>=20
> Where should I be sending patches for this? e2fsprogs, util-linux-ng,
> libvolume_id in udev, ... all of them?

Please,

  git://git.kernel.org/pub/scm/utils/util-linux-ng/util-linux-ng.git

currently the libs/blkid/src/probers/zfs.c file contains the original
Andreas's probing code. Note that you needn't to use hard-coded
offsets (see for example ufs.c).

I'll eventually port your patch to libvolume_id and e2fsprogs.

Thanks.

    Karel

--=20
 Karel Zak  <kzak@redhat.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
