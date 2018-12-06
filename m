Return-Path: <SRS0=bC55=OP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx1.hrz.uni-dortmund.de ([129.217.128.51]:37249 "EHLO
        unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727704AbeLFOWM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Dec 2018 09:22:12 -0500
To: Andreas Dilger <adilger@dilger.ca>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <d9a0985e-ea3f-cece-759b-b016fb035056@tu-dortmund.de>
 <C1954B79-19BD-43A2-AB2E-1F9F3F3A8B8B@dilger.ca>
From: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
Subject: Re: RFC: LockDoc - Detecting Locking Bugs in the Linux Kernel
Message-ID: <ea04c0eb-4c8f-ee5a-461a-ec7f61a59006@tu-dortmund.de>
Date: Thu, 6 Dec 2018 15:22:01 +0100
MIME-Version: 1.0
In-Reply-To: <C1954B79-19BD-43A2-AB2E-1F9F3F3A8B8B@dilger.ca>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="xBKPtXTJKOpoCmDap5cqNGuZ9Hff79f7O"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xBKPtXTJKOpoCmDap5cqNGuZ9Hff79f7O
Content-Type: multipart/mixed; boundary="o2cAPfO6L4mqoPsu1Xm6L04HxvznOvg01";
 protected-headers="v1"
From: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, Jan Kara
 <jack@suse.cz>, Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
 Al Viro <viro@zeniv.linux.org.uk>
Message-ID: <ea04c0eb-4c8f-ee5a-461a-ec7f61a59006@tu-dortmund.de>
Subject: Re: RFC: LockDoc - Detecting Locking Bugs in the Linux Kernel
References: <d9a0985e-ea3f-cece-759b-b016fb035056@tu-dortmund.de>
 <C1954B79-19BD-43A2-AB2E-1F9F3F3A8B8B@dilger.ca>
In-Reply-To: <C1954B79-19BD-43A2-AB2E-1F9F3F3A8B8B@dilger.ca>

--o2cAPfO6L4mqoPsu1Xm6L04HxvznOvg01
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable



Am 28.11.18 um 21:34 schrieb Andreas Dilger:
> On Nov 27, 2018, at 3:19 PM, Alexander Lochmann <alexander.lochmann@tu-=
dortmund.de> wrote:
>>
>> Hi folks,
>>
>> during the past months we've been developing LockDoc, a trace-based
>> approach of Lock Analysis in the Linux Kernel.
>> LockDoc uses execution traces of an instrumented Linux Kernel to
>> automatically deduce
>> locking rules for all members of arbitrary kernel data structures.
>> The traces are gathered running a manually selected fs-specific subset=

>> of the Linux Test Project in a virtual machine.
>> These locking rules can be used to generate a comprehensive locking
>> documentation and to reveal potential bugs.
>=20
>=20
> This is quite interesting, and looks useful provided that there is a
> workload that exercises the various codepaths.  How long does such an
> analysis take to run, and is there a plan to make this functionality
> available to developers (e.g. either as a web portal, or to be able
> to download the code and run it locally)?
It takes ~34 min to gather the trace, and another 4,5h to process it.
Yes, we intend to release our project. However, we do not have a
schedule yet.
>=20
>> LockDoc generates rules for each tuple of (data structure, member, {r,=
w}).
>> It completely ignores any element of type atomic{,64,long}_t as well a=
s
>> atomic_*() functions.
>> Accesses during initialization and destruction of objects are also ign=
ored.
>> The output of LockDoc looks like this:
>> inode member: i_flags [w] (15 lock combinations)
>>  hypotheses: 96
>>     15.8% (88 out of 558 mem accesses): EMBOTHER(inode.i_rwsem[w]) ->
>> EMBSAME(inode.i_rwsem[w])
>>    counterexample.sql.sh inode w:i_flags CEX SEQ
>> 'EMBOTHER(inode.i_rwsem[w])' 'EMBSAME(inode.i_rwsem[w])'
>>     15.8% (88 out of 558 mem accesses): EMBOTHER(inode.i_rwsem[w])
>>    counterexample.sql.sh inode w:i_flags CEX SEQ
>> 'EMBOTHER(inode.i_rwsem[w])'
>> !    99.8% (557 out of 558 mem accesses): EMBSAME(inode.i_rwsem[w])
>> !   counterexample.sql.sh inode w:i_flags CEX SEQ
>> 'EMBSAME(inode.i_rwsem[w])'
>>      100% (558 out of 558 mem accesses): (no locks held)
>>    (no counterexamples to be expected, this hypothesis has 100% suppor=
t
>> in the observation set)
>>
>> In this example LockDoc concludes that the lock
>> "EMBSAME(inode.i_rwsem[w])" is necessary for writing inode.i_flags.
>> EMBSAME stands for the lock embedded in the inode being accessed. In
>> this case it is the i_rwsem.
>> To be more precise, the write lock (--> "[w]") of i_rwsem is needed.
>> Based on this methodology, we can determine code locations that do not=

>> adhere to the deduced locking rules.
>> The reports on rule-violating code include the stack trace and the
>> actual locks held.
>=20
> Looking at the page, it isn't very clear where some of the callpaths go=
=2E
> For example, in the "writing inode:ext4.i_nlink-__i_nlink" case, it
> shows a callpath from vfs_symlink() calling drop_nlink(), but this is n=
ot
> called directly from vfs_symlink().  It is actually going through
> dir->i_op->symlink() (ext4_symlink() in our case), so it would be best
> to show that dependency.
Thanks for pointing us to a GCC bug. :) Since drop_nlink() is a leaf
function, GCC 8.2 does not generate the frame pointer code - even with
CONFIG_FRAME_POINTER set. Using GCC 7.3 "fixes" this.
(Disable -regparm=3D3 would also "fix" this issue with GCC 8.2. Since thi=
s
concerns the kernel abi, this is not an option...)
>=20
> One minor bug in ext4_symlink() is that it should probably be calling
> clear_nlink() to make it clear the link count should be zero, instead
> of drop_nlink(), because we don't really want to trigger "remove_count"=

