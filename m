From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Question: errors=continue behaviour for failed external journal
 device
Date: Mon, 28 Jul 2014 09:17:42 -0400
Message-ID: <20140728131742.GP6725@thunk.org>
References: <loom.20140727T010632-633@post.gmane.org>
 <20140727000733.GV6725@thunk.org>
 <alpine.LFD.2.00.1407281107530.2077@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Vlad Dobrotescu <vlad@dobrotescu.ca>, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60569 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbaG1NRq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jul 2014 09:17:46 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1407281107530.2077@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 28, 2014 at 11:11:45AM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> I very much agree with that, that's why I was quite surprised that I
> found out recently that this is the default. I was living in the
> delusion that the default was ERRORS_RO for as long as I can remember=
=2E
> So my question is, should we change it ? This really does not seem
> like a sane default.

Yeah, I've been thinking that this would be a good thing to change for
1.43.

The only reason that errors=3Dcontinue was the default was for
historical reasons.  I could imagine some system administrators being
surprised when all of a sudden their production systems start getting
lots of EROFS errors getting reported by applications.  So I could
potentially imagine some Help Desks / Support folks at distributions
not being enthusiastic about such a change.

Hmm.... we are starting to have some errors where we can allow the
system to stagger on, even if we need to disallow new allocations in
some block groups.  I wonder if it is worthwhile to have a "continue
for correctable errors".  The danger, of course, is that some errors,
even if they are correctable, (such as freeing a block which is
already freed), could be a hint that there are other fs corruptions,
not yet detected, that might lead to data loss if we reboot and fsck,
or remount readonly right away.  So the question is while there is
some value, is it worth the added complexity to add an
"errors=3Dcontinue-correctable" option?

							- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
