From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: CVE Request - Linux kernel (multiple versions) ext2/ext3 filesystem DoS
Date: Thu, 31 Mar 2016 09:47:34 -0600
Message-ID: <B942CDE1-651E-43D2-82F1-8E110D6EB228@dilger.ca>
References: <f4df42b35dd9a6c8c6851eba66b2b3f1.squirrel@webmail-etu.univ-nantes.fr> <1459286067.2596.18.camel@debian.org> <57514A3C-DBAD-4E5E-98EA-23E490629C02@dilger.ca> <20160330204304.GD6207@thunk.org> <CANO=Ty1OcZ=ukxttq9A9M9ot78jDPzDmq4y1NGUMAQmSiveH_g@mail.gmail.com>
Reply-To: oss-security-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_4AFB059B-0F04-429D-87A2-60C052AD286E"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: oss-security <oss-security-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>,
 Yves-Alexis Perez <corsac-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>,
 Theodore Tso <tytso-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kurt Seifried <kseifried-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <oss-security-return-19188-gcsos-oss-security=m.gmane.org-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>
List-Post: <mailto:oss-security-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>
List-Help: <mailto:oss-security-help-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <mailto:oss-security-unsubscribe-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>
List-Subscribe: <mailto:oss-security-subscribe-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>
In-Reply-To: <CANO=Ty1OcZ=ukxttq9A9M9ot78jDPzDmq4y1NGUMAQmSiveH_g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

--Apple-Mail=_4AFB059B-0F04-429D-87A2-60C052AD286E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 31, 2016, at 8:53 AM, Kurt Seifried <kseifried-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>=20
>=20
>=20
> On Wed, Mar 30, 2016 at 2:43 PM, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org> wrote:
>=20
>> You can mount the file system with "mount -o errors=3Dcontinue" and =
this
>> will override the default behavior specified in the super block.
>>=20
>> I would argue that a Desktop or server system that had automount
>> should either (a) mount with -o errors=3Dcontinue, or (b) force an =
fsck
>> on the file system before mounting it.
>=20
> The problem is that:
>=20
> a) means I'll be mounting filesystems with errors that I may want to =
know about (but not have my  system panic about)
>=20
> b) fsck takes a long time on large disks (the smallest size of disk I =
buy for USB drives is 1TB, if I fsck every time I plug one in I'll die =
of old age).

Two options that I think are fairly straight forward to fix this:
- add /sbin/mount.{ext2,ext3,ext4} helpers that add "errors=3Dremount-ro"
  when a non-root user mounts the filesystem. I think =
"errors=3Dremount-ro"
  is safer than "errors=3Dcontinue" since it blocks all later attempts =
to
  modify the filesystem, otherwise there may be further corruption and
  more risk of hitting an unhandled error condition.
- add a check in ext4_fill_super() to change EXT4_ERRORS_PANIC =
superblock
  option to EXT4_ERRORS_RO if mounted by a non-root user

>> So I think this is a particularly meaningless CVE, which is why I =
have
>> zero respect for people who try to make any kind of conclusion based
>> on CVE counts.   I certainly don't plan to do anything about this.
>=20
> As for your comments on CVE counting even the then head of CVE @mitre =
told people not to rely on CVE counting for vulnerability stats:
>=20
> =
https://media.blackhat.com/us-13/US-13-Martin-Buying-Into-The-Bias-Why-Vul=
nerability-Statistics-Suck-Slides.pdf
>=20
> As for your comment on not fixing this: I think fundamentally I should =
be able to plug a file system in and try to mount it with =
default/reasonable options and NOT have my system panic. File system =
handling code, like any code that handles user supplied data should be =
able to handle garbage gracefully and securely. At worst it should try =
to mount and go "derp, it's messed up, maybe fsck it?"

I think this is a legitimate problem to fix.  The main question is how =
complex
it is to fix?  I just don't know enough about the increasing number of =
ways
that userspace can mount a filesystem to know how to detect this =
correctly in
the kernel.

It may be that "non-root user" in the options above should be "removable =
media"
instead?  Knowing the intent of the user/sysadmin is difficult.

Cheers, Andreas






--Apple-Mail=_4AFB059B-0F04-429D-87A2-60C052AD286E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVv1Gl3Kl2rkXzB/gAQhdsQ/+IlxT8/4IkJhGqaW51LyKKjIbSg0hj/S0
GN25lpc7vrrjHBsIWUVl+/CDoPeXFSrHpvfPdUmx+J3038RRbG/2BPD/MtHoAZTN
gKVVNOKeSTzOQINtk1EO+vbDVMP8P3NIbl6T+EWs3GUt20gGcg+0IRAadAiuuUOV
4QMuEQrjMti6jlAdmAVmhr0UoUjqU7H2JvwGqtMQjouTdPhyItSl8NtYDkbbK7Wo
teNx7GyfgvguQYPJG2mcaqc4aX04En9xIow97DcxC8HC1GTkivSII7Bs6Qh6ZPnU
ctupm1EdU+mEiWyrX0b3og9jNi47DszHdEf4aLmDa1ANdsWED5YydFl9PsvqcP/7
CASZF83AcAXPW1oi9IvW6T+ecI4vRb8xx8APvotO0TEjGRCTzuD5PxG3KnBKRj7J
flf3AsaqYoHBNsREFbeJ+ZndS9JGwt/D/s3G3AAYMtxt1+12W5AHDgNKGrEoWpGN
z0gV03eon3Q1vqE6Khskusb8Y7B4qJmy7n+Z0pTfNBTF5zHTD9NMNFfoym9/PJKg
7RDFAcA/d1tLsstVhdPgtiS9IZ30eTOCmq/9mHwUPQm0q/2edZadRsYVsiO+wOB9
aKVnKt+lW5DioUvEvE7XrwuJFDd+PORkXJSXy7z1+g+IVC0QLE62r6WE4r11RWD1
7GKBS+1ctSg=
=jKeb
-----END PGP SIGNATURE-----

--Apple-Mail=_4AFB059B-0F04-429D-87A2-60C052AD286E--
