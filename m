From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Ext4: deadlock occurs when running fsstress and ENOSPC errors are seen.
Date: Tue, 15 Apr 2014 23:22:44 -0600
Message-ID: <6A1FB0B1-7B06-408A-B019-46E10782D981@dilger.ca>
References: <CADDb1s2RvN_S+abFXCe4ZhZPKZgP_PiocJdpiLzRC_Se5sgVVg@mail.gmail.com> <20140415124743.GD3403@thunk.org> <CADDb1s3HYDvb51Ngrwk82gkpbUWg1bRo7kaUmbGRmb0g_9JKgw@mail.gmail.com> <20140416050729.GD21807@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: multipart/signed; boundary="Apple-Mail=_8F628ABD-E5FE-42AB-AE97-6F9E40EC74FE"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>, Jan Kara <jack@suse.cz>,
	darrick.wong@oracle.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Namjae Jeon <linkinjeon@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140416050729.GD21807@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_8F628ABD-E5FE-42AB-AE97-6F9E40EC74FE
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

On Apr 15, 2014, at 11:07 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Apr 16, 2014 at 10:30:10AM +0530, Amit Sahrawat wrote:
>> 4)	Corrupt the block group =911=92  by writing all =911=92, we had =
one file
>> with all 1=92s, so using =91dd=92 =96
>> dd if=3Di_file of=3D/dev/sdb1 bs=3D4096 seek=3D17 count=3D1
>> After this mount the partition =96 create few random size files and =
then
>> ran =91fsstress,
>=20
> Um, sigh.  You didn't say that you were deliberately corrupting the
> file system.  That wasn't in the subject line, or anywhere else in the
> original message.
>=20
> So the question isn't how the file system got corrupted, but that
> you'd prefer that the system recovers without hanging after this
> corruption.
>=20
> I wish you had *said* that.  It would have saved me a lot of time,
> since I was trying to figure out how the system had gotten so
> corrupted (not realizing you had deliberately corrupted the file
> system).

Don't we check the bitmaps upon load to verify they are not bogus?
Looks like this is disabled completely if flex_bg is enabled, though
I guess that it is not impossible to do some checking even if flex_bg
is enabled.

For example, we have the background thread to do the inode table =
zeroing,
and it could load the block bitmaps and check the group descriptors for
itable and bitmap locations against the various bitmaps.  With flex_bg,
this would probably only load a small subset of block bitmaps.

> So I think if you run "tune2fs -e remount-ro /dev/sdb1" before you
> started the fsstress, the file system would have remounted the
> filesystem read-only at the first EXT4-fs error message.  This would
> avoid the hang that you saw, since the file system would hopefully
> "failed fast", before th euser had the opportunity to put data into
> the page cache that would be lost when the system discovered there was
> no place to put the data.

Even without remount-ro, it would be possible to flag the block bitmaps
for a particular group as corrupt, so that no new allocations are done
from that group until the next e2fsck is run.

Cheers, Andreas






--Apple-Mail=_8F628ABD-E5FE-42AB-AE97-6F9E40EC74FE
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU04TpXKl2rkXzB/gAQKYaw/+NtP9/Vlka8uAo2tgxO7/NXrGVP2WgPuc
mEh0I1ceBViq49e4ht7RSpvIWaaXOkFNYJ8uR9AeGTNMAn4sMzcR/21NBSYJPwSd
C5pNcMW5UzLqIAtkVaYShj6M2SDxtN07basNHuYHBWd8q/dttrbidKNqj5lV/K0L
lDfiIGO4hNdZxpGkXqcYph2kjle3AmpF+fZqpMtFxRiGNdQv+nd1phWZguXx+Gmz
7rOjmqG0JxW242+WlhuKSxkPtoWU4EtuD41BIoKa84Hq83jVsPr3+9vTG3PaI+3N
4ZToRFnm64zzDNujtUE+26QoKnh2ITnKXpmtY/e4DfgshmuTjPZePvk9tc4X+cnb
FKpouYsMVwq+d9Sf0Fq/h3At18XGqO5Qzyo4zb0W+q+rMgW2r6KB32lVCjFzxAmJ
ZFjKqfpGet9X8wLLxgCjV2nac5Y3U+IVXHlv0lOPhoLjBagQilS+UQPyw4Z7YTJ4
obu3nwqGS8tuqAt6UaaNfAGWCGCxPlBgEBSGF920dSn5mNc9sdazb8nisOPJnHjK
hsgNCQPyBFUqGBbLehFgCzhjuvne+ytodcxrgnEc/2B2ZKwwgXFoqL//8qk111YN
D+fVY0QyVIXGqi6DolzdL2dxIQXwAcd02AklXbqfLNArBVp1iWgrXcb7DTShUmyw
OcozekrfS58=
=ClbG
-----END PGP SIGNATURE-----

--Apple-Mail=_8F628ABD-E5FE-42AB-AE97-6F9E40EC74FE--
