From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure
 FITRIM.
Date: Thu, 19 Jun 2014 10:33:32 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406191011320.2182@localhost.localdomain>
References: <20140613143157.GB23180@thunk.org> <CAKP4w2S24_z1zK+Pn_Hd+Hoh8BfbpJcEw1Bk685ESWN9r6R8Dw@mail.gmail.com> <20140613234134.GC5036@thunk.org> <20140617024953.GG9508@dastard> <alpine.LFD.2.00.1406171346570.2148@localhost.localdomain>
 <20140617124629.GA13868@thunk.org> <alpine.LFD.2.00.1406171449000.2148@localhost.localdomain> <20140617135405.GA5054@thunk.org> <CAKP4w2QSUYYFVeM2_a7iMybnad_A27WEx3K=qiMf-_namjvS-A@mail.gmail.com> <alpine.LFD.2.00.1406181125440.3406@localhost.localdomain>
 <20140618220601.GA5114@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-722811090-1403165576=:2182"
Cc: JP Abgrall <jpa@google.com>, Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757644AbaFSIdl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jun 2014 04:33:41 -0400
In-Reply-To: <20140618220601.GA5114@thunk.org>
Content-ID: <alpine.LFD.2.00.1406191016170.2182@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-722811090-1403165576=:2182
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.2.00.1406191016171.2182@localhost.localdomain>

On Wed, 18 Jun 2014, Theodore Ts'o wrote:

> Date: Wed, 18 Jun 2014 18:06:01 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Luká¨ Czerner <lczerner@redhat.com>
> Cc: JP Abgrall <jpa@google.com>, Dave Chinner <david@fromorbit.com>,
>     Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
>     Geremy Condra <gcondra@google.com>,
>     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
> Subject: Re: [PATCH] ext4: Add support for SFITRIM,
>     an ioctl for secure FITRIM.
> 
> On Wed, Jun 18, 2014 at 11:33:47AM +0200, Luká¨ Czerner wrote:
> > Except when it does not. Looking at the mmc driver I can see that we
> > have already some devices where secure trim is broken.
> > 
> > /*
> >  * On these Samsung MoviNAND parts, performing secure erase or
> >  * secure trim can result in unrecoverable corruption due to a
> >  * firmware bug.
> >  */
> 
> The bug IMHO is that the eMMC driver is falling back to discard,
> instead of returning EOPNOTSUPP.  The question of whether we should
> fall back to discard or not should be made at a level much higher up
> than the MMC device driver....

Yes, that's what I meant and I already sent a patch to return
EOPNOTSUPP.

> 
> > And I have no illusion that those are the only ones that does not
> > work. This hardware can not be trusted and this must not be
> > advertised as a security feature.
> 
> There's always crappy hardware out there.  If that's true, should then
> not call ATA Secure Erase by that term because somewhere out there,
> there will be an incompetently implemented SSD that doesn't do the
> right thing with ATA Secure Erase?  I just don't think that's
> particularly useful.  If the command is called "secure erase" or
> "secure discard" in the specification, then that's what we should use,
> just to avoid confusion if nothing else.
> 
> Now, if the spec explicitly disclaims correct behavior, in the case of
> discard and discard zeros data, that's a different matter.  But I
> don't think that is what's going on here.  The MMC specification makes
> certain guarantees; there is no "the drive is allowed to disregard the
> discard command if it's too busy to attend to it mealy-mouthed
> language", as there is in the ATA discard specification.
> 
> The fact that there happens to be buggy hardware out there, is just
> the natural state of affairs.  But that's what black lists are for.

But there is no "security" in the way we're using it right now.
Moreover the secure trim command is actually split to two commands,
one which can be called multiple times to identify all the block
ranges and second one which will actually do the job. If the write
comes in between than the respective block (or blocks) will not be
processed. I do not think that this can happen as it is implemented
right now, but I might be wrong.

However currently we're not using it to it's full potential since
we're only doing the first step once, but I can imagine doing the
first step for all the ranges we want to discard and then doing the
actual discard. In that case we would actually need some guarantees
that no write can come in between. Also we would probably need some
protection against power failure and so on.

And what about defragmentation ? When the data is moving around we can
no longer tell where the previous version of that particular piece of
data is.

And I am sure there are loads of other problems as well, so
currently there are no guarantees at all and it simple does not have
anything to do with security. That's perfectly fine as long as we do
not staple it as "secure" operation. I think that the confusion here
comes from different point of view of the higher level file system and
the lower level device itself as Dave already pointed out.

-Lukas

> 
>     	    	     	       	   - Ted
--8323328-722811090-1403165576=:2182--
