From: Chris Worley <worleys@gmail.com>
Subject: RE: zero out blocks of freed user data for operation a virtual
	machine environment
Date: Mon, 25 May 2009 11:26:15 -0600
Message-ID: <f3177b9e0905251026u54d6b1e0s884dbdedf74b17cd@mail.gmail.com>
References: <20090524170045.GC24753@cip.informatik.uni-erlangen.de>
	 <20090524101551.57b706e9@infradead.org>
	 <20090524173933.GD24753@cip.informatik.uni-erlangen.de>
	 <20090525120320.GA25908@mit.edu>
	 <20090525123430.GA5534@cip.informatik.uni-erlangen.de>
	 <87ab51qq91.fsf@frosties.localdomain>
	 <f3177b9e0905251023n762b815akace1ae34e643458e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:5458 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbZEYRuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 May 2009 13:50:44 -0400
In-Reply-To: <f3177b9e0905251023n762b815akace1ae34e643458e@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 25, 2009 at 7:14 AM, Goswin von Brederlow <goswin-v-b@web.d=
e> wrote:
> Thomas Glanzmann <thomas@glanzmann.de> writes:
> > Hello Ted,
> >
> >> Yes, it does, sb_issue_discard(). =A0So if you wanted to hook into=
 this
> >> routine with a function which issued calls to zero out blocks, it
> >> would be easy to create a private patch.
> >
> > that sounds good because it wouldn't only target the most used
> > filesystem but every other filesystem that uses the interface as we=
ll.
> > Do you think that a tunable or configurable patch has a chance to h=
it
> > upstream as well?
> >
> > =A0 =A0 =A0 =A0 Thomas
>
> I could imagine a device mapper target that eats TRIM commands and
> writes out zeroes instead. That should be easy to maintain outside or
> inside the upstream kernel source.

Why bother with a time-consuming performance-draining operation?
There are devices that already support TRIM/discard commands today,
and once you discard a block, it's completely irretrievable (you'll
just get back zeros if you try to read that block w/o writing it after
the discard).

Chris
>
>
> MfG
> =A0 =A0 =A0 =A0Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
