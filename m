Return-Path: <SRS0=F3Rs=OG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx1.hrz.uni-dortmund.de ([129.217.128.51]:33610 "EHLO
        unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbeK1CFQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Nov 2018 21:05:16 -0500
To: Jan Kara <jack@suse.cz>
Cc: Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        linux-ext4@vger.kernel.org
From: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
Subject: [PATCH] Updated locking documentation for transaction_t
Message-ID: <003451d5-42f7-2084-05b2-3f913f10ce3d@tu-dortmund.de>
Date: Tue, 27 Nov 2018 15:54:06 +0100
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="Jq34OMMVNp9WvB7qGdHNPsRWNZKpwWtD2"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Jq34OMMVNp9WvB7qGdHNPsRWNZKpwWtD2
Content-Type: multipart/mixed; boundary="zIN9U49RmtMVie6omxK3IsCxFOFlSOnz6";
 protected-headers="v1"
From: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
To: Jan Kara <jack@suse.cz>
Cc: Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
 linux-ext4@vger.kernel.org
Message-ID: <003451d5-42f7-2084-05b2-3f913f10ce3d@tu-dortmund.de>
Subject: [PATCH] Updated locking documentation for transaction_t

--zIN9U49RmtMVie6omxK3IsCxFOFlSOnz6
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

The following members of struct transaction_s aka transaction_t
were turned into lock-free variables in the past:
- t_updates
- t_outstanding_credits
- t_handle_count
However, the documentation has not been updated yet.
This commit replaced the annotated lock by [none].

Found by LockDoc (Alexander Lochmann, Horst Schirmeier and Olaf Spinczyk)=


Signed-off-by: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
Signed-off-by: Horst Schirmeier <horst.schirmeier@tu-dortmund.de>
---
 include/linux/jbd2.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index b708e5169d1d..f1cec174a4b8 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -662,13 +662,13 @@ struct transaction_s

 	/*
 	 * Number of outstanding updates running on this transaction
-	 * [t_handle_lock]
+	 * [none]
 	 */
 	atomic_t		t_updates;

 	/*
 	 * Number of buffers reserved for use by all handles in this transactio=
n
-	 * handle but not yet modified. [t_handle_lock]
+	 * handle but not yet modified. [none]
 	 */
 	atomic_t		t_outstanding_credits;

@@ -690,7 +690,7 @@ struct transaction_s
 	ktime_t			t_start_time;

 	/*
-	 * How many handles used this transaction? [t_handle_lock]
+	 * How many handles used this transaction? [none]
 	 */
 	atomic_t		t_handle_count;

--=20
2.19.1


--zIN9U49RmtMVie6omxK3IsCxFOFlSOnz6--

--Jq34OMMVNp9WvB7qGdHNPsRWNZKpwWtD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEElhZsUHzVP0dbkjCRWT7tBbw+9v0FAlv9Wo4ACgkQWT7tBbw+
9v2ugxAA1n6ouvt/DfAgjmvipU9MtPpYrl0e6QdfmTpi+0B0CjZqrhGCcFyme9gY
aa8Vaq3r4LK1E7/sw0O7T3V8Qv/dGC1LnHff38Vs3ba1P29u48S8EkmIjppAQZlY
L8p6v6O4XfAQ49whn7DU/QOcwtJvmaIJolsO29J8xJbmowEw+IJD4s5nuGFnaeGS
qbGgjxriyxhfudiOmnGc1nSCTew98ERN+7NqBzSRXaYZeI+cXXSrX9njj19ue4lD
sXxR03/wGCLrgQcZSuJn/zxEt8Kgl2Vsim8qu8AGOvnarPSnU+usjxeW92iX8yd1
oiZNCB84theR6E7sddmzGdcjV93iThyOe/MGxyoP2jmd6iw9B4jBGwjKFH+AYZsD
7QUuDS4cUF2mVEVkeKXf1ELubX1hcmiQnYP062sehqElXZfp/B92Sr299eYrkbbu
yaVczU/rsjQLRQWdkihqJYaUWGZlYFyMOlsf8dI5DoHfqsm0D0WwfC/FQVwIJog8
Rp0OfwWnqnNMN/dKhimIsfF0cehpP0ogYgA9Jax/xV3Fv1KvWQrmQ+e+cN8I9MaC
GZucOSRDYgK638NZpdFGZczNFQmCkdplrwQtmu9J5IlYaOrRxbkh/aBBbNMgFf09
aOf3lDnsUHYq87gm+E2KZjGHM/nHtRoW3DtR4cLuBKyAqrghYO8=
=Y+uX
-----END PGP SIGNATURE-----

--Jq34OMMVNp9WvB7qGdHNPsRWNZKpwWtD2--
