From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/2] ext4: fix potential use after free issue while fsresize
Date: Thu, 27 Nov 2014 16:06:35 +0300
Message-ID: <87vbm0bxno.fsf@openvz.org>
References: <1415958040-4393-1-git-send-email-dmonakhov@openvz.org> <1415958040-4393-2-git-send-email-dmonakhov@openvz.org> <20141125182722.GE11648@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:39493 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaK0NHE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Nov 2014 08:07:04 -0500
Received: by mail-wg0-f42.google.com with SMTP id z12so6441498wgg.1
        for <linux-ext4@vger.kernel.org>; Thu, 27 Nov 2014 05:07:03 -0800 (PST)
In-Reply-To: <20141125182722.GE11648@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Theodore Ts'o <tytso@mit.edu> writes:

> On Fri, Nov 14, 2014 at 01:40:40PM +0400, Dmitry Monakhov wrote:
>> We need some sort of synchronization while updating ->s_group_desc becau=
se there
>> are a lot of users which can access old ->s_group_desc array after it wa=
s released.
>> It is reasonable to use lightweight seqcount_t here instead of RCU.
>>=20
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>
> I'm curious --- under what circumstances did you manage to hit this,
> or was this something that you noticed?
>
>> +	do {
>> +		seq =3D read_seqcount_begin(&sbi->s_group_desc_seq);
>> +		gd_bh =3D sbi->s_group_desc[group_desc];
>> +	} while (unlikely(read_seqcount_retry(&sbi->s_group_desc_seq, seq)));
>
> The problem is that s_group_desc is allocated using ext4_kvmalloc(),
> which means it's possible that it was allocated using vmalloc().
> Which means that it is possible (although unlikely) that the old
> s_group_desc address could become invalidated after the call to
> ext4_kvfree(o_group_desc).
>
> This will only happen on 32-bit platforms if we get unlucky and the
> kmap region gets recycled right after the vfree(); but we would only
> see the bug in practice if the memory gets kfree'ed gets reused
> immeidately afterwards, and we've been living with this with ext3 for
> a long time.  Don't get me wrong; I'm not saying we should ignore this
> bug, since I certainly agree with you that it is truly a bug.  But if
> we are going to fix it, we should probably fix it all the way, which I
> suspect means we may have to use RCU here.
>
> OTOH, if you are hitting this in live production workloads, then we
> can do the partial fix now, and then fix it all the way up later.  Is
> the RCU mechanism really going to be that ugly?  It's not like we are
> resizing all the time, so we don't need to worry about it being
> heavyweight from a performance point of view, no?
I use seqcount_t because Doc/RCU/array.txt state that it is lighter,
but indeed I've missed vmalloc case so I'll rewrite it to RCU.
>
> 	    	   	       	     	- Ted

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEbBAEBCgAGBQJUdyHbAAoJELhyPTmIL6kB5SsH923g725xWXMyc2+5kzBc4PNe
UeOVUo6LYiOFZyqFzIo0p/Fv/v/sija2kewNleNbico0n0G0S9gjLczrbJzbujvT
MWYCubrFsCXMmBBcAeyOo2+ZymtpFDkxMiqQeA7ceYp5ngU6jnyqqgu3gA8LswVA
BO3LfS0G7gCxsRqveag8Q/R8LAgB2hPzB7QmbmH5o0bfhbHg4ciEEWjLGeHW8uEm
y/yF8lRy/CvkEcLLEvt3UPheRcn8OZ+5Q4CAd757GrN6/JzgBmpmj1lY0uBDI0xA
J4hk+pq2S41jhR6XcJI94FjI9lTdkLmrBtw4sPwBNUVxbHU7UqI7sFlhIW/SsQ==
=5Wjh
-----END PGP SIGNATURE-----
--=-=-=--
