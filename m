From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Massive corruption on RAID0
Date: Tue, 30 Jun 2009 11:46:18 -0500
Message-ID: <4A4A415A.1070207@redhat.com>
References: <298610bb0906281738u2e1ce91fnc753acc145d759bb@mail.gmail.com>	 <4A48355D.5040001@redhat.com>	 <298610bb0906290812t249c7e52l80e57af36bd0e80c@mail.gmail.com>	 <4A4A3065.4020202@redhat.com> <87f94c370906300942p7c5f576cgbb8c065625cf1716@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?ISO-8859-2?Q?Krzysztof_Kosi=F1ski?= <tweenk.pl@gmail.com>,
	linux-ext4@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43239 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938AbZF3QqS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Jun 2009 12:46:18 -0400
In-Reply-To: <87f94c370906300942p7c5f576cgbb8c065625cf1716@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Greg Freemyer wrote:
> 2009/6/30 Eric Sandeen <sandeen@redhat.com>:
>> Krzysztof Kosi=F1ski wrote:
> <snip>
>>>>> By the way, is there some way to have RAID0-like functionality wi=
th
>>> write barriers?
>> Mirrors can pass barriers, IIRC, but not stripes (IIRC...) - I don't
>> know if any work is being done to address this.
>>
> I'm pretty sure mdraid is not attempting to address it.
>=20
> The issue is that barriers with a single drive can simply be sent to
> the drive for it to do the heavy lifting.
>=20
> With raid-0, it is much more difficult.
>=20
> ie. you send a barrier to 2 different drives.  One drive takes 30
> milliseconds to flush the pre-barrier queue to disk and then continue=
s
> working on the post barrier data .  The other drive takes 500
> milliseconds to do the same.  The end result is out of sync barriers.
> Not at all what the filesystem expects.
>=20
> The only reliable solution is to disable write caching on the drives.
> Of course you don't need barriers then.

Agreed this is the best solution at least for now.  But, the dm folks
are apparently working on some sort of barrier solution for stripes, I
think.  I don't know the details, perhaps I should.... :)

-Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
