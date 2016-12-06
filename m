From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: HUGE slowdown when doing dpkg with ext4 over nbd
Date: Tue, 6 Dec 2016 11:45:16 -0700
Message-ID: <78AEFE7B-685B-4B4E-A15E-E3F6D99DD343@dilger.ca>
References: <1621417488.8583313.1481030030711.JavaMail.zimbra@online.net>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_750E623C-1211-47E5-9FF4-A2579E4EC0EA"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4@vger.kernel.org
To: Renaud Mariana <rmariana@online.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:35627 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751581AbcLFSqh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Dec 2016 13:46:37 -0500
Received: by mail-io0-f178.google.com with SMTP id a124so668695984ioe.2
        for <linux-ext4@vger.kernel.org>; Tue, 06 Dec 2016 10:45:20 -0800 (PST)
In-Reply-To: <1621417488.8583313.1481030030711.JavaMail.zimbra@online.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_750E623C-1211-47E5-9FF4-A2579E4EC0EA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 6, 2016, at 6:13 AM, Renaud Mariana <rmariana@online.net> wrote:
>=20
> Hello,
>=20
> We have noticed a HUGE slowdown when doing dpkg with ext4 over nbd =
(qemu-nbd as a server)
>=20
> dpkg times with default mkfs & mount options is :
>=20
> - ext4: 10 mn
> - xfs : 30s.
>=20
> Disabling extents :
> mkfs.ext4 -O ^extent
> fixed the pb that is ext4 is as fast as xfs.
>=20
> Any ideas ?

Is dpkg using fallocate() (uninitialized extents)?  Could you strace the =
dpkg
process with -fff to catch forked processes and search for fallocate() =
calls.

fallocate() is the only thing I can think of that would make extents =
slower
than block-mapped files.

> Details :
>=20
> xnbd-client  --blocksize 4096  qemu-nbd-ip 10000 /dev/nbd0
> mkfs.ext4 /dev/nbd0
> mount /dev/nbd0 /newroot
>=20
> wget https://download.elastic.co/kibana/kibana/kibana-4.6.1-amd64.deb
> time dpkg -i kibana-4.6.1-amd64.deb

What kernel version are you currently running?

Is this problem new with this kernel (i.e. it worked fine with older =
kernels?

> kibana installs many small files (23209 entries) under /opt/kibana

How small are the files?

Cheers, Andreas




--Apple-Mail=_750E623C-1211-47E5-9FF4-A2579E4EC0EA
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWEcHPHKl2rkXzB/gAQgsog//bNoXy+kxPM5209xBh+GEwHe+gTnclAky
UmrpAO+w7mthy+v/qcHF8JMSYoi/+Mu9qArt/RrGXWjd+jVaG0QF1GRB66sn7Hf9
G7c2B3uXv1ZlcTwLYdWIy6YtTftToZx3/znfPdhz+57M7dsqlfpdJeOpjmV0S1gA
SA920X9gMAoN//CJUoQzGO2S9CL1+u/3iPpzIv5I+ZBZub6TkWhc27CeqU3noQqk
/USW/yz1L2tqm36ttgT0oa8nOX1v6QgC/osK1B9Hps41XE06/JE2sFyN7CZu6Wb6
Dik5n77A2sRLIBlvWNAB/BXetXSeOKckc16zdQooKbpPCPSTHr9r8v/rdKPCPFlE
Imgle3i0ECB5SPEg38jcSx+8d1fhKIItpnSD7QsJKzYrs6h2L7qvCxAHL+a3VNaU
BjnxEfTPOdrdqIvhZS2ysmWLO+yHVAXY7S9TICAcO1EdJdqDdjgdR+9ZESC6/xhZ
izWBSwZKmdmHKsp1/hC9H3F3vwin+x467znBqJpRVYKeoTb4CDYz0wIbTXER+90F
ICBjxoHRCBu6CrYCQysKWnRXq6EKxYFRmbAfamLA9iHhLHt64dfW+5TkTaeXIoQR
RKiW8HJp0Ervhz87hbYIji0jbuStoAD4r14xCnknfNKRAehcDvxs1jHyI6ChDGga
R6Gj/4dU20c=
=URbD
-----END PGP SIGNATURE-----

--Apple-Mail=_750E623C-1211-47E5-9FF4-A2579E4EC0EA--
