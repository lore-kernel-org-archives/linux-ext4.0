From: Fabio Comolli <fabio.comolli@gmail.com>
Subject: Re: Crash in 2.6.28.7 - ext4 related
Date: Thu, 26 Feb 2009 23:01:13 +0100
Message-ID: <b637ec0b0902261401p191b2a1fn75b29e99c9f03726@mail.gmail.com>
References: <b637ec0b0902251203i1fe5f081vfd06350dbf5060e9@mail.gmail.com>
	 <b637ec0b0902260118o19f74acal567440a6f049512@mail.gmail.com>
	 <20090226141946.GE7227@mit.edu>
	 <b637ec0b0902260638u2a07433ayf0ea56fd3e41ec5a@mail.gmail.com>
	 <20090226160829.GH7227@mit.edu>
	 <b637ec0b0902261242o55d67bd9m65a6f26dc8ce1b19@mail.gmail.com>
	 <20090226205245.GM7227@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Tso <tytso@mit.edu>,
	Fabio Comolli <fabio.comolli@gmail.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:57458 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162AbZBZWBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Feb 2009 17:01:17 -0500
In-Reply-To: <20090226205245.GM7227@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

On Thu, Feb 26, 2009 at 9:52 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Thu, Feb 26, 2009 at 09:42:15PM +0100, Fabio Comolli wrote:
>> It's my home directory and so I prefer not to share, sorry.
>
> No problem, I understand.

Thanks.

>
>> Anyway, it seems that after the removal of that (possibly corrupted)
>> directory, I can't reproduce the problem anymore. I tried to create
>> / modify / delete some big directories, even two or three at a time
>> with no luck.
>
> Did you ever try running e2fsck on the filesystem while you could
> reproduce it? =C2=A0Did it report any errors? =C2=A0A good thing to d=
o in
> general, if you can report these sorts of problems, is to run e2fsck
> with the -n option, while the filesystme is unmounted, and see if any
> errors are reported. =C2=A0That would tell us if there were any files=
ystem
> corruption problems (and the -n avoids making any changes to the
> filesystem).

OK, maybe I did not make myself clear in my previous post. After the
last crash (the one from which the picture was taken)  I booted
single-user and the I forced a full fsck with the filesystem
unmounted. It reported no errors. After that I removed the problematic
directory and all is fine since that.

Maybe it's worth mentioning that I did the very same actions after
another crash that happened before: also in that case a full fsck
reported no errors but trying to remove the directory after that
crashed the machine.

>
> Also, even if you don't feel willing to share the e2image file, if yo=
u
> can reproduce it, please consider making a raw e2image dump. =C2=A0Th=
at way
> if the problem goes away again, maybe you'll be able to consistently
> report reproduce it on the e2image dump file.

Yup, will do if the problem shows up again.

>
> The other thing that you can do which will sometimes work is to add
> the -s option to the e2image command. =C2=A0The -s option scrambles t=
he
> name of the directory entries and zeros out any unused portions of
> directory blocks to prevent privacy problems. =C2=A0The downside is t=
hat it
> can prevent certain bugs from being repeatable and you have to either
> turn off the dir_index feature or run e2fsck to fix up the htree sinc=
e
> the filename hashes will be screwed up after the directory entries ar=
e
> scrambled. =C2=A0So it's not ideal, but in cases where there are priv=
acy
> issues, that can be helpful.

Will do.

>
> Regards,
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-=
 Ted
>

Regards,
=46abio
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
