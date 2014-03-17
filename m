From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 0/6 v2] Introduce FALLOC_FL_ZERO_RANGE flag for
 fallocate
Date: Mon, 17 Mar 2014 16:10:52 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1403171603390.30625@localhost.localdomain>
References: <1393355679-11160-1-git-send-email-lczerner@redhat.com> <20140316190820.GB14162@thunk.org> <20140317021909.GD14162@thunk.org> <alpine.LFD.2.00.1403171346280.30625@localhost.localdomain> <20140317132901.GA2773@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-274714687-1395069056=:30625"
Cc: =?utf-8?B?THVrw6HFoSBDemVybmVyIDxsY3plcm5lckByZWRoYXQuY29tPg==?=@thunk.org,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933079AbaCQPLI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Mar 2014 11:11:08 -0400
In-Reply-To: <20140317132901.GA2773@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-274714687-1395069056=:30625
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 17 Mar 2014, tytso@mit.edu wrote:

> Date: Mon, 17 Mar 2014 09:29:01 -0400
> From: tytso@mit.edu
> To: =?utf-8?B?THVrw6HFoSBDemVybmVyIDxsY3plcm5lckByZWRoYXQuY29tPg==?=@thunk.org
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 0/6 v2] Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
> 
> On Mon, Mar 17, 2014 at 01:50:46PM +0100, Lukáš Czerner wrote:
> > > Running the tests with the dev2 branch, which includes all of the
> > > ext4-specific ZERO_RANGE patches, we see a regression with shared/243
> > > with 4k and 1k block sizes (as well as 4k in no-journal mode):
> > 
> > Oh, right. This fails because the test really should be deprecated
> > since we already removed the check in e2fsck - see e2fsprogs commit
> > 010dc7b90d97b93907cbf57b3b44f1c1cad234f6.
> > 
> > In this patch I removed setting the EXT4_INODE_EOFBLOCKS, however I
> > forgot the mention that in the description. Sorry about that.
> 
> I'm not sure how removing setting the EXT4_INODE_EOFBLOCKS flag would
> result in shared/243 failing in this particular way.  The EOFBLOCKS
> flag never influenced how the userspace-visible behavior of the
> kernel; it only set a flag which told e2fsck that it was OK to have
> blocks mapped beyond i_size. 

Yes, shared/243 is actually looking at the file system using debugfs
trying to figure out whether this flag is set or not. And that is
what is failing.

See the 243.full output:

Test 1: Fallocate 40960 bytes and write 4096 bytes (buffered io).
EOFBLOCK_FL bit is not set.
Error: Current bit state incorrect.

However I am not really sure why is this in shared since this is
only useful for ext4.

> 
> So removing EOFBLOCKS could potentially cause false positives by
> e2fsck for e2fsprogs previous to 1.42.2 (or which do not have the
> above mentioned commit pulled on).  That's the main reason to keep
> support for setting EOFBLOCKS in the kernel --- to avoid causing user
> help desk reports if they try using a newer kernel w/o updating the
> version of e2fsprogs on their enterprise kernel distro (not that users
> _ever_ upgrade the kernel on their own ;-).

I believe that we're not very consistent with that anyway. That was
part of the reason why we got rid of it in e2fsck. However I agree
that this might cause additional problems. So it might be better to
just keep this in kernel for now...

> 
> But I'm not sure how this would cause the xfstests failure detailed
> below?  And how would just updating the commit description deal with
> the fact that shared/243 is failing?

See above. If we decide to remote the EXT4_INODE_EOFBLOCKS from
kernel then this tests has to go as well.

Btw. I am not able to call in for the ext4 call today, sorry.

Thanks!
-Lukas

> 
>     	      				- Ted
> 
--8323328-274714687-1395069056=:30625--
