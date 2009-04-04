From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH e2fsprogs] Add ZFS detection to libblkid
Date: Fri, 03 Apr 2009 21:39:00 -0500
Message-ID: <49D6C844.5070604@redhat.com>
References: <1212171647.7508.46.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@Sun.COM>
To: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43360 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155AbZDDCjJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Apr 2009 22:39:09 -0400
In-Reply-To: <1212171647.7508.46.camel@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ricardo M. Correia wrote:
> This patch adds ZFS filesystem detection to libblkid.
>=20
> It probes for VDEV_BOOT_MAGIC in the first 2 ZFS labels in big-endian
> and little-endian formats.
> Unfortunately the probe table doesn't support probing from the end of
> the device, otherwise we could also probe in the 3rd and 4th labels (=
in
> case the first 2 labels were accidentally overwritten)..
>=20
> Eventually we would set the =EF=BB=BFUUID from the ZFS pool GUID and =
the LABEL tag
> from the pool name, but that requires parsing an XDR encoding of the =
pool
> configuration which is not trivial.

Hi Ricardo:

I've got a bug on fedora now where a partition w/ zfs on it is being
recognized as ext3.  VDEV_BOOT_MAGIC isn't anywhere in the first 1M of
the device, though an old ext3 superblock is intact.  :(

# hexdump -C sda2-first-1M | grep "0c b1 07 b0 f5 02 00 00"
# hexdump -C sda2-first-1M | grep "00 00 02 f5 b0 07 b1 0c"
#

(so a plea - can you guys change mkfs to zero old signatures?  maybe
256k at the front & end of the device in question?)

there is apparently an uberblock signature in it though:

# hexdump -C sda2-first-1M | grep "0c b1 ba 00"
00015e30  30 e8 ff ff 85 c0 5b 75  48 8b 06 35 0c b1 ba 00

does blkid need more work here, I guess?

Thanks,
-Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
