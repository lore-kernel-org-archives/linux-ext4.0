From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: guarantee already started handles to successfully finish while ro remounting
Date: Fri, 6 May 2016 14:01:17 -0600
Message-ID: <14935C7A-F680-4E9A-9048-DAACAE1ABAB4@dilger.ca>
References: <593570881.453531462514471895.JavaMail.weblogic@ep2mlwas08c> <20160506130034.GE31860@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_8D60B1BB-4F87-430C-B299-B1B43B9B0BF7"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Daeho Jeong <daeho.jeong@samsung.com>, jack@suse.cz,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	=?utf-8?B?7J206riw7YOc?= <kitae87.lee@samsung.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:34531 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758152AbcEFUBY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 May 2016 16:01:24 -0400
Received: by mail-io0-f173.google.com with SMTP id 190so124634838iow.1
        for <linux-ext4@vger.kernel.org>; Fri, 06 May 2016 13:01:23 -0700 (PDT)
In-Reply-To: <20160506130034.GE31860@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_8D60B1BB-4F87-430C-B299-B1B43B9B0BF7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On May 6, 2016, at 7:00 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
> On Fri, May 06, 2016 at 06:01:11AM +0000, Daeho Jeong wrote:
>>> Hmm, I'm not really comfortable with putting this hack in, since =
this
>>> is papering over the real problem, which is that Android is trying =
to
>>> use the emergency remount read-only sysrq option and this is
>>> fundamentally unsafe.  I'm not sure what else could break if it is
>>> situation normal that there is active processes busily writing to =
the
>>> file system and sysrq-u followed by reboot is the normal way the
>>> Android kernel does a reboot.
>>=20
>>> A much better solution would be to change the Android userspace to
>>> call the FIFREEZE ioctl on each mounted file system, and then call =
for
>>> a reboot.
>>=20
>> I agree with you. I know that current Android shutdown procedure is
>> not a safe way. But, without this patch, "even not in Android =
system",
>> when we trigger the emergency read-only remount while evicting =
inodes,
>> i_size of the inode becomes zero and the inode is not in orphan list,
>> but blocks of the inode are still allocated to the inode, because
>> ext4_truncate() will fail while stating the handle which was already =
started
>> by ext4_evict_inode(). This causes the filesystem inconsistency and
>> we will encounter an ext4 kernel panic in the next boot by this =
problem.
>>=20
>> I think that this kind of filesystem crash can occur anywhere that
>> the same journal handle is repeatly used. During an atomic filesystem
>> operation, a part of the operation will succeed and the other one =
will fail.
>=20
> Sure, but if this were a bug, then it could happen under a normal
> crash scenario.  In this particular case, under what circumstances
> could i_size be set to zero *and* the inode is not on the orphan list
> *and* ext4_evict_inode() is getting called?
>=20
> If that could happen, then we could have problems without emergency
> unmount, and we should fix that problem.
>=20
> The real problem here is that we want emergency unmount to be
> completely safe, but setting MS_RDONLY randomly isn't safe against =
file
> system corruption.  The idea is you do this only when you have no
> other choice, and the consequences would be worse --- and where you
> would be prepared to do a file system consistency check afterwards.
>=20
> We can either fix Android userspace, or we could add a per-file system
> callback which tries (as much as possible) to make an emergency
> unmount safe.  In this particular case, it would probably involve
> setting the "file system is corrupt flag" to force a file system
> consistency check at the next reboot.  Because if you use emergency
> unmount, all bets are off, and there may be other problems....

The problem is that emergency remount-ro doesn't block in-progress =
writes,
since most operations only check the MS_RDONLY at the start of an =
operation.
It would be possible for do_emergency_remount() call ->freeze_fs() first =
for
all the filesystems, then doing the remount read-only (would need a =
change to
do_remount_ro() to allow this)?

That ensures the filesystem is in a (more) consistent state when force
remount-ro is called (i.e. which doesn't block or return an error if =
there
are writers on the filesystem).  I don't think this is an issue for =
normal
remount-ro, since there can't be any writes in progress.

This would also avoid the need for Android to know more about the =
internals
of how to remount read-only, and probably help normal sysadmins too.

Cheers, Andreas






--Apple-Mail=_8D60B1BB-4F87-430C-B299-B1B43B9B0BF7
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVyz4DnKl2rkXzB/gAQivTg/+Jx38O4SkTMuKNUldi5gMv4uWsYTQ3y1D
zP7awN5wCa4jYrB3rXB4pSr9Km6mlKkNWxQEBIvjo96xrkdD94+z/FyEep+Zh12J
K8arI3Zdn0b4/5vH723UtZMm2gyI9pcsRgYB8Hyv8K+lXUqR8H1K0t7hDwER2LhU
s2EAgmt7ceeiPdM5YWcXjh8Vq/rIAKpyPRRQAPkOYUUsgOBN90uFY8vKNr530Y0V
kwLCg0LjGnysBKEcRVF+NrHau71mp+2/SkV3IIIQY+j+YZnQZDclZdv7PLJ6pLFL
0ar7mmze/HTGej3hagcrsnyki02pd87iAutebRdRrnogiZSu8PERJH2Np0vgYti9
Vhh7hyyGuSP3VBDNhALEWakDoR2FqNmVhuw41rUQBCRT2HdxfAtlFzMs8Vgi+JhC
HVrIxb3YTwI/fCZ+vjSk3JMXb9VnhMmWczWPSWvWnykYF19xnLzebcY+XRLPPMlx
ze6YMLuu6ZbwN8R8K9+BK8YU0iqOb0muXcS9dOG+7yYJPAhtBbJd3snejw4/5gxY
qMSTzmuJeeZjJGKWmoWpP9DQzKTjaL98KYg0OE05LWC4KObP9UdS69nLVpKB5XMG
FgfagXNqutScTl5JUK7u+f/Xe2R+pRJ/FnHoUiSaVFZO6x7g+HiLMeOlWr0ZAYMT
fAeKvLa5vXA=
=qGZZ
-----END PGP SIGNATURE-----

--Apple-Mail=_8D60B1BB-4F87-430C-B299-B1B43B9B0BF7--
