From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: A huge latency in ext4 and xfs because of stable page write
Date: Wed, 12 Dec 2012 16:17:16 +0800
Message-ID: <20121212081715.GA8941@gmail.com>
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
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35017 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab2LLIED (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Dec 2012 03:04:03 -0500
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

Thanks, hopefully the new patch series can be applied as soon as
possible. :-)

Regards,
                                                - Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
