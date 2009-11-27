From: Tim Blechmann <tim@klingt.org>
Subject: Re: ext4: smp_processor_id() in preemptible
Date: Fri, 27 Nov 2009 11:32:38 +0100
Message-ID: <4B0FAAC6.30906@klingt.org>
References: <4AC9C4FD.7080606@klingt.org> <8C8865ED624BB94F8FE50259E2B5C5B304593DAB98@palmail03.lsi.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB66E6D3EFAF7D3F14E47A865"
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Leyendecker, Robert" <Robert.Leyendecker@lsi.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754308AbZK0Kcm@vger.kernel.org>
In-Reply-To: <8C8865ED624BB94F8FE50259E2B5C5B304593DAB98@palmail03.lsi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB66E6D3EFAF7D3F14E47A865
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

> I have similar crash, but probably different cause-vector, posted on th=
is list, fedora bugzilla, rt-users but no response so far from anyone. Di=
d you find any work around?  I tried looking at smp code for hints on pro=
blem it looks like in my case it could be trying to reschedule work on di=
fferent CPU at time of crash. However, I admit that I could be way, way o=
ff on that cause. In my case, if I hammer my network interface with packe=
ts while another app is reading packets, my host locks up and clients are=
 reporting dest unreachables.=20
>=20
> I don't think I have the problem in non-rt kernel. Have you tried booti=
ng without smp support?

i haven't tried to reproduce it since then ... it occurred, when i was
doing some heavy io tasks ...

tim

--=20
tim@klingt.org
http://tim.klingt.org

Nothing exists until or unless it is observed. An artist is making
something exist by observing it. And his hope for other people is that
they will also make it exist by observing it. I call it 'creative
observation.' Creative viewing.
  William S. Burroughs


--------------enigB66E6D3EFAF7D3F14E47A865
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksPqsYACgkQdL+4qsZfVstg+gCfTdLnqf51oy0Qy8MiD1uiyn/y
LH0AnjRVi/LFnuYvhDIpjdl2NVc2wskt
=zyB9
-----END PGP SIGNATURE-----

--------------enigB66E6D3EFAF7D3F14E47A865--
