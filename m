From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: e2fsck doesn't finish
Date: Wed, 19 Apr 2017 15:07:47 -0600
Message-ID: <4A1EA678-9982-4D9D-8559-713487A372B4@dilger.ca>
References: <f604727f-967c-0b49-a71c-f8adcaeb8945@gmail.com>
 <059b964a-facb-cfd5-6691-4cc1d66fea61@redhat.com>
 <20170418052415.jl44dt2jnmclpx5m@thunk.org>
 <46831715-eb83-51b3-a626-7f6669b02e8a@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_CB969597-ABC7-4AD9-8260-38BB28462614";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Julius Schwartzenberg <julius.schwartzenberg@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36409 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966825AbdDSVHy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Apr 2017 17:07:54 -0400
Received: by mail-io0-f195.google.com with SMTP id x86so7511643ioe.3
        for <linux-ext4@vger.kernel.org>; Wed, 19 Apr 2017 14:07:54 -0700 (PDT)
In-Reply-To: <46831715-eb83-51b3-a626-7f6669b02e8a@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_CB969597-ABC7-4AD9-8260-38BB28462614
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Apr 19, 2017, at 2:57 PM, Julius Schwartzenberg =
<julius.schwartzenberg@gmail.com> wrote:
>=20
> Theodore Ts'o wrote:
>> It looks like the problem is fixed with the latest version of
>> e2fsprogs, though.  I just tried running using a build of e2fsprogs
>> from the next branch, and this seems to allow e2fsck to fully fix the
>> file system and avoid the "aborted" message.
>=20
> I just tried the latest e2fsck from git and it indeed fully got =
through.
> I'm really glad here and I hope there will be a new release of =
e2fsprogs
> soon!
>=20
> I still have a (dd) copy of the original full image on my external =
hard
> drive in case it would be useful.
>=20
> I don't know if this is relevant, but maybe it could also be related =
to
> a conversion? Till recently the filesystem was still ext3 and I was =
only
> using it from Ubuntu 16.04. After installing Fedora 25 on another
> partition, Ubuntu couldn't mount this partition anymore and I had to
> change its entry in /etc/fstab from ext3 to ext4. Then it could mount
> it, but Ubuntu's e2fsck complained there were features in use that it
> didn't support. I reported this Fedora bug then:
> https://bugzilla.redhat.com/show_bug.cgi?id=3D1440429

It would be useful to know which feature(s) that Fedora 25 enabled that
Ubuntu 16.04 didn't understand.  You could use something like:

    dumpe2fs -h /dev/XXX | grep -i feature

under Ubuntu.  Typically, the code shouldn't be enabling any feature on
the filesystem without an explicit request from the admin.

Also, the "failed to mount" case should print something to the console
logs about an unsupported feature, which would help isolate the problem.

Cheers, Andreas

> After I reported bug, I ran into the issues with e2fsck failing to =
complete.
>=20
> In any case, thanks a lot Theodore and Eric for looking into this! My
> issue is solved now, but if there's anything that would still be =
useful
> to figure out I'll be glad to provide any information that could help.
>=20
> Thanks!
> Julius


Cheers, Andreas






--Apple-Mail=_CB969597-ABC7-4AD9-8260-38BB28462614
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFY99GlpIg59Q01vtYRAt28AJ9uQiWzPKCSzt9dIsEDerrzQN27cQCbB94G
aQuzxfM0jszQ8WQddFpNClg=
=6s0F
-----END PGP SIGNATURE-----

--Apple-Mail=_CB969597-ABC7-4AD9-8260-38BB28462614--
