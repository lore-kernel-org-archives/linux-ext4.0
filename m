From: Bernd Schubert <bschubert@ddn.com>
Subject: Re: ext4_clear_journal_err: Filesystem error recorded from previous
 mount: IO failure
Date: Sun, 24 Oct 2010 16:42:25 +0200
Message-ID: <4CC445D1.10908@ddn.com>
References: <201010221533.29194.bs_lists@aakef.fastmail.fm> <20101023222605.GC24650@thunk.org> <201010240156.02655.bs_lists@aakef.fastmail.fm> <201010240220.46113.bs_lists@aakef.fastmail.fm> <20101024010859.GE24650@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig1D9F9B1960DBE95EC905428F"
Cc: Bernd Schubert <bs_lists@aakef.fastmail.fm>,
	Amir Goldstein <amir73il@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.datadirectnet.com ([74.62.46.229]:4854 "EHLO
	mail.datadirectnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab0JXOma (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Oct 2010 10:42:30 -0400
In-Reply-To: <20101024010859.GE24650@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--------------enig1D9F9B1960DBE95EC905428F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/24/2010 03:08 AM, Ted Ts'o wrote:
> On Sun, Oct 24, 2010 at 02:20:45AM +0200, Bernd Schubert wrote:
>> Hmm, maybe we have a mis-understanding here. If we could make e2fsck
>> to *only* recovery the journal, that would be perfect. Kernel and
>> e2fsck journal recovery should take approximately the same time. But
>> that option does not exist yet (well, a half baken patch is on my
>> disk now). If e2fsck then would detect as the kernel:
>> "clear_journal_err: Filesystem error recorded from previous mount"
>> and mark the filesystem with an error, that would be all we need to
>> then abort the mount in the pacemaker script and allow us to run a
>> real e2fsck outside of pacemaker.
>=20
> What probably makes sense is to have an extended option which causes
> e2fsck to just run the journal and then exit.  Part of running the
> journal should be setting the EXT4_ERROR_FS bit in s_mount_state and
> then clearning the journal.  That seems to be missing entirely from
> e2fsck, which is a bug that we should fix regardless.

Adding the journal option is simple, I will provide a patch by Wednesday
or Thursday. Will also check if it sets EXT2_ERROR_FS and if not, will
try to find some time to add that.

>=20
> As far as detecting whether or not the file system has known errors,
> you can do that by using dumpe2fs -h and grepping for "Filesystem
> state".  That can have the values "clean" or "with errors".  (For ext2
> file systems, or ext4 file systems without a journal, you can also
> have the state "not clean" and "not clean with errors", but if you
> have a journal the latter two states shouldn't ever come up.)

I added exactly that to our lustre_server pacemaker agent last week :)
And when I noticed it still mounts filesystems with errors, I started
this thread here.


>=20
> That way the logic that you want is something you can build into your
> script, and we don't need to embed application specific logic into
> e2fsprogs.  The ability to just run the journal without doing any
> further checking seems like a reasonable thing to add to e2fsck ---
> and by using dumpe2fs -h you'll be able to detect all possible file
> system errors (not just the ones which are reported via the journal
> error system).
>=20
> Does that sound reasonable to you?

Yes, we perfectly agree on each other now :)

Thanks,
Bernd


--------------enig1D9F9B1960DBE95EC905428F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzERdEACgkQqh74FqyuOzRdOACgmeI4x5ppkBubGKmE8j3C6FFK
ssUAoIycdnj3+kxDioREUZXWH21cX/zN
=Dk6O
-----END PGP SIGNATURE-----

--------------enig1D9F9B1960DBE95EC905428F--
