From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Better organizing ext4 development community
Date: Mon, 21 Nov 2011 22:08:15 +0200
Message-ID: <CAOQ4uxicqLPhNo6Q1ib4ti4T+3nTfVW548qGahQc1qhnxCNmHA@mail.gmail.com>
References: <E1RSWGS-0000op-NX@tytso-glaptop.cam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:64339 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606Ab1KUUIQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Nov 2011 15:08:16 -0500
Received: by wwe3 with SMTP id 3so6067711wwe.1
        for <linux-ext4@vger.kernel.org>; Mon, 21 Nov 2011 12:08:15 -0800 (PST)
In-Reply-To: <E1RSWGS-0000op-NX@tytso-glaptop.cam.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 21, 2011 at 5:58 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> There seems to be an increasing number of people interested in ext4 w=
ho
> have been contributing to ext4, and so I thought this might be a good
> time to pen a note about how we might be able to organize things a
> little better.
>
> The weekly conference calls
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>
> We have a weekly conference call at Monday 8am US/Pacific and 11am
> US/Eastern. =A0The people who participate on this call are primarily =
from
> the following companies (alphabetically): Google, HP, IBM, Red Hat, a=
nd
> Whamcloud. =A0The attendees are primarily mostly from the US, due to
> history of who has known about the calls, but also due to the time of
> the conference calls.
>
> Given there are more people who are participating on this call from
> Asia, especially from Tao Bao and other companies, I think it's
> important that we revisit whether that time is best, and to try to
> invite some folks from the other countries to participate. =A0 I know=
 that
> language may be a barrier in some cases, but I think it's important t=
hat
> we try to get a wider representation that has a chance to hear what's
> going.

Hi Ted,

As someone who participated in some calls (which lately don't fit in
my schedule),
I can say that the information shared on these call can be very
interesting to the community
but rarely leaves the "walls" of the conference.

It would be nice to get minutes of the call posted to the list
(there are some from 2007 on ext4 wiki)
I know it's about who will do that, but even the minimal updates could
be useful.


>
> I'd like to hear what folks from Asia think about this; if we started
> having some conference calls that alternated between being convenient
> for folks based out of Asia time zones and folks based out of US time
> zones, would that be helpful?
>
> Getting together for a face to face meeting
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Again, because of the fact that we quite a few newcomers to the ext4
> development community, it seems that it might be a good idea if we co=
uld
> get together so we could know each other better. =A0I'd like to propo=
se
> that we try doing so either immediately before or immediately after t=
he
> Linux Storage, File System, and MM workshop in San Fracisco, which wi=
ll
> be taking place during the first week of April next year. =A0I'm hopi=
ng
> that we can get good representation from all of the companies who hav=
e
> an interest in ext4 development, and if we start early, we can hopefu=
lly
> get people thinking about some kind of discussion topic to propose fo=
r
> the LSF workshop (proposing a discussion topic that would be of gener=
al
> interest is how you get an invite to the LSF), and so people have amp=
le
> time to work out the logistics --- getting travel approval, getting
> Visa's, etc.

Wouldn't it be more inviting to hold such a meeting adjacent to an open=
 event?
After all, not everyone can get invited to LSF on the same year.

>
> If you would be interested in attending an ext4 get together next yea=
r
> in April, please let me know, so I can start guaging interesting and
> numbers.
>
> Review Bottleneck
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Currently, patches, especially large patch series which introduce som=
e
> new feature, have become bottlenecked on my time to review them. =A0 =
It
> would be very helpful if we had more people reviewing patches. =A0And=
 it
> needs to be substantive reviews, and preferably from people who work =
at
> companies other than the developer who has submitted the patches.
>
> So some way that we can get more people reviewing patches would
> certainly be helpful. =A0There have been some people who have suggest=
ed
> different ways that we might do things, from the method used in XFS
> (where no patch gets submitted until it gets an independent review;
> which would be a bit scary since at the moment so little review takes
> place I'm concerned it would hold back development significantly), to
> giving people patchwork accounts and formally delegating work to peop=
le
> (it has worked for some subsystems, and utterly failed for others).
>
> Or we could keep going with the current method, with people
> understanding that if you review other people's patches, it makes it
> more likely I will have time to integrate your patches (and if some
> folks do more review work, I'll take that into account about which
> patches series I'm more likely to review myself for integration).
>

I am going to throw a crazy idea in the air -
Let the "long patch series" stand in line for review by the maintainer.
On every merge window, the maintainer may have time to review one (or l=
ess)
such long series.
If people know their patches need to stand in line for review, they wil=
l
have several ways to expedite the review/merge of their patches:
1. make the case why their feature is more valuable then others
2. make the case why a feature in front of them is less valuable then o=
thers
3. get someone else to do an independent review on their feature
4. review the patches in front of them, so they will be returned
    for another round of improvements (and come back at the end of the =
line)
    or better yet, be acked and merged.

don't know if this can work in practice, but it intrigues me as an expe=
riment
in game theory ;-)

Amir.

>
> What do you think? =A0This, like all of the other parts of this note,=
 was
> meant to start a discussion. =A0I've been extraordinarily pleased wit=
h
> Ext4 development: with what we've been able to achieve, and the peopl=
e
> we've managed to attract to use and to work on this project. =A0 With=
 your
> help, we can make things even better!
>
> Cheers,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