> and because the later part of this function is using set_nlink(inode, 1=
)
> instead of inc_nlink() that decrements "remove_count" again.  This does=

> not solve the reported warning, however.
>=20
> In ext4_orphan_add(), called immediately after drop_nlink(), it checks:=

>=20
> 	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
> 		     !inode_is_locked(inode));
>=20
> so this is the case where i_state has I_NEW set.  The question is wheth=
er
> it is worthwhile to grab inode_lock() in this code, just to keep the lo=
ck
> checker happy, or whether the code can be annotated to tell the checker=

> that I_NEW means i_rwsem is not needed.
Who can help us here?
But it basically is a bug?

Cheers,
Alex
>=20
> Cheers, Andreas
>=20
>>
>> We've now created a series of bug reports for the following data types=
:
>> struct inode (used by ext4), journal_t, and transaction_t.
>> We present the counterexamples for each tuple of (data structure,
>> member, {r,w}).
>> Depending on the complexity of the callgraph, the counterexamples are
>> either embedded in the callgraph or the callgraph is shown below them.=

>> In the latter case, zooming can be enabled via a button in the heading=
=2E
>>
>> We kindly ask you to have a look at our findings and send us some
>> comments back:
>> https://ess.cs.tu-dortmund.de/lockdoc-bugs/ml/
>>
>> Our approach has already revealed one real bug and one suspicious
>> situation. Both have been confirmed by Jan.
>>
>> Best regards,
>> Alex and Horst
>>
>> --
>> Technische Universit=C3=A4t Dortmund
>> Alexander Lochmann                PGP key: 0xBC3EF6FD
>> Otto-Hahn-Str. 16                 phone:  +49.231.7556141
>> D-44227 Dortmund                  fax:    +49.231.7556116
>> http://ess.cs.tu-dortmund.de/Staff/al
>>
>=20
>=20
> Cheers, Andreas
>=20
>=20
>=20
>=20
>=20

--=20
Technische Universit=C3=A4t Dortmund
Alexander Lochmann                PGP key: 0xBC3EF6FD
Otto-Hahn-Str. 16                 phone:  +49.231.7556141
D-44227 Dortmund                  fax:    +49.231.7556116
http://ess.cs.tu-dortmund.de/Staff/al


--o2cAPfO6L4mqoPsu1Xm6L04HxvznOvg01--

--xBKPtXTJKOpoCmDap5cqNGuZ9Hff79f7O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEElhZsUHzVP0dbkjCRWT7tBbw+9v0FAlwJMIkACgkQWT7tBbw+
9v0U/BAA1KJLD+BplR+ShYUgL5o5pavIg4tXxZd571mP6LsivwWPoKO2l9RIjUCx
52y9+GQUwn9CyOfVhdBMNO3U5EvtbbiEVf078+C2voIxX5+k3KOqtncHj6Gut4T/
FjHcvKVrRGK4h7+RPl6sXObPVYbNvJyPDFfZ2UEXzdZxLgjjkYiRSeyZvEz6hBSf
UrYhqdrnobKJMkJlnk3TqXkKVUZKY6HRW+aLKimAXVrd2eLWGI3siDBHqvZZmWFy
DRXzy0bjPojaSLZvma/dP2XbYUJvHLO8yrItoBoizay72uHd9QygmypzlEKGSGxS
CIa3okGvY6FE5urjwUU5qNXcgycm4aBk54Gz0j4rEI7CA5oKOq5+EGnpVPBofV5c
z1k2AWbHYa1N/O4GlA0B6VRK3rOBswfFg3weD0pwSEDIgh079i7xriecvo9c01uv
xb8c72x+dNRN2nKJ/YVcBZbwxdJ5Df0ibfOYQW3NPEWmxXurJ6e8a15UyVOG/7kr
Z9FjMk2cfuGoAgUDlpiqCyqeIYgeNu3PIw3rznQvHykTmhxm8Qiqh/lURFpsUkAh
/HFOd7P+EsQ4vlTGOKplwuLbaeuJSK8eR1P7MalqFkZu8ly50OSOGk1pofEBQ6kF
46XvvtFZ3fZ50XvMt/CU/C/qWoYn+bTDBpnNArZ8Tnpc9AtxehQ=
=cDBb
-----END PGP SIGNATURE-----

--xBKPtXTJKOpoCmDap5cqNGuZ9Hff79f7O--
