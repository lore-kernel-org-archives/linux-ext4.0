From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: SECRM, UNRM, COMPR flags
Date: Tue, 27 Sep 2016 05:45:09 -0600
Message-ID: <0538A2EF-96CC-467E-8923-F7E2F9F8A800@dilger.ca>
References: <20160926091149.GA7733@quack2.suse.cz> <20160926150621.rp2s5uhkbqzjzixn@thunk.org> <20160927083508.GE1139@quack2.suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_D2F54940-3D86-4335-9A8B-C9681D9663F0"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:38390 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932192AbcI0LpO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Sep 2016 07:45:14 -0400
Received: by mail-it0-f50.google.com with SMTP id n143so11584985ita.1
        for <linux-ext4@vger.kernel.org>; Tue, 27 Sep 2016 04:45:14 -0700 (PDT)
In-Reply-To: <20160927083508.GE1139@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_D2F54940-3D86-4335-9A8B-C9681D9663F0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 27, 2016, at 2:35 AM, Jan Kara <jack@suse.cz> wrote:
>=20
> On Mon 26-09-16 11:06:21, Ted Tso wrote:
>> On Mon, Sep 26, 2016 at 11:11:49AM +0200, Jan Kara wrote:
>>>=20
>>> in ext4 we have these SECRM, UNRM, COMPR flags which users can set, =
they
>>> can read them, but which actually don't do anything. This is =
actually
>>> somewhat confusing - e.g. I've just got report about one tool which
>>> apparently sets SECRM flag on a file in a hope that it is somehow =
safer.
>>> Also this is a waste of flags.
>>=20
>> I agree it doesn't seem very likely we'll be using UNRM any time =
soon.
>> I can imagine using SECRM and COMPR, but in particular for COMPR it
>> will probably be in a different way (the package manager would =
install
>> a file that would be compressed in userspace, and then using a
>> *different* ioctl from IOC_SETFLAGS, the COMPR flag would be set and
>> that would make the file immutable and the decompression would be =
done
>> in userspace).
>>=20
>>> I've checked other filesystems (xfs, btrfs) and they report =
EOPNOTSUPP if
>>> these flags are not really supported. Should not we do the same in =
ext4? I
>>> know there is a concern about breaking userspace but since other =
major
>>> filesystems already behave this way I think there is a good chance =
tools
>>> handle this reasonably... What do people thing?
>>=20
>> What we've been doing for other flags that we don't set is that we
>> simply mask them off (see EXT4_FL_USER_MODIFIABLE) so attempt so set
>> them will be a no-op.
>=20
> Yeah. This is better than what we currently have but still the problem =
is
> that application can be tricked into thinking it got some =
functionality
> when it actually did not (when ioctl succeeds, apps usually don't =
recheck
> whether the bit actually got set - especially when other filesystems =
return
> error in such case).
>=20
> What I'd like is: Remove UNRM, SECRM and COMPR from USER_MODIFIABLE
> bitmask. Return -EOPNOTSUPP when (flags & ~USER_MODIFIABLE) !=3D 0.
> This way we flag possible issues early and also using the so far =
unused
> flags for any functionality in future is safe (otherwise you cannot be =
sure
> whether some apps just randomly don't leave unused bits set). Whether =
some
> apps won't get broken by this is a question but I'd hope not since as =
I
> said other filesystems already behave this way and get away with =
that...
> Are people willing to try this out?

I know in the past that the "NODUMP" flag wasn't used directly by ext*,
but it was used by the "dump" tool to skip backing up files.  It may be
that tar checks this as well, but not sure.

I could imagine that "UNRM" and "SECRM" could be checked by userspace
tools (LD_PRELOAD or some desktop garbage can?) in userspace to see if
the file should be put into .Trash or shredded at unlink time, but I
don't know if that was ever implemented.  It definitely was suggested
several times when people asked about implementing this in the kernel.

Cheers, Andreas

>> What I think would make sense is to simply remove UNRM, SECRM, and
>> UNRM from the USER_MODIFIABLE bitmask.  I also suspect it might be
>> useful to define a new ioctl which returns the USER_VISIBLE and
>> USER_MODIFIABLE bitmasks, so that tools can know how to expect (and
>> give warning or error messages as desired).
>=20
> Well the GET/SETFLAGS ioctl is used by several filesystems these days =
so
> we'd better check with other filesystems whether they are able to =
support
> this functionality. I think they should be and it could be useful for =
app
> to know which info it is able to get/set so that it doesn't have to
> research through trial and error. But this is IMO a separate issue to =
the
> above ext4-specific problem.
>=20
> 								Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_D2F54940-3D86-4335-9A8B-C9681D9663F0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBV+pbxnKl2rkXzB/gAQgl5xAAnSDkowZC6XZ2LNeITddGkGh6qKdTNN4p
TX/5W+Or9MBEqdn0xAbTKzTt0HH6ZfJgQa4r6XchJsN53I3VWRq+eW/ZCPx0cwBl
1kAIrPLsY5xhtJxnZ2rwSCJ+jcJ91MMTO9SzrM3N91zDKoFvaU7tli3rxxiGgqPN
0BS7pdIKJ8fMc2sScEO4Kh6N80iCovYlr3My+HlfacXSPniiwOxHfske6zthNimo
9AazCKnyNOXjDtQG8Hqmwvm6mJ0Zi31y+f+ccJm4lP959bUc6c46uRJMtDN18HBC
zR8MhTwwMhlMYFSjzZcmE4JI4LVjflCLaAAmSdE88G56ge9wivw7AoU9WHOvz158
6Cj1WU/E84ROYCtaTz54cV7P4QjEyXTIio5smHMx5hVSc/sVo3mNleqcB+fWawYE
95hRsqgC4u9ONlczr+03Se6fIHyAT3z6oZC6qJWv+ZoDeis+DN6XrzyW+TxaTrPU
PoSmRxTHdmb4V9l44FBeCU5Y2keFFDD+o1FOh6THtsp0u77TrTD2BU1WrZk+7V1y
rCZiqjzlk8JDaPOOqqecsfkbtB/ICbKnVLcF5E4vXMrpbHNslPyIBWp9pX0PBdd+
Yw5nagH63zrzYJ/8CBugk27OO4OycokVKCg+A2vBvQYGm65An69sg2eukO7Bqm0s
/eHogwClfVY=
=eR16
-----END PGP SIGNATURE-----

--Apple-Mail=_D2F54940-3D86-4335-9A8B-C9681D9663F0--
