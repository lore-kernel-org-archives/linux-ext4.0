From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Thu, 3 Feb 2011 23:57:25 +0200
Message-ID: <AANLkTi=wAX8yLSsbn-zM5t6DrE22asYnz6KdQBfSYuUT@mail.gmail.com>
References: <20110203144011.GA28409@quack.suse.cz>
	<4D4AC4E2.701@redhat.com>
	<AANLkTi=YxSpgm9vYHBKdASpLOaY_U3=ggsE8yTg_G0Bc@mail.gmail.com>
	<4D4B06AF.6000106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Michael Rubin <mrubin@google.com>, Jan Kara <jack@suse.cz>,
	lsf-pc@lists.linuxfoundation.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36309 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab1BCV5a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Feb 2011 16:57:30 -0500
In-Reply-To: <4D4B06AF.6000106@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 3, 2011 at 9:49 PM, Eric Sandeen <sandeen@redhat.com> wrote=
:
>
> On 2/3/11 1:32 PM, Michael Rubin wrote:
> > On Thu, Feb 3, 2011 at 7:08 AM, Eric Sandeen <sandeen@redhat.com> w=
rote:
> >> If we can have a real plan for moving in this direction though, I'=
d
> >> support it. =A0I'm just not sure how we get enough real testing un=
der
> >> our belts to be comfortable with dropping ext[23], especially as
> >> most distros now default to ext4 anyway.
> >
> > Eric what sort of testing are you looking for?
>
> Anything, the more formal or more widespread the better.
>
> I just don't think it's used much this way today...
>
> We can start with xfstests etc but I'd be more concerned about
> unexpected behavioral or performance changes.
>
> > I admit I like having ext2 around for comparisons in bug situations=
=2E
> > It really helps to isolate the problem area. How painful is the
> > upkeep?
>
> since ext4 was merged, about 450 commits to ext2 & ext3 files.
>
> since 2.6.32, about 150 commits.
>

Can you give a rough estimate of how those commits diverge between
bugfixes, kernel API changes, code cleanups?

Next3 has been following ext3 since 2.6.31 and I remember changes of
the 2 latter,
but not many major bugfixes.

I hardly think we can get away with throwing out ext3 code base, but
maybe it can go
into bugfixes-only mode? that is unless Jan likes to apply cleanups ;-)

Amir.

> Translating that into pain units, I dunno. =A0In distro-land, I often
> have bugfixes that need to hit 2 or 3 of the filesystems as well.
>
> -Eric
>
> > mrubin
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
