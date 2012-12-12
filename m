From: Dave Chinner <david@fromorbit.com>
Subject: Re: A huge latency in ext4 and xfs because of stable page write
Date: Thu, 13 Dec 2012 10:07:41 +1100
Message-ID: <20121212230741.GX16353@dastard>
References: <20121211084520.GA13277@gmail.com>
 <20121211111707.GU15784@dastard>
 <20121212041803.GA29427@gmail.com>
 <20121212044948.GW16353@dastard>
 <20121212051332.GA6718@gmail.com>
 <CAAxjCEwtpTKTO_=1yjvqAA8itF35u4QQLyK0GNomt_PQZ7Rh8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org
To: Stefan Ring <stefanrin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:62929 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755149Ab2LLXHq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Dec 2012 18:07:46 -0500
Content-Disposition: inline
In-Reply-To: <CAAxjCEwtpTKTO_=1yjvqAA8itF35u4QQLyK0GNomt_PQZ7Rh8Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 12, 2012 at 08:23:43AM +0100, Stefan Ring wrote:
> >> http://www.spinics.net/lists/linux-fsdevel/msg59421.html
> >
> > Thanks for pointing out.  So now it seems that only I can do is to
> > present a proposal to revert stable page write temporarily because =
it
> > causes a huge latency for some applications.
>=20
> There has just been a write-up on the topic of stable pages in last
> week=E2=80=99s LWN: http://lwn.net/Articles/528031/
>=20
> The link should become available for non-subscribers tomorrow.

This is what subscriber links are for - when a LWN article is
relevant to a specific discussion, a subscriber can use their
discretion to post world readable link to the pay-walled article so
everyone is able to read the article....

This is one of the reasons I really like LWN and the way Jon has set
up subscriptions (and encourage anyone who doesn't subscribe to do
so). The paywall is something I *choose* to participate
in to get articles as quickly as possible, but have the option of
being able to let non-subscribers read articles immediately if *I*
consider it relevant to a discussion. That's definitely the case
here....

That said, a link has aleady been posted, so I don't have to do
anything but cheerlead here. :)

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
