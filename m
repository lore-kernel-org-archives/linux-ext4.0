From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Question: errors=continue behaviour for failed external journal
 device
Date: Mon, 28 Jul 2014 15:25:52 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1407281522110.2077@localhost.localdomain>
References: <loom.20140727T010632-633@post.gmane.org> <20140727000733.GV6725@thunk.org> <alpine.LFD.2.00.1407281107530.2077@localhost.localdomain> <20140728131742.GP6725@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-703349997-1406553955=:2077"
Cc: Vlad Dobrotescu <vlad@dobrotescu.ca>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbaG1N0A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jul 2014 09:26:00 -0400
In-Reply-To: <20140728131742.GP6725@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-703349997-1406553955=:2077
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 28 Jul 2014, Theodore Ts'o wrote:

> Date: Mon, 28 Jul 2014 09:17:42 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Vlad Dobrotescu <vlad@dobrotescu.ca>, linux-ext4@vger.kernel.org
> Subject: Re: Question: errors=continue behaviour for failed external journal
>     device
> 
> On Mon, Jul 28, 2014 at 11:11:45AM +0200, Lukáš Czerner wrote:
> > 
> > I very much agree with that, that's why I was quite surprised that I
> > found out recently that this is the default. I was living in the
> > delusion that the default was ERRORS_RO for as long as I can remember.
> > So my question is, should we change it ? This really does not seem
> > like a sane default.
> 
> Yeah, I've been thinking that this would be a good thing to change for
> 1.43.
> 
> The only reason that errors=continue was the default was for
> historical reasons.  I could imagine some system administrators being
> surprised when all of a sudden their production systems start getting
> lots of EROFS errors getting reported by applications.  So I could
> potentially imagine some Help Desks / Support folks at distributions
> not being enthusiastic about such a change.
> 
> Hmm.... we are starting to have some errors where we can allow the
> system to stagger on, even if we need to disallow new allocations in
> some block groups.  I wonder if it is worthwhile to have a "continue
> for correctable errors".  The danger, of course, is that some errors,
> even if they are correctable, (such as freeing a block which is
> already freed), could be a hint that there are other fs corruptions,
> not yet detected, that might lead to data loss if we reboot and fsck,
> or remount readonly right away.  So the question is while there is
> some value, is it worth the added complexity to add an
> "errors=continue-correctable" option?

Right,

I like the idea of the new errors option, even though the name is a
bit long (maybe "auto") which will try the best to continue, but is
allowed to remount read only if we can not recover from that error.

This would however need some work to make it work reliably and most
importantly a fair amount of testing. Though I think it's worth the
work.

-Lukas

> 
> 							- Ted
--8323328-703349997-1406553955=:2077--
