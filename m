From: Peng Tao <bergwolf@gmail.com>
Subject: Re: [Bug 15910] zero-length files and performance degradation
Date: Mon, 10 May 2010 22:22:47 +0800
Message-ID: <AANLkTilQyGvZeyJiGZFjkKIF9qXPQ2l1YNh_W8jvg1J0@mail.gmail.com>
References: <bug-15910-13602@https.bugzilla.kernel.org/> <201005091819.o49IJCQG017276@demeter.kernel.org>
	<20100510025612.GM18762@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35159 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab0EJOXI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 May 2010 10:23:08 -0400
Received: by vws17 with SMTP id 17so92887vws.19
        for <linux-ext4@vger.kernel.org>; Mon, 10 May 2010 07:23:07 -0700 (PDT)
In-Reply-To: <20100510025612.GM18762@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 10, 2010 at 10:56 AM,  <tytso@mit.edu> wrote:
>> The problem is, dpkg needs to guarantee the system is always usable,
>> and when a crash occurs, say when it's unpacking libc, it's not
>> acceptable for dpkg not to fsync() before rename() as it might end
>> up with an empty libc.so file, even if it might have marked the
>> package as correctly unpacked (wrongly but unknowingly as there's no
>> guarantees), which is not true until the changes have been fully
>> committed to the file system.
>
> Why not unpack all of the files as "foo.XXXXXX" (where XXXXXX is a
> mkstemp filename template) do a sync call (which in Linux is
> synchronous and won't return until all the files have been written),
> and only then, rename the files? =C2=A0That's going to be the most fa=
stest
> and most efficient way to guarantee safety under Linux; the downside
> is that you need to have enough free space to store the old and the
> new files in the package simultaneously. =C2=A0But this also is a win=
,
> because it means you don't actually start overwriting files in a
> package until you know that the package installation is most likely
> going to succeed. =C2=A0(Well, it could fail in the postinstall scrip=
t, but
> at least you don't have to worry about disk full errors.)
What about letting fsync() on dir recursively fsync() all
files/sub-dirs in the dir?
Then apps can unpack package in a temp dir, fsync(), and rename.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
Thanks,
-Bergwolf
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
