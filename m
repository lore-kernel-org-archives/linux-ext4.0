From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 11/12] Add support for new compat feature "sparse_super2"
Date: Wed, 5 Feb 2014 11:17:11 -0500
Message-ID: <20140205161711.GB11667@thunk.org>
References: <1390197254-14583-1-git-send-email-tytso@mit.edu>
 <1390197254-14583-12-git-send-email-tytso@mit.edu>
 <alpine.DEB.2.10.1402051559390.16807@tglase.lan.tarent.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Thorsten Glaser <t.glaser@tarent.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from eurynome.mirbsd.org ([81.169.181.30]:34147 "EHLO
	eurynome.mirbsd.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756395AbaBFMTM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Feb 2014 07:19:12 -0500
Received: from herc.mirbsd.org (root@herc.mirbsd.org [IPv6:2a01:198:25d:0:202:b3ff:feb7:54e8])
	by eurynome.mirbsd.org (8.14.5.Beta0/8.14.3) with ESMTP id s16C2IBx025494
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 6 Feb 2014 12:02:31 GMT
Received: from herc.mirbsd.org (tg@localhost [IPv6:::1])
	by herc.mirbsd.org (8.14.5/8.14.5) with ESMTP id s16C22uk015647
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 6 Feb 2014 12:02:06 GMT
Received: (from tg@localhost)
	by herc.mirbsd.org (8.14.5/8.14.5/Submit) id s16C21ZU028311
	for linux-ext4@vger.kernel.org; Thu, 6 Feb 2014 12:02:01 GMT
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1402051559390.16807@tglase.lan.tarent.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Wed, Feb 05, 2014 at 04:01:26PM +0100, Thorsten Glaser wrote:
>=20
> Can we have this for tune2fs? At least a way to turn it on, so that
> the next e2fsck or resize2fs will actually get rid of the now no
> longer needed copies?

Sure, it's possible.  It's not like there are *that* many copies so it
won't actually save that much disk space.  The main goal was not save
space, since the amount of disk space for the extra copies is a very
tiny fraction of the disk space in a big file system.

The main motivation for sparse superblocks was to allow me to make
file systems that are where the data block area is perfectly
contiguous which is useful for various specialized use cases.  For
example, if you are a huge cloud company who is absolutely fanatical
about controlling 99.9 percentile latency, and you want to create data
block files which are completely contiguous.  The sparse_super2
feature will also be useful for supporting Shingled Magnetic Recording
(SMR) disks where we care about having large, contiguous files be
aligned on 256 MB SMR zones, in the case where the userspace
application is SMR-aware.  (SMR drives are only now starting to be
available in prototype form from HDD vendors, and the T10
specifications haven't been finalized yet, so these are still very
early days for SMR support.)

> What kernels support this option? (Sorry if this was already said=E2=80=
=A6
> I mostly noticed this in today=E2=80=99s apt-listchanges output only,=
 and
> DuckDuckGo found virtually nothing, and Google was only marginally
> more helpful.) Is this ext4fs only?

The sparse_super2 feature is a compat feature, so it doesn't have any
kernel dependencies, and no, it's not ext4 only.  Any modern kernel
will have no problem supporting it.  Some old 2.2 or 2.4 kernels with
ext3 might complain because blocks which they think should be reserved
for backup superblocks will not be, but that hasn't been true for
quite some time.

One restriction is that kernels currently do not support online resize
of sparse_super2 file systems.  That will come eventually, but the
intended use case for this feature was primarily for single disk file
systems, so online resize wasn't something that is high on the
priority list.

Cheers,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
