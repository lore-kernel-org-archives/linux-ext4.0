From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: zero out blocks of freed user data for operation a virtual  machine environment
Date: Tue, 26 May 2009 12:22:38 +0200
Message-ID: <87ab50p3ip.fsf@frosties.localdomain>
References: <20090524170045.GC24753@cip.informatik.uni-erlangen.de>
	<20090524101551.57b706e9@infradead.org>
	<20090524173933.GD24753@cip.informatik.uni-erlangen.de>
	<20090525120320.GA25908@mit.edu>
	<20090525123430.GA5534@cip.informatik.uni-erlangen.de>
	<87ab51qq91.fsf@frosties.localdomain>
	<f3177b9e0905251023n762b815akace1ae34e643458e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:53835 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbZEZKWo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 May 2009 06:22:44 -0400
In-Reply-To: <f3177b9e0905251023n762b815akace1ae34e643458e@mail.gmail.com>
	(Chris Worley's message of "Mon, 25 May 2009 11:23:05 -0600")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Chris Worley <worleys@gmail.com> writes:

> On Mon, May 25, 2009 at 7:14 AM, Goswin von Brederlow <goswin-v-b@web=
=2Ede>
> wrote:
>
>
>                Thomas Glanzmann <thomas@glanzmann.de> writes:
>     =20
>      > Hello Ted,
>      >
>      >> Yes, it does, sb_issue_discard(). =A0So if you wanted to hook=
 into
>      this
>      >> routine with a function which issued calls to zero out blocks=
, it
>      >> would be easy to create a private patch.
>      >
>      > that sounds good because it wouldn't only target the most used
>      > filesystem but every other filesystem that uses the interface =
as
>      well.
>      > Do you think that a tunable or configurable patch has a chance=
 to
>      hit
>      > upstream as well?
>      >
>      > =A0 =A0 =A0 =A0 Thomas
>     =20
>     =20
>
>
>      I could imagine a device mapper target that eats TRIM commands a=
nd
>      writes out zeroes instead. That should be easy to maintain outsi=
de
>      or
>      inside the upstream kernel source.
>
>
> Why bother with a time-consuming performance-draining operation?=A0 T=
here are
> devices that already support TRIM/discard commands today, and once yo=
u discard
> a block, it's completely irretrievable (you'll just get back zeros if=
 you try
> to read that block w/o writing it after the discard).
> Chris=A0

Because you have one of the billions of devices that don't.

Because, iirc, the specs say nothing about getting back zeros.

Because someone could read the raw data from disk and recover your
state secrets.

Because loopback don't support TRIM and compression of the image file
is much better with zeroes.

Because on a crypted device TRIM would show how much of the device is
in used while zeroing out (before crypting) would result in random
data.

Because it is fun?

So many reasons.

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
