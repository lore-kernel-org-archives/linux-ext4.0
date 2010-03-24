From: Sedat Dilek <sedat.dilek@googlemail.com>
Subject: Re: [PATCH] ext4/super.c: Fix error in ext4_fill_super: ext3_fs_type
	undeclared (first use in this function)
Date: Wed, 24 Mar 2010 17:59:06 +0100
Message-ID: <2d0a357f1003240959u2a62f062u7bdba2e0cea5cdf0@mail.gmail.com>
References: <2d0a357f1003240445y27e9e56ete60d0786f42ac486@mail.gmail.com>
	 <20100324161308.GH2159@thunk.org>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:48440 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab0CXQ7I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Mar 2010 12:59:08 -0400
Received: by wwe15 with SMTP id 15so5219813wwe.19
        for <linux-ext4@vger.kernel.org>; Wed, 24 Mar 2010 09:59:07 -0700 (PDT)
In-Reply-To: <20100324161308.GH2159@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hehe.
Yes, I am telling people so often to look first into the ML(s) before
asking on IRC :-).
Thanks, anyway.

--
Sedat

On Wed, Mar 24, 2010 at 5:13 PM,  <tytso@mit.edu> wrote:
> On Wed, Mar 24, 2010 at 12:45:27PM +0100, Sedat Dilek wrote:
>> Not sure if this is really fixing the problem in [1].
>
> Yeah, that should fix it, but see the patch I sent just a moment
> ago... (sorry, I didn't see your e-mail until I checked in my fix...)
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-=
 Ted
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
