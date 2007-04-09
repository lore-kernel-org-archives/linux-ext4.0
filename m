From: Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: Re: Add a norecovery option to ext3/4?
Date: Mon, 9 Apr 2007 05:31:34 +0200
Message-ID: <20070409033134.GB13980@implementation>
References: <20070409000556.GA13980@implementation> <4619B202.3050601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from iona.labri.fr ([147.210.8.143]:42711 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbXDIDbi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Apr 2007 23:31:38 -0400
Content-Disposition: inline
In-Reply-To: <4619B202.3050601@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen, le Sun 08 Apr 2007 22:24:50 -0500, a =E9crit :
> Samuel Thibault wrote:
> >Distribution installers usually try to probe OSes for building a sui=
ted
> >grub menu.  Unfortunately, mounting an ext3 partition, even in read-=
only
> >mode, does perform some operations on the filesystem (log recovery).
> >This is not a good idea since it may silently garbage data. =20
>=20
> Can you elaborate?  Under what circumstances is log replay going to h=
arm=20
> data?  Do you mean that the installer mounts partitions, looking for=20
> what OS is installed?  How is that harmful?
>=20
> Ohhh... this is http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D41=
7407=20
> isn't it?

Yes.

> Hm, so the root cause there seems that the installer found 2 legs of =
a=20
> mirror and mounted them independently, recovering them independently.=
=2E.=20
> But why did that cause problems?

Because that thrashed his data (or at least it didn't help to keep data
safe).

> Other options you may have in the installer, though, is to check for
> md superblocks before mounting bare partitions, or maybe use the
> BLKROSET ioctl to set the block device to read-only prior to mount,
> for added insurance...

That's one the things proposed in the bugreport yes.

Samuel
