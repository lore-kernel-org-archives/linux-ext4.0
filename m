From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Bug#615998: linux-image-2.6.32-5-xen-amd64: Repeatable "kernel
 BUG at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Tue, 28 Jun 2011 14:58:40 +0100
Message-ID: <1309269520.3093.1574.camel@localhost>
References: <BANLkTi=5BLA07tvbv3PFcZ0cc8FmBtg+UA@mail.gmail.com>
	 <404FD5CC-8F27-4336-B7D4-10675C53A588@boeing.com>
	 <20110624134659.GB26380@quack.suse.cz>
	 <2F80BF45-28FA-46D3-9A28-CA9416DC5813@boeing.com>
	 <20110624200231.GA32176@quack.suse.cz>
	 <alpine.LFD.2.00.1106271312310.3845@dhcp-27-109.brq.redhat.com>
	 <20110627140251.GI5597@quack.suse.cz>
	 <alpine.LFD.2.00.1106271714350.3845@dhcp-27-109.brq.redhat.com>
	 <20110627160140.GC2729@thunk.org>
	 <2D8D1A30-C092-4163-B47A-BCEDACE536A3@boeing.com>
	 <20110628093652.GA29978@quack.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-vze0vYD1TGivyyaEyPsb"
Cc: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>,
	Ted Ts'o <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
	Sean Ryle <seanbo@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Sachin Sant <sachinp@in.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Jan Kara <jack@suse.cz>, 615998@bugs.debian.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41496 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757678Ab1F1N7G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Jun 2011 09:59:06 -0400
In-Reply-To: <20110628093652.GA29978@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-vze0vYD1TGivyyaEyPsb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-06-28 at 11:36 +0200, Jan Kara wrote:
> On Mon 27-06-11 23:21:17, Moffett, Kyle D wrote:
[...]
> > Please correct me if this is horribly horribly wrong:
> >=20
> > no journal:
> >   Nothing is journalled
> >   + Very fast.
> >   + Works well for filesystems that are "mkfs"ed on every boot
> >   - Have to fsck after every reboot
> Fsck is needed only after a crash / hard powerdown. Otherwise completely
> correct. Plus you always have a possibility of exposing uninitialized
> (potentially sensitive) data after a fsck.
>=20
> Actually, normal desktop might be quite happy with non-journaled filesyst=
em
> when fsck is fask enough.
[...]

With no journal, there is a fair risk that fsck cannot recover the
filesystem automatically (let alone the actual data).  And normal users
should never have to suffer questions from fsck.

Ben.

--=20
Ben Hutchings
In a hierarchy, every employee tends to rise to his level of incompetence.

--=-vze0vYD1TGivyyaEyPsb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATgneCue/yOyVhhEJAQrGqRAAu3Vo/tIev3fkSCt0zxC6fjKomeEyQETG
wV2nIOrw904d3u9fDnsuFyUpnrJMuTV4LrM1ck+N+VOC06feEaPG5kFwR4SLDLp9
eV/lkiW3g1t859Jy58i3Ksbad2NMw/+CucwacLHU2K+789I+5qqK948z7/R0kL7C
nQRbN6zLRkMBHdMCDky3WnP7Kxa8HTkp/GPd/02+xXAJ2WZmdZoFtV3zY7uba9aY
1srDn7q64nwKvSO2qjEB2k10TSui6SUyyaIwTuh7/tND7h3o8t3IHB0D1w53pA3+
K/tWnKaUq0S+BPnBNey+oBy068PUMrsyQ/LaywteXyy2BPTX0q+3J8LpPcnyRFBG
ceRo40uF3tVnYKGAeBsV0iY8qeHeBKuYRl5/PhZdMvHNgtnrOFYfgIIWl6CEwQFY
zCxagI3C1Afr3HhEOVa+LcAn0I2ASgD79UtPEqDI2P2d+li+lxzQ4VZWp3Of8o8K
sA/UQtTfpa61JpZl15d4QmuWLdPO+gTM63ZSs4+GMKdkI0ut194jBr61eaK07LK8
RdnZUMtTeH3nSGButUELvJLnmDgG86wuJKo855cTH2YkB1GeJm+P70QBV8H+9kZK
kHxyxrkkKAc2ifz6KE4SwV9FIGbxX+ZR8H98OmBaJ+o2qKK/5B92wICGaX6q+kuI
0I5mTV6Dx74=
=/btO
-----END PGP SIGNATURE-----

--=-vze0vYD1TGivyyaEyPsb--
