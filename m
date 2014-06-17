From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure
 FITRIM.
Date: Tue, 17 Jun 2014 15:00:40 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406171449000.2148@localhost.localdomain>
References: <20140613031538.GR4453@dastard> <20140613033029.GS4453@dastard> <CAKP4w2QvVUNp18jnX69eP0hjA-T6zn2sT3TQ-P6zpu-EhXZPAQ@mail.gmail.com> <20140613050703.GT4453@dastard> <20140613142054.GA23180@thunk.org> <20140613143157.GB23180@thunk.org>
 <CAKP4w2S24_z1zK+Pn_Hd+Hoh8BfbpJcEw1Bk685ESWN9r6R8Dw@mail.gmail.com> <20140613234134.GC5036@thunk.org> <20140617024953.GG9508@dastard> <alpine.LFD.2.00.1406171346570.2148@localhost.localdomain> <20140617124629.GA13868@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-25785589-1403010044=:2148"
Cc: Dave Chinner <david@fromorbit.com>, JP Abgrall <jpa@google.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbaFQNAx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Jun 2014 09:00:53 -0400
In-Reply-To: <20140617124629.GA13868@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-25785589-1403010044=:2148
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 17 Jun 2014, Theodore Ts'o wrote:

> Date: Tue, 17 Jun 2014 08:46:29 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Dave Chinner <david@fromorbit.com>, JP Abgrall <jpa@google.com>,
>     Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
>     Geremy Condra <gcondra@google.com>,
>     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
> Subject: Re: [PATCH] ext4: Add support for SFITRIM,
>     an ioctl for secure FITRIM.
> 
> On Tue, Jun 17, 2014 at 01:55:26PM +0200, Lukáš Czerner wrote:
> > 
> > I definitely agree with Dave here it is an ugly API hack. Fallocate
> > seems much more suitable for this.
> > 
> > New flag FALLOC_FL_ISSUE_DISCARD which would work with
> > FALLOC_FL_PUNCH_HOLE, FALLOC_FL_ZERO_RANGE and possibly
> > FALLOC_FL_COLLAPSE_RANGE might actually be useful.
> 
> I agree it would be useful to have an FL_ISSUE_DISCARD (and while
> we're at it, FL_ISSUE_SECDISCARD) as an fallocate flag.  That doesn't
> obviate the usefulness of a BLKDISCARD ioctl for ext4 files, though.
> 
> Something else that might be useful, and perhaps more appropriate for
> the Android use case, is to add a SECDISCARD flag to the unlinkat(2)
> system call.  That way, people who want to do a "discard and then
> unlink" don't have to be forced to do an open(2), fallocate(2),
> close(2), and only *then* the unlink(2) system call.

What is the difference between -o discard mount option ? I guess
that this way you can do it selectively on certain files, but I
wonder how useful it is going to be anyway ?

Nevertheless, I think that there is a conclusion that there is no
"security" to be had with file system and SECDISCARD. And no secure
erase with this type of interface would be "secure" enough.

If they are ok with only best effort, then we can have FISTRIM ioctl
which would use the same internal file system functionality as
FITRIM but we would add a flag to be able to call sb_issue_discard()
with BLKDEV_DISCARD_SECURE flag, disable the optimization to skip
already discarded groups and call sync on the file system before we
start doing any actuall work. I wish I added flags to the FITRIM
ioctl when I created it...

If we do this though we should not add word "security" anywhere for
the use to see :)

-Lukas

> 
> Cheers,
> 
> 						- Ted
> 
--8323328-25785589-1403010044=:2148--
