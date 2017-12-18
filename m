From: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
Subject: [QUESTION] Locking for the transaction buffers
Date: Mon, 18 Dec 2017 18:08:34 +0100
Message-ID: <8ced83bc-4afa-998e-8015-bab5e2441c49@tu-dortmund.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bcdBGlqLL6ffj7vHXckRlENXFDdSSf9AE"
Cc: Horst Schirmeier <horst.schirmeier@tu-dortmund.de>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.hrz.uni-dortmund.de ([129.217.128.51]:65400 "EHLO
        unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932756AbdLRSAI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Dec 2017 13:00:08 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bcdBGlqLL6ffj7vHXckRlENXFDdSSf9AE
Content-Type: multipart/mixed; boundary="nJ6QnTdoVleVmf3uN6QwWF39iVWpn3IUd";
 protected-headers="v1"
From: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
To: linux-ext4@vger.kernel.org
Cc: Horst Schirmeier <horst.schirmeier@tu-dortmund.de>
Message-ID: <8ced83bc-4afa-998e-8015-bab5e2441c49@tu-dortmund.de>
Subject: [QUESTION] Locking for the transaction buffers

--nJ6QnTdoVleVmf3uN6QwWF39iVWpn3IUd
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi developers,

I'm studying the locking in the JBD2 subsystem (v4.15-rc4). Doing so, I
came across the jbd2_journal_commit_transaction function
where severals lists, e.g., t_forget or t_buffers, are flushed in a
while loop.
According to the documentation in inlcude/linux/jbd2.h, the j_list_lock
lock is the appropriate lock.
However, it is only used in one out of three cases:
In fs/jbd2/commit.c:903, the while loop is protected using the
j_list_lock lock. Whereas it is not used at line 464 and 561.
In contrast to that, the insert and remove operations to any of these
lists are protected by that lock.

Can you please tell me why that lock is not used at line 464 and 561?

Thanks in advance!

Regards,
Alex

--=20
Technische Universit=C3=A4t Dortmund
Alexander Lochmann                PGP key: 0xBC3EF6FD
Otto-Hahn-Str. 16                 phone:  +49.231.7556141
D-44227 Dortmund                  fax:    +49.231.7556116
http://ess.cs.tu-dortmund.de/Staff/al


--nJ6QnTdoVleVmf3uN6QwWF39iVWpn3IUd--

--bcdBGlqLL6ffj7vHXckRlENXFDdSSf9AE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQI/BAEBCAApBQJaN/YSIhxhbGV4YW5kZXIubG9jaG1hbm5AdHUtZG9ydG11bmQu
ZGUACgkQWT7tBbw+9v17gw/+ONxZL6rMDiz/BlE/SBWHNJsYuS4dgrkNBje0/ZAf
2ExxxfdKNAXFOZtW7bxdCNLkLYEWSjIrbBwmQD5JnFLm8tq9o1sIQiGjv5fpEfPN
oYlweU85atVnBScBLOvHPh9jLbg7U9Bs1TG4zd3SPA0ikc8C1/7mbHjEylEyxyBe
zqnVg/lpKuSpM6BL4UpSaaWYKLfr5+rrTxAN2Enr4Lx5allkARVkedL5KF2Cadmz
l8KMcDrxOkGrU+FHFqlqzrAzIMTKKMRB2g37qUGd0SoGvDx/N11TRt46vWJjo2ve
lBlsTP+EVQmF2aYcl5T6Yqu+2Rh5IXoRU8XL6DtYwOvJnwYz37CsfUGueBcSBdut
eEr+TWcqFDYBYUX82nJdhmb5d0fjFKUkVoOEbBVDN2B9yWqz+m2/Dptqog0/fjlo
W4THmxc+5bLyjh7xgmQJ2EfTcng45gehamQyMbAEDpxZTXIKspsSGwyhKSAu2x8g
vqDBvWlePsidxEBLEPJNUoottcYvSuvwSTENNSv/HlYOxlgTveNBJUFlPDKYCYaU
I4pebscTXeFW0BmYuoWXAm7GgdiuKDN62+asVarnCHjtZBprrW7NA5TfERrmdWoK
jdYd+laSA+OykQIMPDmAkwywdb1tO56Q697UOn76r1oWqHUlbOuCQu9sUH35Updj
pf4=
=A9Du
-----END PGP SIGNATURE-----

--bcdBGlqLL6ffj7vHXckRlENXFDdSSf9AE--
