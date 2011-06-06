From: micah anderson <micah@riseup.net>
Subject: Re: new ext4 filesystem vs. converted ext3
Date: Mon, 06 Jun 2011 12:43:10 -0400
Message-ID: <87lixeoqqp.fsf@algae.riseup.net>
References: <87tyc6pov6.fsf@algae.riseup.net> <20110604030949.GB2614@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.riseup.net ([204.13.164.18]:40733 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab1FFRBo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Jun 2011 13:01:44 -0400
In-Reply-To: <20110604030949.GB2614@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 3 Jun 2011 23:09:49 -0400, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, Jun 03, 2011 at 05:49:17PM -0400, Micah Anderson wrote:
> > However, ever since I did that change, I've noticed an increase in I/O
> > wait state on the CPUs. I've been trying to determine why, and if there
> > were some things I should tune on this ext4 filesystem.
>=20
> How are you measuring this?

Through munin graphs, unfortunately we don't have a lot of data from
before the change, but you can see the jump early on in this graph,
where the change was made:

http://lackof.org/~taggart/tmp/willet-cpu-year.png

I'll note that we also moved to squeeze from lenny at this
time. Basically we decided to move to squeeze and then convert to ext4,
so that throws in some other variables here too.

As I mentioned before, this is a high traffic mailing list system, which
does a lot of I/O. We're also seeing lots of rescheduling interrupts
after the upgrade to the squeeze kernel:

http://lackof.org/~taggart/tmp/willet-irqstats-year.png

(see the jump in the pink line on the left side?)

Searches on "rescheduling interrupts" finds lots of people using
powertop to try to reduce their laptop power usage (this might be
related: https://help.ubuntu.com/community/ReschedulingInterrupts), I'm
wondering if maybe there were changes from lenny to squeeze to try and
optimize for that, but are hurting in our case.

micah



--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJN7QOfAAoJEIy/mjIoYaeQJFMP/0C//vzhlqBfNWt/dLpk5cPR
LK7RidqCvksRfTXgnymcjUXqgowwuDU92z4Jf2pZQA6Hlnb/iYEw6Onz5fIBilPL
11CdXpHlLcdmTXYKW2Cd2I4ErVZOKMo9Erk6ahTjWbllUKWLveKcS7EZkXF6bweV
h5IdN1NJpiJbwNi/PkhvmRZZ0DQ4BvwN4B655Ro8SSjYH38hdBAyzqTdb6aBgJ3B
I2ZGPAgo/w4QWI/8bSuT+dQwU2G7nMkOJEbxPNaHV3xInftkB9i1M0oRVrX4dSP9
/Af9tMXQkX/j2+fVB8BzNwnfMJTXbkpcMFAzULJKBVyKgvzR4BUne+KnPaQu/J7g
RI5aZMxtuL4ETU4he8jw73ofYNQMry7kMILjs+IO5xCt6Z4GzzqwsDesyEWa6TzH
sYpBg8EXmkQGcokvCdT+xHJeRStnlkvnbCLG56RdUa/A2wVLONLQsa3uhVpjj42F
VK/MeaIsDgjLHFXp6jizY6u9wOK1/nzRTKhU+6an08Y4O8Fy3H3RvmsWz1vSr6cG
J79cZW9spHy6NPhRPaS4/vbsxngDD8r3wbGFf/uIBVWwgi9zTnj+TDebyPiLqA7X
eDXqDOx8jMQvvmtdyXeKx4nLPvzsF0I7R+87nrSLyifukf0CLzjOnyVTGSjFqndC
KTjFJ7RQ5ip/BILFagWl
=Yp6Z
-----END PGP SIGNATURE-----
--=-=-=--
