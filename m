From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: libcom_err DSO version bump needed for 1.42?
Date: Thu, 16 Aug 2012 08:01:35 -0400
Message-ID: <502CE11F.6090605@interlinx.bc.ca>
References: <k0h5eu$f6u$1@ger.gmane.org> <20120816014735.GA3781@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1666727E0C739FC896138652"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47666 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab2HPMBs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Aug 2012 08:01:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1T1ylm-00044h-F1
	for linux-ext4@vger.kernel.org; Thu, 16 Aug 2012 14:01:46 +0200
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 16 Aug 2012 14:01:46 +0200
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 16 Aug 2012 14:01:46 +0200
In-Reply-To: <20120816014735.GA3781@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1666727E0C739FC896138652
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12-08-15 09:47 PM, Theodore Ts'o wrote:
>

Hi Ted,

> There's a distinction which needs to be made between adding a new
> symbol to a DSO, and making an incompatible chnage to the ABI of an
> existing symbol of a DSO.  The former doesn't break any existing
> programs (although you need to make sure you have a sufficiently new
> version of the library for executables which use the newer symbols).
> The latter does break previously existing programs that were linked
> against the DSO.

Ahhh.  That's a fair point.

> It is indeed up to packaging systems to do the right thing vis-a-vis
> having the correct dependencies in their packages.  Debian/dpkg does
> this automatically.  Note the current set of dependencies for the
> e2fsprogs package in Debian:
>=20
> Pre-Depends: e2fslibs (=3D 1.42.5-1), libblkid1 (>=3D 2.17.2), libc6 (>=
=3D 2.11), libcomerr2 (>=3D 1.42~WIP-2011-10-05-1), libss2 (>=3D 1.34-1),=
 libuuid1 (>=3D 2.16), util-linux (>=3D 2.15~rc1-1)
>=20
> It does this by maintaining a list of symbols and the version when it
> was first introduced.

I see.  I am familiar with Debian's packaging but have not really delved
into it's shared symbol dependency handling.  That is indeed
interesting.  Funny enough, I was thinking about something along those
lines (albeit in respect of RPM dependencies) independently while I was
working through this issue -- that is tracking the symbols from release
to release automagically.

> Debian has packaging tools which will examine all of the symbols used
> by the executables in a package, compare it against the .symbols file
> for the library, and then determine the appropriate minimum version
> needed for that library, and insert it into the package.

Yeah.  It is neat.  On a bit of a tangent (which we don't have to get
into here.  I am sure I can research it independently if I really feel a
need to know) given what's in the *.symbols files, I can't see how those
tools track an ABI change though.  There's no function "signature" to
compare.  Maybe they leave ABI changes up to the developer to recognize
and bump the DSO manually.

> If another package uses libcomerr2, but doesn't use the new
> set_com_err_gettext() function, then the versioned dependency for that
> package might be for an older version of libcomerr2.  And all of this
> is done automgically by the Debian dpkg tools.  Cool!!

It is cool, yes.

> Unfortunately, RPM doesn't seem to do this automatically.

At the same level of granularity, it seems you are correct.  But RPM
does have automatic shared library dependency processing.  RPM's
automatic shared library dependency information calculations are based
entirely off of DSO versions (i.e. e2fsprogs Depends on
libcom_err.so.2()(64bit) -- which is calculated automatically by RPM),
which is why I thought that bumping the DSO would solve the RPM
packaging problems.  Well, it would solve them, but as you point out,
adding a symbol may not necessarily be enough reason to bump the DSO
version -- packaging problems aside.

> It looks
> like you have to explicitly specify these dependencies in the spec
> file.  Currently the e2fsprogs spec file for Fedora seems to mandate
> that e2fslibs must match the version of e2fsprogs exactly, while any
> version of libcomerr2 will do.

Well, yes, that's what the spec mandates.  But RPM's automatic shared
library dependency processor will insert an implicit "Depends:
libcom_err.so.2()(64bit)", so not really *any* libcommerr2, but yes, any
DSO version 2 libcommerr2 will do.

> If we were to change the DSO version number, it would break older
> executables that didn't use this new symbol,

Yeah.  This is usually solved by allowing multiple versions of the
shared library to co-exist.  i.e. libcomm_err.so.2 and libcomm_err.so.3,
etc.  But that requires packaging libraries with their DSO version in
the name.  i.e. package names libcommerr2, libcommerr3, etc.  The
libcommerr2 package would install libcomm_err.so.2 and the libcommerr3
package would install libcomm_err.so.3 and both could co-exist.

> and given that the
> dependency management in the RPM spec file is all horribly manual,

Well, not _all_ manual.  There is the above mentioned automatic DSO
dependency information that matches library RPMs to tool RPMs.  That is,
*if* the DSO version were bumped, this would all just automatically work
with RPM even without having to specify manual dependencies.  Again,
which is why simply bumping the DSO looked so inviting to me.

> it
> wouldn't help you, since you'd have to manually adjust the dependency
> in the spec file anyway.

Well, again, no, per the above.

But to be clear, I am not necessarily using RPM's weakness (as compared
to Debian's dpkg that is, in tracking shared library versions) here as a
case to bump the libcommerr2 DSO, but just trying to clear up the
[mis-]perceptions of RPM's ability with regard to automatically
providing shared library dependency tracking.  It can do it.  It just
depends on DSO version bumping, even for adding new symbols to the librar=
y.

> Anyway, this is a packaging bug, and Debian provides a worked example
> about how this can be done completely automatically, without needing
> any special handling by the release engineer.

Yeah.

> Why RPM doesn't follow
> Debian's lead by having an automated system

Well, it does.  It's just not as granular as Debian's and seems to
expect that additions to a DSO will cause a DSO version bump.  I wonder
what the RPM developers' perspective on this is, especially given that
Debian has provided a working example of how simply adding symbols and
not bumping the DSO version can still work with packaging.

> is not something I've ever
> understood (but there's a reason why I use Debian and not
> Fedora.... and it's not just the abomination which is GNOME 3 / GNOME O=
S).

Oh lord.  Don't get me started on the abomination which is GNOME 3.  :-)
 Fortunately Cinnamon brings back some level of usability to GNOME 3
with it's new/replacement shell.

Cheers,
b.


--------------enig1666727E0C739FC896138652
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlAs4R8ACgkQl3EQlGLyuXCkMACgrY1tOQdDOAkzb81D4+cP3wru
/ogAoI5intmN+qQk9E8NDEebh2QuKD3B
=M6je
-----END PGP SIGNATURE-----

--------------enig1666727E0C739FC896138652--

