From: Eric Gouriou <egouriou@google.com>
Subject: Re: [PATCH] ext4: let ext4_ext_convet_to_initialized initialize
 var(eh) before using it
Date: Wed, 2 Nov 2011 01:22:59 -0700
Message-ID: <CAMUAhYQPPt6Bke6zE=r3XAa6ukHUrxQe-R_oqBLOUM22j65WDQ@mail.gmail.com>
References: <1320110481-12080-1-git-send-email-xiaoqiangnk@gmail.com>
	<20111101225222.GH32161@thunk.org>
	<CAMUAhYSh4VUbh3oG9hwi0FxMs=gMDiOHqvRhDgZTmP-_8PuW3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49246 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab1KBIXA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Nov 2011 04:23:00 -0400
Received: by gyb13 with SMTP id 13so7939424gyb.19
        for <linux-ext4@vger.kernel.org>; Wed, 02 Nov 2011 01:22:59 -0700 (PDT)
In-Reply-To: <CAMUAhYSh4VUbh3oG9hwi0FxMs=gMDiOHqvRhDgZTmP-_8PuW3g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[Resend of my earlier message with HTML gunk removed and one edit. ]

On Tue, Nov 1, 2011 at 15:52, Ted Ts'o <tytso@mit.edu> wrote:
>
> On Tue, Nov 01, 2011 at 09:21:21AM +0800, Yongqiang Yang wrote:
> > ext4_ext_convert_to_initialized() does not initialize eh before usi=
ng it
> > and this is introduced in commit 864d21652.
> >
> > Cc:Eric Gouriou <egouriou@google.com>
> > Cc:"Theodore Ts'o" <tytso@mit.edu>
> > Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 eof_block =3D map-=
>m_lblk + map->m_len;
> >
> > =C2=A0 =C2=A0 =C2=A0 depth =3D ext_depth(inode);
> > + =C2=A0 =C2=A0 eh =3D path[depth].p_hdr;
> > =C2=A0 =C2=A0 =C2=A0 ex =3D path[depth].p_ext;
> > =C2=A0 =C2=A0 =C2=A0 ee_block =3D le32_to_cpu(ex->ee_block);
> > =C2=A0 =C2=A0 =C2=A0 ee_len =3D ext4_ext_get_actual_len(ex);
>
> Hmmm, nice catch.
>
> Looks like Eric dropped this line when he forward ported this patch t=
o
> v3.1.

Indeed I screwed up. Apologies for the trouble. I tested the patch thor=
oughly
on our kernel version, ported it to ~ 2.6.39 and tested. This was a few=
 months
ago and could not find the time to complete the work then. When I got a=
 chance
to resume the effort, the upstream kernel had changed but I was not sup=
posed
to even build it due to security concerns with the kernel.org sources.
So I redid
the port blind, verified [the file] built but did not test.

> =C2=A0Interestingly, I did test this using xfstests, and it didn't
> complain. =C2=A0Which probably means we don't have a good test covera=
ge
> that triggers the specific preconditions of this optimization. =C2=A0=
Oops.
> I'll fix this up now.
>
> Eric, when you have a chance, could you work up an xfstests test that
> automates the various tests that you ran manually when you developed
> this patch? =C2=A0Thanks!!

Sure, but the "chance" may not manifest itself soon.

=C2=A0Eric

>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
