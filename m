From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: ext4-lazy (SMR-optimizations) landing to kernel?
Date: Mon, 17 Apr 2017 13:59:14 -0600
Message-ID: <A10FB389-CE93-493F-93D1-D61DD1A9466D@dilger.ca>
References: <6B0F0C59-6930-41B3-8EE4-EA5BEECEB9F9@dilger.ca>
 <c2d584af-c91b-bcbb-ac13-d1e9e6162a4b@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_F8BAD61F-6CF9-4523-94AD-EF9E003A22E7";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ts'o Theodore <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36244 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753657AbdDQT7Y (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Apr 2017 15:59:24 -0400
Received: by mail-io0-f194.google.com with SMTP id x86so28879130ioe.3
        for <linux-ext4@vger.kernel.org>; Mon, 17 Apr 2017 12:59:23 -0700 (PDT)
In-Reply-To: <c2d584af-c91b-bcbb-ac13-d1e9e6162a4b@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_F8BAD61F-6CF9-4523-94AD-EF9E003A22E7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Apr 17, 2017, at 8:18 AM, Eric Sandeen <esandeen@redhat.com> wrote:
>=20
> On 4/10/17 10:06 PM, Andreas Dilger wrote:
>> Hi Ted,
>> now that FAST'17 is behind us, is there any plan to land the =
ext4-lazy code
>> (SMR optimizations) to the upstream kernel?  This looks like it =
improves
>> some workloads even without SMR disks, and doesn't have any =
noticeable
>> overhead for other workloads.
>>=20
>> I'd guess the one thing that we might want to do is still allow the =
journal
>> to optionally checkpoint the metadata to the filesystem in the =
background,
>> when the filesystem is otherwise idle, so that in case of journal =
loss for
>> some reason the whole filesystem is not lost?
>=20
> IIRC even the new larger default journal size was a big win by itself, =
yes?

For many-thread modification that is definitely a win.  We've used
journal sizes up to 1GB for Lustre object targets and up to 4GB for
metadata targets, just because worst-case journal credit reservation
causes transaction stalls even if the transaction doesn't grow large.

That is especially true for fast devices like SSD metadata targets
that do tens of thousands of ops/sec with quotas, ACLs, xattrs, etc.
This is somewhat worse on Lustre because we also store additional
xattrs and also update Lustre-specific transaction log files in the
same transaction as each filesystem modifying operation.


IMHO, the ext4-lazy feature would also potentially be useful for non-SMR
devices, where we could do full data journaling (optimistically, small
files?) to a large flash journal device, and only write to the disk =
device
periodically (once the journal gets near full, or when the HDD is spun =
up
from sleep).

Cheers, Andreas






--Apple-Mail=_F8BAD61F-6CF9-4523-94AD-EF9E003A22E7
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFY9R6SpIg59Q01vtYRAgQhAJ9HL8l02tzvGaS4wVfW9yMWZNmvNQCeNj4S
Z4eGBydRfZN3FTJU2RUO9ks=
=MkjQ
-----END PGP SIGNATURE-----

--Apple-Mail=_F8BAD61F-6CF9-4523-94AD-EF9E003A22E7--
