From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [next-20101028] Call trace in ext4
Date: Thu, 28 Oct 2010 11:27:47 -0400
Message-ID: <20101028152747.GA16666@thunk.org>
References: <AANLkTi=E_uMj_ndGU86DCjX4aDwjHqg3dkwxjQRSJtq6@mail.gmail.com>
 <AANLkTin+GsrEFb2+tYD4ctg3o9t3wzpcywOkF9S1n6=0@mail.gmail.com>
 <AANLkTinOoxB4FnVXm1sSbW7zbdrEpA_dYzphh0CEWr-8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	sfr@canb.auug.org.au, Arnd Bergmann <arnd@arndb.de>
To: sedat.dilek@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47307 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503Ab0J1P1y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Oct 2010 11:27:54 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTinOoxB4FnVXm1sSbW7zbdrEpA_dYzphh0CEWr-8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 28, 2010 at 05:08:32PM +0200, Sedat Dilek wrote:
> I tried to GIT-pull ext4/upstream-merge and linux-2.6/master into
> linux-next (20101028), for both cases there occured CONFLICTS.
> So let's see if this is fixed in tommorow's linux-next patch .
> 
> For now, I switch to Linux 2.6.36-git11 and will report later.

Yeah, sorry.  What got dropped into Linux next was something that was
in the middle of getting prepared for the push to Linus.  Thanks to
the shortened merge window and things being crazy for me (between
$WORK stuff, Kernel Summit and Linux Plumber's Conference stuff, etc.)
some stuff didn't get fully finished in the ext4 tree until the very
last minute.

There were indeed a largish number of conflicts this time around,
mainly because of parallel development between the bio layer and ext4.
I suspect Stephen had not resolved those conflicts in the same way as
I had, and thus you had problems trying to pull in ext4/upstream-merge
into linux-next.

Linux 2.6.36-git11 has the full set of ext4 commits which I intended
to push to Linus before 37-rc1, and so linux-next should be free of
conflicts for tomorrow night.  Let me know if you have any problems
with -git11.

Regards,

						- Ted
