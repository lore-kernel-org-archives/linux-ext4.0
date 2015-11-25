From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [RFC][PATCH 00/12] Enhanced file stat system call
Date: Wed, 25 Nov 2015 12:30:33 -0700
Message-ID: <E4DB425B-FE04-4A6A-806E-2BAFD0CB498E@dilger.ca>
References: <1502878.QisWlqATFu@merkaba> <20151120145422.18930.72662.stgit@warthog.procyon.org.uk> <4495.1448036915@warthog.procyon.org.uk> <20151125175153.GA30335@fieldses.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_B68A526C-6F35-45DC-8D78-2FC1ED94CD24"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Martin Steigerwald <martin-3kZCPVa5dk2azgQtNeiOUg@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org,
	linux-afs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151125175153.GA30335-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_B68A526C-6F35-45DC-8D78-2FC1ED94CD24
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 25, 2015, at 10:51 AM, J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> =
wrote:
>=20
> On Fri, Nov 20, 2015 at 04:28:35PM +0000, David Howells wrote:
>> Martin Steigerwald <martin-3kZCPVa5dk2azgQtNeiOUg@public.gmane.org> wrote:
>>=20
>>> Any plans to add limitations of filesystem to the call like maximum =
file
>>> size?  I know its mostly relevant for just for FAT32, but on any =
account
>>> rather than trying to write 4 GiB and then file, it would be good to =
at some
>>> time get a dialog at the beginning of the copy.
>>=20
>> Adding filesystem limits can be done.  I got a shopping list of =
things people
>> wanted a while back and I've worked off of that list.  I can add =
other things
>> - that's on of the reasons I left room for expansion.
>=20
> I ran across systemd/src/basic/path-util.c:fd_is_mount_point() the =
other
> day, and the contortions it goes through made me wonder if we should
> also add mnt_id and/or an is_mountpoint boolean--it's annoying to have
> to do name_to_handle_at() (not supported on all filesystems) just to =
get
> mnt_id.
>=20
> (Looking at it now I see it falls back on reading mount id from
> /proc/self/fdinfo/<fd>.  Maybe that's good enough.  May depend on
> whether there's a potential user that doesn't want to assume access to
> /proc?)

IMHO, it should be possible to get information about a file or directory
from the file itself (i.e. statx() or fsinfo() on the path/fd), rather =
than
having to grub around in a /proc file that the application magically has =
to
know about, and parse text files there for every file being handled.

Cheers, Andreas






--Apple-Mail=_B68A526C-6F35-45DC-8D78-2FC1ED94CD24
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVlYMWnKl2rkXzB/gAQj1pBAAmJoSuxeZYOMue7LTxQSPWgCc7hODipqB
+LORj4c+AV3afXJJ4XSiQSh+dVV5tCpGx4vABhqW2lCIy7Y+YScY4kvOCMzxFxZy
d/HJWhVLjzbgq2lMAvytA7GBuVIFZNQiBtI1FkcTeEo3d8BLCApG/yZYvm7ALJs9
4YI2KSvrG44kBMpWBW/heRfvX0BgLpn0kedLlJVTxz7d+fgXv/j7mIKO05Ng6Ehb
nT2gzyI2Dwz7W8rjO8gUhFGgxU73PPvFzBfn2ptgbD8pSRUkI3wKBbXdKXYihqTL
WzqZ/Vjr0o5batxfPbUyR/sKiQSk5oLMFZI40q25dZahxskqlBSpDLbnOy/U1K0m
0nG1Xz900LZXLamMwoi1JSDnL7db7YlG6Aw+C+KZXaZO1AV3bJnCfR0B4A6ZWuNJ
+xlU8fk9IOn/Y9hvOiF/UBtiC6jY4Yd7NvXG6YmpafpD+9PIHYhWXYDukuCn0JVv
T8a89zZJRsrqp9DaH44YAYDFUZ8YwwiIuvNRLrq9fj1PqassssNuFIKy/dkCssf6
asD2kRgMe9n9gBgnMgIiUS1q+S6eprfz6MYEwQEZXDFtKwh1/2q0QYQyelZeq4St
T2mracgunRl9sZmq2l9YGxukw2VBq0Xdk8QRyRPUVZmlbW9GN6rjCv9zRJdQjDxZ
h8Gg+9uxENU=
=fM4h
-----END PGP SIGNATURE-----

--Apple-Mail=_B68A526C-6F35-45DC-8D78-2FC1ED94CD24--
