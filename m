From: Stefan Bader <stefan.bader@canonical.com>
Subject: The minor heck of using mmcblk and ext4
Date: Thu, 19 Apr 2012 18:37:45 +0200
Message-ID: <4F903F59.6040302@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig77B85B6E0C16457DBAA2F574"
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
	linux-ext4@vger.kernel.org, linux-mmc@vger.kernel.org
Return-path: <linux-mmc-owner@vger.kernel.org>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig77B85B6E0C16457DBAA2F574
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

This had been a bug[1] which I saw when playing around with my Aspire One=
 (which
features a mmc driven card reader) and ext4.

The problem is inherited from the way the mmc driver handles cards on sus=
pend.
So when using a mmcblk device and suspending it is like ejecting the card=
 on
suspend.

The problem gets worse when actually using a filesystem on that device. A=
nd
there is a difference between having the fs mounted by udisk under /media=
 or
having done the mount manually. I suspect that udisk either adds its own =
hooks
into udev events or has some sort of watch on the mount point. At least e=
jecting
the card manually or suspending will usually also an unmount of the fs. T=
his
becomes a bit of a problem when the fs is in use (the simplest form being=
 to
open a shell and changing the current directory into the fs on the card).=
 In
that case the entry in /proc/mounts is gone but some fs structures remain=
=2E

And here one specialty of ext4 strikes: it creates some entries under
/proc/fs/ext4/mmcblk*, /proc/fs/jbd2/mmcblk* and /sys/fs/ext4/mmcblk* (an=
d some
internal kobj) which remain dangling together with the structures. So whe=
n
resuming the user is presented with:

  a) a scary dialog box telling that mount has failed because of (fuzzy r=
eason
     including missing superblocks) which is even more scary because ther=
e has
     been a bug in the past which turned this into reality (good bye data=
).
  b) three WARN messages (including stack trace) to tell about the duplic=
ate
     objects.

Clearly anything that had a file (or directory node) open will be screwed=
 and
receive IO errors when trying any access. So the obvious mount failure ju=
st
makes it very clear that this is a bad place to be in. Or is the expectat=
ion
that users of the old mount should just be getting IO errors and the new =
mount
is supposed to succeed?

I reached a bit my limits of knowledge here (hence the longish email). Sh=
ould
ext4 be expected to find out its backing device is gone and then at least=
 remove
the sysfs and procfs entries related to that? And even if so, how? Or is =
it
better the way it is, so at least the fact that the block device went awa=
y is
clearly visible? I am pretty sure any filesystem has the same first half =
of the
issue (maybe dangling open files) but just don't have anything that preve=
nts
them from being remounted.

There also is a relatively simple way to handle it (when one is aware and=
 knows
about it). The mmc core can be instructed to treat cards as non-removable=

(mmc_core.removable=3D0) which has its own dangers. I thought that still =
on resume
there is a check for the card being the same. I just don't know how relia=
ble (or
how unique the identification is) that is. So while this allows to suspen=
d and
resume without headaches it potentially can cause some more when the card=
 is
replaced without that being detected.

So long story, sort of short question: is there anything that can/should =
be done
or is it just something that cannot be done any better way?

Thanks,
Stefan

[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/913860


--------------enig77B85B6E0C16457DBAA2F574
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCgAGBQJPkD9ZAAoJEOhnXe7L7s6jqWEP/2kr5y23+7QJ41c6fJan+co9
9XEwDLwqig9+XAS/Ln13/74jecwdJW0JqtSTaJxFBkhm6RATzlaoZDDVkAjcXWNI
kMGylNxLqclEgInKwde3rB+seP2p59dEFwQDjodbwxSCcoCGt534y0uPF6mVb3wP
LSrGtrtF26KWZBISaES1wmp3zPCOCEHXtxh/E2Ndw9khebnYgkeXJCClwxixXFVm
tdCiA3haR5KiaKNkbrS4yW5uNvK1N+E6XMolnAa3nQ2NXt9OWgnCsJKGCEzxl0i4
4SeCAaQ/XjulTibl4slT42zuCv81cEg4vibRpLoKI5aDw/jyYe6d0UowvGcsp8HC
XuxbC+EAOOdHpvv64B9a2N/PE/+MqiLQIB5omVxDAJHFRsCQK7emAeBXNIpAXnkO
ItC73NtaRgUKNgx6IBrspEijVIm3nBWhu1XPbQrK/hXXlSInpd0XffyhRRJDFZYw
FJmJePrh8FatOgUH1+oLC1WQqMMr7rYNnY/LHYiWwa2RPlwIWUaZlriLPwwFr8eX
YeSVaH59cwaj4xIr6srJfKSl2Zyx3h33V2kkajEEtD3mKhyDN3oF7JZb6bfyPQWI
0ctTf6lQT8F9okRabW1HKcM4KVo4DE1kw9yNnlprL8Apc+nn+dJbqebT952jeb8s
q1TsJ7wfapw4ORPgCuy1
=T1Cz
-----END PGP SIGNATURE-----

--------------enig77B85B6E0C16457DBAA2F574--
