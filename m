From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: regression: 4.13 cannot follow symlinks on some ext3 fs
Date: Fri, 24 Nov 2017 15:03:37 -0700
Message-ID: <706E8F37-95C7-4321-AACA-2ED11F82E625@dilger.ca>
References: <20171123203330.GN2482@two.firstfloor.org>
 <20171123222317.bq2v26zm5i2jspui@thunk.org>
 <20171123233101.GP2482@two.firstfloor.org>
 <700971AC-BDE2-4993-BD56-7497AD8A0FC4@dilger.ca>
 <20171124020435.GQ2482@two.firstfloor.org>
 <C656DD8B-7521-4281-8D55-4416A3C75161@dilger.ca>
 <20171124165102.GS2482@two.firstfloor.org>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_0CF782C9-E86E-4942-BBD6-842497731EF0";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>, Tahsin Erdogan <tahsin@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20171124165102.GS2482@two.firstfloor.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_0CF782C9-E86E-4942-BBD6-842497731EF0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 24, 2017, at 9:51 AM, Andi Kleen <andi@firstfloor.org> wrote:
>=20
>> We checked old kernels, and old e2fsprogs, and didn't see any cases
>> where fast (<=3D 60 chars) symlinks were created using external =
blocks.
>> It seems that _something_ did create them, and it would be good to
>> figure that out so we can determine if it is a widespread problem
>=20
> I assume it was the original kernel.
>=20
>>=20
>> I think e2fsck can fix this quite easily, and there really isn't
>> an easy way to revert to the old method if the large xattr feature
>> is enabled.  If you are willing to run a new kernel, you should also
>> be willing to run a new e2fsck.
>=20
> It's obviously not enabled on ext3.
>=20
>> We could probably add a fallback to the old mechanism (and print
>> a one-time warning to upgrade to a newer e2fsck) if an external fast
>> symlink is found and the large xattr  feature is not enabled, which
>> would give more time to fix this (hopefully rare in the wild) case.
>=20
> If the old kernel created it, then likely all the
> /lib{,64}/ld-linux.so.2 symlinks have that, which breaks all ELF
> executables. I suspect in these old file systems it's not particularly =
rare.

Sure, but not many people are going to be running a 4.14 kernel with
a 2007 system.  Could you please run the updated find command to see
whether this is an isolated case, or if it is a common case:

find / -type l -size -60c -print0 | xargs -0r ls -dils | awk '$2 !=3D 0 =
{ print }'

It would also be useful if anyone else reading this that has an old
system (2005-2011 install date) ran the same to see if any such
symlinks are found.  To see when the root filesystem was created, run:

dumpe2fs -h $(df -P / | awk '/dev/ { print $1 }') 2>&1 | grep created

> So I don't think you can just break them all.

Sure.  As previously mentioned, it shouldn't have broken *any* systems
based on our prior investigation, I'm just trying to see how bad the
problem really is.  Like I said, a workaround (without need to patch
the kernel, and that is compatible with old and new kernels) is:

find / -type l -size -60c -print0 | xargs -0r ls -dils | awk '$2 !=3D 0 =
{ print }' |
    while read L; do ln -sfv "$(ls -l "$L" | sed -e 's/.*-> //')" "$L"; =
done

This just recreates any problematic symlinks in place, which should make
it a proper fast symlink.

> I think it's ok to only handle it when the large xattrs are disabled.
>=20
> Requiring new e2fsck on old systems is a bad idea.

Any worse an idea than running a new kernel on an old system?
Newer e2fsck fixes a lot of bugs that are present in older
e2fsck as well...

Cheers, Andreas






--Apple-Mail=_0CF782C9-E86E-4942-BBD6-842497731EF0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFaGJc5pIg59Q01vtYRAroVAKDKU4dgtT9u7fx9gvoA2wov6wzVfwCgxzz8
hvUdjLCDMZJYj7/YIpCevwc=
=X2ZT
-----END PGP SIGNATURE-----

--Apple-Mail=_0CF782C9-E86E-4942-BBD6-842497731EF0--
