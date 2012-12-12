From: Stefan Ring <stefanrin@gmail.com>
Subject: Re: A huge latency in ext4 and xfs because of stable page write
Date: Wed, 12 Dec 2012 08:23:43 +0100
Message-ID: <CAAxjCEwtpTKTO_=1yjvqAA8itF35u4QQLyK0GNomt_PQZ7Rh8Q@mail.gmail.com>
References: <20121211084520.GA13277@gmail.com>
	<20121211111707.GU15784@dastard>
	<20121212041803.GA29427@gmail.com>
	<20121212044948.GW16353@dastard>
	<20121212051332.GA6718@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ye0-f174.google.com ([209.85.213.174]:61290 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2LLHXn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Dec 2012 02:23:43 -0500
In-Reply-To: <20121212051332.GA6718@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>> http://www.spinics.net/lists/linux-fsdevel/msg59421.html
>
> Thanks for pointing out.  So now it seems that only I can do is to
> present a proposal to revert stable page write temporarily because it
> causes a huge latency for some applications.

There has just been a write-up on the topic of stable pages in last
week=E2=80=99s LWN: http://lwn.net/Articles/528031/

The link should become available for non-subscribers tomorrow.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
