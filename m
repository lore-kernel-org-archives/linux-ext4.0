Return-Path: <SRS0=F3Rs=OG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx1.hrz.uni-dortmund.de ([129.217.128.51]:43177 "EHLO
        unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbeK1JTV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Nov 2018 04:19:21 -0500
From: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
To: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>
Subject: RFC: LockDoc - Detecting Locking Bugs in the Linux Kernel
Message-ID: <d9a0985e-ea3f-cece-759b-b016fb035056@tu-dortmund.de>
Date: Tue, 27 Nov 2018 23:19:54 +0100
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="1ebPpA1XF303Zoa3rZ4EH4qiegHQe8MZt"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1ebPpA1XF303Zoa3rZ4EH4qiegHQe8MZt
Content-Type: multipart/mixed; boundary="qdT6q3GaUz0IZc2xL12ytd5oh6OeUuef7";
 protected-headers="v1"
From: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
To: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>,
 Horst Schirmeier <horst.schirmeier@tu-dortmund.de>
Message-ID: <d9a0985e-ea3f-cece-759b-b016fb035056@tu-dortmund.de>
Subject: RFC: LockDoc - Detecting Locking Bugs in the Linux Kernel

--qdT6q3GaUz0IZc2xL12ytd5oh6OeUuef7
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

during the past months we've been developing LockDoc, a trace-based
approach of Lock Analysis in the Linux Kernel.
LockDoc uses execution traces of an instrumented Linux Kernel to
automatically deduce
locking rules for all members of arbitrary kernel data structures.
The traces are gathered running a manually selected fs-specific subset
of the Linux Test Project in a virtual machine.
These locking rules can be used to generate a comprehensive locking
documentation and to reveal potential bugs.

LockDoc generates rules for each tuple of (data structure, member, {r,w})=
=2E
It completely ignores any element of type atomic{,64,long}_t as well as
atomic_*() functions.
Accesses during initialization and destruction of objects are also ignore=
d.
The output of LockDoc looks like this:
inode member: i_flags [w] (15 lock combinations)
  hypotheses: 96
     15.8% (88 out of 558 mem accesses): EMBOTHER(inode.i_rwsem[w]) ->
EMBSAME(inode.i_rwsem[w])
    counterexample.sql.sh inode w:i_flags CEX SEQ
'EMBOTHER(inode.i_rwsem[w])' 'EMBSAME(inode.i_rwsem[w])'
     15.8% (88 out of 558 mem accesses): EMBOTHER(inode.i_rwsem[w])
    counterexample.sql.sh inode w:i_flags CEX SEQ
'EMBOTHER(inode.i_rwsem[w])'
!    99.8% (557 out of 558 mem accesses): EMBSAME(inode.i_rwsem[w])
!   counterexample.sql.sh inode w:i_flags CEX SEQ
'EMBSAME(inode.i_rwsem[w])'
      100% (558 out of 558 mem accesses): (no locks held)
    (no counterexamples to be expected, this hypothesis has 100% support
in the observation set)

In this example LockDoc concludes that the lock
"EMBSAME(inode.i_rwsem[w])" is necessary for writing inode.i_flags.
EMBSAME stands for the lock embedded in the inode being accessed. In
this case it is the i_rwsem.
To be more precise, the write lock (--> "[w]") of i_rwsem is needed.
Based on this methodology, we can determine code locations that do not
adhere to the deduced locking rules.
The reports on rule-violating code include the stack trace and the
actual locks held.

We've now created a series of bug reports for the following data types:
struct inode (used by ext4), journal_t, and transaction_t.
We present the counterexamples for each tuple of (data structure,
member, {r,w}).
Depending on the complexity of the callgraph, the counterexamples are
either embedded in the callgraph or the callgraph is shown below them.
In the latter case, zooming can be enabled via a button in the heading.

We kindly ask you to have a look at our findings and send us some
comments back:
https://ess.cs.tu-dortmund.de/lockdoc-bugs/ml/

Our approach has already revealed one real bug and one suspicious
situation. Both have been confirmed by Jan.

Best regards,
Alex and Horst

--=20
Technische Universit=C3=A4t Dortmund
Alexander Lochmann                PGP key: 0xBC3EF6FD
Otto-Hahn-Str. 16                 phone:  +49.231.7556141
D-44227 Dortmund                  fax:    +49.231.7556116
http://ess.cs.tu-dortmund.de/Staff/al


--qdT6q3GaUz0IZc2xL12ytd5oh6OeUuef7--

--1ebPpA1XF303Zoa3rZ4EH4qiegHQe8MZt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEElhZsUHzVP0dbkjCRWT7tBbw+9v0FAlv9wwoACgkQWT7tBbw+
9v0ytRAAwZqi7VNDy9xBvUyO2lZyLkBUifGacaMGs8oN1IXqJac65T1+Eobawobt
IRvHef27Nba2WEjLP4VP+jehPlGZEf6gVxbEV4NlSp+Rk06qHrhtcSVNo29P0CrP
1snRf+B3XKCHCd2w6RPvOAzGU8ON353DKwRalyOjtVQvcoJqhU1/v0N36u2a3C+O
prlEzwu4dapw9SqywO5Kf2SRGb+5T9p3sj/zVwsHEZCrVeRTQ8K7GAQx7r48o1zj
yFWasx7amYL5hhBHniyE90N5rbfXFCxOtSL2fXbrU8HmL791UKXydHe68kFNUE+a
BC3JKey1h519+YZdC1FuEdIbHGaFnFb6njbFtow8YfLIA/QvFWSL5ZHJ8o/sFHx7
QAcS0Fp8c/eNKaAISrJPsJizeKQJvQbXN/1xUWCipfwRRgDJdQVV0V6hRZMDyfAP
38qTOOuZjgD/NznRtC/Br/SrSQqOv6mGGsFNAS1kmWh4CN46l9DwpWBvVMUEypoc
otKltoofhj3LVLzh6CWLtNH35Id7e3paKDXNZZb/PTzJRnmQsOnUw4mROG2RqvDB
DPbTZma63KZ9n/1vUg+nsubOf2OLckYZFSN+HaLdMDEhk9FS+ErA538k9EXg8KEV
uBWG7sGSPC2Wpx/+xajSMHvH4SmZqFQ+edb/saPr4KZxOen7gUI=
=yRcn
-----END PGP SIGNATURE-----

--1ebPpA1XF303Zoa3rZ4EH4qiegHQe8MZt--
