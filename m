From: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [2.6.24 patch] let EXT4DEV_FS depend on BROKEN
Date: Wed, 02 Jan 2008 16:31:16 -0500
Message-ID: <1199309476.19161.20.camel@heimdal.trondhjem.org>
References: <20080102013218.GO27566@does.not.exist>
	 <20080102192629.28e67241.diegocg@gmail.com>
	 <20080102211655.GC15898@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Diego Calleja <diegocg@gmail.com>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pat.uio.no ([129.240.10.15]:40702 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368AbYABVb7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jan 2008 16:31:59 -0500
In-Reply-To: <20080102211655.GC15898@does.not.exist>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Wed, 2008-01-02 at 23:16 +0200, Adrian Bunk wrote:
> On Wed, Jan 02, 2008 at 07:26:29PM +0100, Diego Calleja wrote:
> > El Wed, 2 Jan 2008 03:32:18 +0200, Adrian Bunk <bunk@kernel.org> es=
cribi=C3=B3:
> >=20
> > > It might make sense to offer ext4 in -mm and even in early -rc ke=
rnels,=20
> > > but I've already seen people using ext4 simply because a stable k=
ernel=20
> > > offered it - and that's definitely not intended.
> >=20
> > But isn't that the whole purpose of having ext4 snapshots in the st=
able kernel - to
> > allow people to try it?
>=20
> ext4 has quite an unusual development model for kernel code, other=20
> code in the state of ext4 is usually only in -mm and not in stable=20
> kernels.

Bullshit... We all do this.

> Stable kernels are mainly meant for usage, not for trying stuff.
> And although I see a point in perhaps shipping some not-yet-perfect=20
> device drivers for otherwise unsupported hardware or some
> not-yet-perfect filesystems required for accessing foreign
> (non-Linux) filesystems, I don't see any point in offering a
> WIP Linux-only filesystem in stable kernels.

This breaks with the 2.6.x development model that we've been working
with for several years now. I, for one, do not wish to change that
model.

Trond
