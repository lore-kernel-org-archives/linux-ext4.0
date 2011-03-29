From: Oren Elrad <elrad@brandeis.edu>
Subject: Re: [PATCH] mke2fs reserved_ratio default value is nonsensical
Date: Tue, 29 Mar 2011 12:57:11 -0400
Message-ID: <AANLkTint3VFwKYSoy6NeZFS82F65Dc-bOo2OxCFm+yDN@mail.gmail.com>
References: <AANLkTi=7jMS=yq4-72_CvcyGHuWWV6ixEKtk501wnxUz@mail.gmail.com>
 <4D90CE41.4030209@redhat.com> <4731EEFB-561D-4393-81C9-B550F45964C6@mit.edu> <4D91FA25.1080402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62754 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab1C2Q5w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Mar 2011 12:57:52 -0400
Received: by vws1 with SMTP id 1so307739vws.19
        for <linux-ext4@vger.kernel.org>; Tue, 29 Mar 2011 09:57:51 -0700 (PDT)
In-Reply-To: <4D91FA25.1080402@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 29, 2011 at 11:26 AM, Eric Sandeen <sandeen@redhat.com> wro=
te:
>
> On 3/29/11 9:05 AM, Theodore Tso wrote:
> >
> > On Mar 28, 2011, at 2:06 PM, Eric Sandeen wrote:
> >>
> >> No other fs that I know of enforces this "don't fill the fs to
> >> capacity" common sense programatically, though.
> >
> > Actually, we (ext2) copied this from the BSD Fast File System (FFS)
> > which used a default MINFREE of 10%. =A0 For ext2 we decided to bri=
ng
> > it down to 5%. =A0 FreeBSD currently uses 8% as their default free
> > ratio.
>
> Clearly I don't know enough filesystems, I guess ;)
>
> Should have said "linux filesystem" perhaps.
>
> > The decrease does seem to be relative to the percentage of free
> > space, from empirical experience, although no one I know of has don=
e
> > a formal analysis of the slowdown. =A0 A lot depends on your worklo=
ad,
> > how much memory pressure you place on your system, etc. =A0I've
> > actually started seeing slowdowns starting as early as 80% full whe=
n
> > you're trying to allocate large chunks (1M to 8M) at a time, althou=
gh
> > this isn't something where I've gathered hard data; just what I've
> > noticed from looking at different systems and their performance
> > characteristics.
> >
> > Fortunately disks are cheap, and lots of people end up buying far
> > more disk space than they need, and so they naturally keep their fi=
le
> > systems well under 75-80% full.
> >
> > If someone wants to add some tuning parameters to mke2fs.conf, so
> > they can set their own personal default free ratios, or even
> > min_reserved_blocks and max_reserved_blocks settings, that's probab=
ly
> > a reasonable patch to e2fsprogs that I'd be willing to accept.
>
> Hm I thought I had sent that, but it was only for the other two
> semi-controversial behaviors. =A0:)
>
> I agree, it seems like at least a decent first step to make it
> more site/admin-configurable.
>
> -Eric
>

Thanks all for the informative replies.

I never meant to suggest that 5% is a bad default as a general matter
(but I dropped the ball communicating that); I agree entirely that
non-root users should not be able to degrade performance by filling up
the disk and that 5% is a very good default choice.

My only (admittedly unsupported) claim was that past some **fixed**
value there is little gain from reserving more space independently of
the size of the volume. When I get a chance, I will try to design a
benchmark to test that claim (having a few spare 12TB volumes helps)
but I fear the results will depend heavily on the usage pattern.

Oren Elrad
Dept. of Physics
Brandeis University
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
