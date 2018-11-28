Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44072 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbeK2Hhu (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Nov 2018 02:37:50 -0500
Received: by mail-pg1-f193.google.com with SMTP id t13so9998237pgr.11
        for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2018 12:34:57 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <C1954B79-19BD-43A2-AB2E-1F9F3F3A8B8B@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_C0556C68-098A-4B9A-921D-6292D91F2F92";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: RFC: LockDoc - Detecting Locking Bugs in the Linux Kernel
Date: Wed, 28 Nov 2018 13:34:54 -0700
In-Reply-To: <d9a0985e-ea3f-cece-759b-b016fb035056@tu-dortmund.de>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        Al Viro <viro@zeniv.linux.org.uk>
To: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
References: <d9a0985e-ea3f-cece-759b-b016fb035056@tu-dortmund.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_C0556C68-098A-4B9A-921D-6292D91F2F92
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

On Nov 27, 2018, at 3:19 PM, Alexander Lochmann =
<alexander.lochmann@tu-dortmund.de> wrote:
>=20
> Hi folks,
>=20
> during the past months we've been developing LockDoc, a trace-based
> approach of Lock Analysis in the Linux Kernel.
> LockDoc uses execution traces of an instrumented Linux Kernel to
> automatically deduce
> locking rules for all members of arbitrary kernel data structures.
> The traces are gathered running a manually selected fs-specific subset
> of the Linux Test Project in a virtual machine.
> These locking rules can be used to generate a comprehensive locking
> documentation and to reveal potential bugs.


This is quite interesting, and looks useful provided that there is a
workload that exercises the various codepaths.  How long does such an
analysis take to run, and is there a plan to make this functionality
available to developers (e.g. either as a web portal, or to be able
to download the code and run it locally)?

> LockDoc generates rules for each tuple of (data structure, member, =
{r,w}).
> It completely ignores any element of type atomic{,64,long}_t as well =
as
> atomic_*() functions.
> Accesses during initialization and destruction of objects are also =
ignored.
> The output of LockDoc looks like this:
> inode member: i_flags [w] (15 lock combinations)
>  hypotheses: 96
>     15.8% (88 out of 558 mem accesses): EMBOTHER(inode.i_rwsem[w]) ->
> EMBSAME(inode.i_rwsem[w])
>    counterexample.sql.sh inode w:i_flags CEX SEQ
> 'EMBOTHER(inode.i_rwsem[w])' 'EMBSAME(inode.i_rwsem[w])'
>     15.8% (88 out of 558 mem accesses): EMBOTHER(inode.i_rwsem[w])
>    counterexample.sql.sh inode w:i_flags CEX SEQ
> 'EMBOTHER(inode.i_rwsem[w])'
> !    99.8% (557 out of 558 mem accesses): EMBSAME(inode.i_rwsem[w])
> !   counterexample.sql.sh inode w:i_flags CEX SEQ
> 'EMBSAME(inode.i_rwsem[w])'
>      100% (558 out of 558 mem accesses): (no locks held)
>    (no counterexamples to be expected, this hypothesis has 100% =
support
> in the observation set)
>=20
> In this example LockDoc concludes that the lock
> "EMBSAME(inode.i_rwsem[w])" is necessary for writing inode.i_flags.
> EMBSAME stands for the lock embedded in the inode being accessed. In
> this case it is the i_rwsem.
> To be more precise, the write lock (--> "[w]") of i_rwsem is needed.
> Based on this methodology, we can determine code locations that do not
> adhere to the deduced locking rules.
> The reports on rule-violating code include the stack trace and the
> actual locks held.

Looking at the page, it isn't very clear where some of the callpaths go.
For example, in the "writing inode:ext4.i_nlink-__i_nlink" case, it
shows a callpath from vfs_symlink() calling drop_nlink(), but this is =
not
called directly from vfs_symlink().  It is actually going through
dir->i_op->symlink() (ext4_symlink() in our case), so it would be best
to show that dependency.

One minor bug in ext4_symlink() is that it should probably be calling
clear_nlink() to make it clear the link count should be zero, instead
of drop_nlink(), because we don't really want to trigger "remove_count"
and because the later part of this function is using set_nlink(inode, 1)
instead of inc_nlink() that decrements "remove_count" again.  This does
not solve the reported warning, however.

In ext4_orphan_add(), called immediately after drop_nlink(), it checks:

	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
		     !inode_is_locked(inode));

