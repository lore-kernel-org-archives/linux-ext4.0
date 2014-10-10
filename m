From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: fix race between write and fcntl(F_SETFL)
Date: Fri, 10 Oct 2014 14:09:44 +0400
Message-ID: <87zjd4p76f.fsf@openvz.org>
References: <1412853287-10496-1-git-send-email-dmonakhov@openvz.org> <948E780F-14EB-4E38-9BAC-A5410F339441@dilger.ca> <878uko4b75.fsf@openvz.org> <20141010093934.GA25693@quack.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	sasha.levin@oracle.com, linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:62241 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaJJKJy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Oct 2014 06:09:54 -0400
In-Reply-To: <20141010093934.GA25693@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Jan Kara <jack@suse.cz> writes:

> On Fri 10-10-14 11:48:30, Dmitry Monakhov wrote:
>> Andreas Dilger <adilger@dilger.ca> writes:
>>=20
>> > On Oct 9, 2014, at 5:14 AM, Dmitry Monakhov <dmonakhov@openvz.org> wro=
te:
>> >> O_DIRECT flags can be toggeled via fcntl(F_SETFL).
>> >> But this value checked twice inside ext4_file_write_iter() and __gene=
ric_file_write()
>> >> which result in BUG_ON (see typical stack trace below)
>> >> In order to fix this we have to use our own copy of __generic_file_wr=
ite
>> >> and pass o_direct status explicitly.
>> >
>> > This seems like a generic problem that would be better served by fixing
>> > the core code instead of making a private copy of such a large function
>> > for ext4.  I expect other filesystems might have similar issues if the
>> > O_DIRECT state is changed in the middle of IO?
>> >
>> > One option is to flush pending IO on the file if the O_DIRECT flag is
>> > changed in setfl(). This is a bit heavyweight but I can't imagine any
>> > sane app that is changing the O_DIRECT state on a file repeatedly.
>> Agree. In fact there are a lot of other issues there fcntl(F_SETFL)
>> works incorrectly. For example it does not works on stack-fs
>> (ecrypt,unionfs) if you try to add O_APPEND flags it will be directly
>> assigned to virtual file (not lower one). For that reason OpenVZ introdu=
ced
>> f_op->set_flags in order to support our stackfs (vefs)
>> This is reasonable solution in general so I'll prepare patches for mains=
tream
>> But this require reasonable time for negotiations with vfs people.
>   Agreed. ->set_flags callback looks reasonable.
BTW: same crap with fadvise.
>
>> At the same time currently all versions are affected since 69c499d1/2012=
-11-29
>> So we need quick and simple fix for stable releases.
>> From first glance the best fix is to simply deny toggle O_DIRECT on file=
s.
>> and f_op->check_flags(new_flags) looks like reasonable candidate, *but*
>> this interface is 100% useless because it has no access to file_pointer
>> so we do not know current ->f_flags :)
>   [I've CCed linux-fsdevel since it may indeed affect other filesystems]
>   I don't think you want to just deny toggling O_DIRECT. That's certainly
> going to break some application (however stupid it may be). Also flushing
> the IO as Andreas suggests doesn't seem easy because to solve the problem
> with changing flags in general, you would have to wait for both reads and
> writes, buffered & direct for the struct file and that's not easily doabl=
e.
> What currently seems as the best solution to me is to store f_flags in the
> iocb and then use that for decisions... However it still seems a bit
> fragile since people modifying the would would have to have in mind they
> have to use iocb->f_flags instead of iocb->ki_filp->f_flags
We can easily serialize AIO,DIO and buf-writers via i_mutex and i_dio_count
the only non-serialized callers are buffered reads and mmaped files.
So tend to agree with iocb->f_flags
>
> 								Honza
> --=20
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUN7BoAAoJEFzOBSYIXfveT+UP/j9c019z9dngv+CRTRvol3Bq
JCs3YZZnIMeCQXrGlpJ91uIL5xpFEwBe/F1KtD9FkE9lmY2OGv4eziLGddJYUGSG
Z57tbKhbiStefbleo7MaFaEYykSVycB+eRevb450uWhdZsGDXx2/wauzY5GZZw31
U8cKHe5NAAMeZ9LRFHP44VuUJ5hu38xh+TK4iEjtrueNaKTNYYv0m08tqnbhXLBf
2ZALfhXnsomGzFlaEfHUFImYuqU5rtdI0/nsfsMBEfzt2xH02HJYxQhUNc+zXaAx
2YLi68Oq3nTv9IJd8Uudoa8IufwDDh2DIaiHXCuCo5sFQbRfAwSy0Pf5+pqX1MxW
lCNra/Us7clqCKl6VtoodDRcpg9t3dIrlphfxz8kX60x2dEDkSo5FJiCSYNfVvsH
IPYABKPs+mbljxr/j7gqui1tLWdspjUWrMqw3vgH++a31WcLfkHVtc1GI+AQvM29
9QhFYIBnRfuIf7TECz4Md4rpmtQxXiPgbS9HQT8f/s1o765i+iWYZTG8nu2n9ZFZ
uTHP2LWdgGk8yDBk5pBz21cS+M3X+MX61hJBW6W1UIVHi0C9vq1GcaPOACcLfPsa
dkJibfuMTphU5yu8hYhTKm7MliHLVqrrT3QNzEbLK8KUJEbqJ8Z0lpYcGvSKhKQE
6lYeCf/DCqnFevvPDZ9Z
=lBDW
-----END PGP SIGNATURE-----
--=-=-=--
