From: Jan Kara <jack@suse.cz>
Subject: Re: Commit 7d7345322d60edb0fa49a64a89b31360f01d09cb
Date: Wed, 23 Oct 2013 16:09:29 +0200
Message-ID: <20131023140929.GA6431@quack.suse.cz>
References: <20131023103855.GF1275@quack.suse.cz>
 <alpine.LFD.2.00.1310231404560.1918@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, stable@vger.kernel.org,
	Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1310231404560.1918@localhost.localdomain>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 23-10-13 14:11:50, Luk=C3=A1=C5=A1 Czerner wrote:
> On Wed, 23 Oct 2013, Jan Kara wrote:
>=20
> > Date: Wed, 23 Oct 2013 12:38:55 +0200
> > From: Jan Kara <jack@suse.cz>
> > To: stable@vger.kernel.org
> > Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
> > Subject: Commit 7d7345322d60edb0fa49a64a89b31360f01d09cb
> >=20
> >   Hello,
> >=20
> >   can you please consider commit 7d7345322d60edb0fa49a64a89b31360f0=
1d09cb "ext4: fix warning in
> > ext4_da_update_reserve_space()" for -stable kernels (3.10 & 3.11 wo=
uld make
> > sense). Although the problem mostly results only in a warning, it c=
an cause
> > fs corruption in the rare case of hitting ENOSPC at the wrong momen=
t.
>=20
> I am not sure about that. First of all we would have to consider
> commit 1c8924eb106c1ac755d5d35ce9b3ff42e89e2511 as well since you
> make a use of the function introduced in that commit.
  Right, I forgot about that.

> Also it's quite big change to be pushed to stable. However I think
> that the warning is actually mostly harmless since we have
>=20
> 27dd43854227bb0e6ab70129bd21b60d396db2e7 ext4: introduce reserved
> space
>=20
>=20
> so If I am not missing something, then chances that we'll end up with
> no space to allocate metadata blocks from are very very low.
  OK, right. The reserved metadata blocks patch is going to make the re=
al
failure even more unlikely. So you are right we probably don't need the
patch in stable after all. I'm withdrawing my request. Thanks for havin=
g a
look.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