so this is the case where i_state has I_NEW set.  The question is =
whether
it is worthwhile to grab inode_lock() in this code, just to keep the =
lock
checker happy, or whether the code can be annotated to tell the checker
that I_NEW means i_rwsem is not needed.

Cheers, Andreas

>=20
> We've now created a series of bug reports for the following data =
types:
> struct inode (used by ext4), journal_t, and transaction_t.
> We present the counterexamples for each tuple of (data structure,
> member, {r,w}).
> Depending on the complexity of the callgraph, the counterexamples are
> either embedded in the callgraph or the callgraph is shown below them.
> In the latter case, zooming can be enabled via a button in the =
heading.
>=20
> We kindly ask you to have a look at our findings and send us some
> comments back:
> https://ess.cs.tu-dortmund.de/lockdoc-bugs/ml/
>=20
> Our approach has already revealed one real bug and one suspicious
> situation. Both have been confirmed by Jan.
>=20
> Best regards,
> Alex and Horst
>=20
> --
> Technische Universit=C3=A4t Dortmund
> Alexander Lochmann                PGP key: 0xBC3EF6FD
> Otto-Hahn-Str. 16                 phone:  +49.231.7556141
> D-44227 Dortmund                  fax:    +49.231.7556116
> http://ess.cs.tu-dortmund.de/Staff/al
>=20


Cheers, Andreas






--Apple-Mail=_C0556C68-098A-4B9A-921D-6292D91F2F92
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlv+++4ACgkQcqXauRfM
H+DN7xAApHeDhSXh7oJyVS0hk9mNr4ZYKT6LhGA/P777l2hzOS9qb3gq15YNZ/0o
MgjupazqdO/JmY1CLXL5vlywAo/CaFIdUQo7/hPD09+aXc2YVRVbkNagWzMsOzSn
J9050b1hjpqfeOZ2wKwdXPynTT8PLy/BNHldz+HnfBWBa0feZZkvzx3ggXmYUV9v
yYS0Sy/b14w6pRW2tMHakLCAwktAFLaobgD9SDy2mA91fxZnIOx62INQ7l/7MCb1
K6u6hsg2xsh4hcUWEO/PzcCZse7KLZtxXFBjAsEp2R+ZbdC6qOyI2h7L635/ga9F
09xQ8CJjZTS6ZYoqIE2o3Ku8s7CRVpzzu+OIgClhLc0cMR576Ayy70LWArO74cgr
i7g9KTlCWBLqoLRMnh4sn2E29mTQBtWuilBvHXeFLh7G8aqkNjQxNKvFVeTvrmgF
OCIhCtI3Iv7Qg1tnoa6iiKYtVIpmsi2XVyKuNhHjBbopZZnyF/aH2Q8ZMJBY4KCf
wa6GdWMG6WoHKVPN8E6ElyRBUJcwF5pEdl/MMgTQNYhvK4xHSwQc9sa+P//M1voX
vIGLr41TvmPZu7N8mcXoczBmPv1S/+PTKJ5mEPYMLmL5WQk8e0D0UTPTqjkR14jj
kE5w1cBXJImeoTVwyBHHhOLC2xig9QZS/CVxliRD2svJB0r10nM=
=cDsB
-----END PGP SIGNATURE-----

--Apple-Mail=_C0556C68-098A-4B9A-921D-6292D91F2F92--
