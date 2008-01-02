From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6.24 patch] let EXT4DEV_FS depend on BROKEN
Date: Wed, 2 Jan 2008 23:16:55 +0200
Message-ID: <20080102211655.GC15898@does.not.exist>
References: <20080102013218.GO27566@does.not.exist> <20080102192629.28e67241.diegocg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Diego Calleja <diegocg@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:39116 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756091AbYABVRO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Jan 2008 16:17:14 -0500
Content-Disposition: inline
In-Reply-To: <20080102192629.28e67241.diegocg@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 02, 2008 at 07:26:29PM +0100, Diego Calleja wrote:
> El Wed, 2 Jan 2008 03:32:18 +0200, Adrian Bunk <bunk@kernel.org> escr=
ibi=C3=B3:
>=20
> > It might make sense to offer ext4 in -mm and even in early -rc kern=
els,=20
> > but I've already seen people using ext4 simply because a stable ker=
nel=20
> > offered it - and that's definitely not intended.
>=20
> But isn't that the whole purpose of having ext4 snapshots in the stab=
le kernel - to
> allow people to try it?

ext4 has quite an unusual development model for kernel code, other=20
code in the state of ext4 is usually only in -mm and not in stable=20
kernels.

Stable kernels are mainly meant for usage, not for trying stuff.
And although I see a point in perhaps shipping some not-yet-perfect=20
device drivers for otherwise unsupported hardware or some
not-yet-perfect filesystems required for accessing foreign
(non-Linux) filesystems, I don't see any point in offering a
WIP Linux-only filesystem in stable kernels.

cu
Adrian

--=20

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
