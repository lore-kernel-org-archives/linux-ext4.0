From: Aditya Kali <adityakali@google.com>
Subject: Re: quotacheck on 'tune2fs -O quota'
Date: Mon, 7 Nov 2011 13:56:48 -0800
Message-ID: <CAGr1F2ENDTZxVA95oEQBWCV-SC-izbzrTdacdCbnXcz5WBwHww@mail.gmail.com>
References: <4EB224A9.8030606@whamcloud.com> <CAGr1F2FMvsZ6eLJid4z0RpJcAm5paEfbJwrtFE7iqbr_bA4BTA@mail.gmail.com>
 <20111104090356.GC6205@granier.hd.free.fr> <CAGr1F2FQ=MAqd8NiamZ39K9dX8YC_JiaUszFod3tG=CK+W0GGQ@mail.gmail.com>
 <20111107203836.GB3191@granier.hd.free.fr> <20111107212825.GI24234@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Johann Lombardi <johann@whamcloud.com>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46191 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1KGV5L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Nov 2011 16:57:11 -0500
Received: by qao25 with SMTP id 25so1079033qao.19
        for <linux-ext4@vger.kernel.org>; Mon, 07 Nov 2011 13:57:10 -0800 (PST)
In-Reply-To: <20111107212825.GI24234@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 7, 2011 at 1:28 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Mon, Nov 07, 2011 at 09:38:36PM +0100, Johann Lombardi wrote:
>> > I agree it would be useful to allow upgrades using existing quota
>> > files. I just didn't have a way of doing this correctly though so =
I
>> > had removed it. But this patch fixes it, so I am all for including=
 it.
>>
>> Great, thanks.
>
> It's more than useful, it's mandatory. =C2=A0It wasn't important for
> Aditya's application since he was mainly worried about tracking disk
> space usage. =C2=A0But for anyone who cares about doing quota enforce=
ment,
> losing the quota limits when you ran e2fsck is a non-starter.
>
> Just to get this on record, since we discussed this on the weekly
> conference call. =C2=A0I'm currently planning on making quota disable=
d by
> default in e2fsprogs, so that anyone who wants to use quota will have
> to use an --enable-quota configure option. =C2=A0That's because I'm n=
ot
> completely convinced that quota is fully baked and tested. =C2=A0Afte=
r
> reviewing Niu's patches, I'll apply them, and that way the quota
> feature won't hold up the e2fsprogs 1.42 release. =C2=A0People who fe=
el
> comfortable using it can enable it via --enable-quota, and after we
> give it a bit more of a shakedown, we can enable it by default in som=
e
> 1.42.X maintenance release.
>
Sounds good to me.

Thanks,

> Thanks to Niu and whamcloud for implementing this critically needed
> bit of functionality!
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-=
 Ted
>



--=20
Aditya
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
