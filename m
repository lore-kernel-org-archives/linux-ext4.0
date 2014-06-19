From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure
 FITRIM.
Date: Thu, 19 Jun 2014 10:15:49 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406191014510.2182@localhost.localdomain>
References: <CAKP4w2S24_z1zK+Pn_Hd+Hoh8BfbpJcEw1Bk685ESWN9r6R8Dw@mail.gmail.com> <20140613234134.GC5036@thunk.org> <20140617024953.GG9508@dastard> <alpine.LFD.2.00.1406171346570.2148@localhost.localdomain> <20140617124629.GA13868@thunk.org>
 <alpine.LFD.2.00.1406171449000.2148@localhost.localdomain> <20140617135405.GA5054@thunk.org> <CAKP4w2QSUYYFVeM2_a7iMybnad_A27WEx3K=qiMf-_namjvS-A@mail.gmail.com> <alpine.LFD.2.00.1406181125440.3406@localhost.localdomain> <20140618220601.GA5114@thunk.org>
 <20140619003657.GF4453@dastard>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-112459312-1403165753=:2182"
Cc: "Theodore Ts'o" <tytso@mit.edu>, JP Abgrall <jpa@google.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757460AbaFSIP5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jun 2014 04:15:57 -0400
In-Reply-To: <20140619003657.GF4453@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-112459312-1403165753=:2182
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 19 Jun 2014, Dave Chinner wrote:

> Date: Thu, 19 Jun 2014 10:36:57 +1000
> From: Dave Chinner <david@fromorbit.com>
> To: Theodore Ts'o <tytso@mit.edu>
> Cc: Lukáš Czerner <lczerner@redhat.com>, JP Abgrall <jpa@google.com>,
>     Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
>     Geremy Condra <gcondra@google.com>,
>     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
> Subject: Re: [PATCH] ext4: Add support for SFITRIM,
>     an ioctl for secure FITRIM.
> 
> On Wed, Jun 18, 2014 at 06:06:01PM -0400, Theodore Ts'o wrote:
> > On Wed, Jun 18, 2014 at 11:33:47AM +0200, Lukáš Czerner wrote:
> > > And I have no illusion that those are the only ones that does not
> > > work. This hardware can not be trusted and this must not be
> > > advertised as a security feature.
> > 
> > There's always crappy hardware out there.  If that's true, should then
> > not call ATA Secure Erase by that term because somewhere out there,
> > there will be an incompetently implemented SSD that doesn't do the
> > right thing with ATA Secure Erase?  I just don't think that's
> > particularly useful.  If the command is called "secure erase" or
> > "secure discard" in the specification, then that's what we should use,
> > just to avoid confusion if nothing else.
> 
> That's just a steaming pile of rhetoric. If that was true, then we
> wouldn't be calling our operations BLKDISCARD or "discard", would
> we?  It would be called "TRIM" or "WRITE_SAME" because that's what
> the device layer standards call the operations.
> 
> Sure, we have a "FITRIM" ioctl, but we acknowledged early on that it
> was badly named because different protocols use different names.
> That's why we started to use "discard" instead - it's a protocol and
> device neutral term that describes the intent of the operation - to
> -discard blocks-.
> 
> IOWs, I think that Lukas is right on the money here - we should not
> imply something is secure when it is not, nor should we name high
> level interfaces based on the standardise name on the low level
> primitive some class of device or protocol uses. 
> 
> Rather, we should describe it for what it is: it is a command
> to *scrub the data* from a range of blocks. i.e. it's not a
> discard operation at all - it's a "scrub" operation that we are
> asking the device to perform.
> 
> And further, scrubbing has a specific meaning in the security
> environment - it doesn't imply security - it just means there is a
> mechanism for physically removing data from it's known locations.
> Security comes from what you do with the scrubbing mechanism at
> higher layers.
> 
> Scrubbing is something people already understand and it's clear
> that it's a data manipulation operation and not some magic "secure"
> operation. And by calling it "scrub" we get away from the idea that
> it only works on specific hardware - hardware acceleration is good,
> but there's no reason why we should design the functionality to only
> be useful on systems with hardware scrubbing capability...

+1 for the "scrub" operation, it makes perfect sense to me.

-Lukas

> 
> Cheers,
> 
> Dave.
> 
--8323328-112459312-1403165753=:2182--
