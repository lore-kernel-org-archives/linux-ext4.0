From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure
 FITRIM.
Date: Tue, 17 Jun 2014 13:55:26 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406171346570.2148@localhost.localdomain>
References: <1402625647-31439-1-git-send-email-jpa@google.com> <539A63C1.8010809@redhat.com> <20140613031538.GR4453@dastard> <20140613033029.GS4453@dastard> <CAKP4w2QvVUNp18jnX69eP0hjA-T6zn2sT3TQ-P6zpu-EhXZPAQ@mail.gmail.com> <20140613050703.GT4453@dastard>
 <20140613142054.GA23180@thunk.org> <20140613143157.GB23180@thunk.org> <CAKP4w2S24_z1zK+Pn_Hd+Hoh8BfbpJcEw1Bk685ESWN9r6R8Dw@mail.gmail.com> <20140613234134.GC5036@thunk.org> <20140617024953.GG9508@dastard>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Theodore Ts'o" <tytso@mit.edu>, JP Abgrall <jpa@google.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbaFQLzj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Jun 2014 07:55:39 -0400
In-Reply-To: <20140617024953.GG9508@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 17 Jun 2014, Dave Chinner wrote:

> Date: Tue, 17 Jun 2014 12:49:53 +1000
> From: Dave Chinner <david@fromorbit.com>
> To: Theodore Ts'o <tytso@mit.edu>
> Cc: JP Abgrall <jpa@google.com>, Eric Sandeen <sandeen@redhat.com>,
>     linux-ext4@vger.kernel.org, Geremy Condra <gcondra@google.com>,
>     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
> Subject: Re: [PATCH] ext4: Add support for SFITRIM,
>     an ioctl for secure FITRIM.
> 
> On Fri, Jun 13, 2014 at 07:41:34PM -0400, Theodore Ts'o wrote:
> > On Fri, Jun 13, 2014 at 12:44:34PM -0700, JP Abgrall wrote:
> > > The per-file secure discard seems to be the way to go, as there are
> > > only a few places in Android where this needs to be turned on.
> > > The  current idletime-fstrim would  switch from FITRIM to SFITRIM to
> > > reduce the leftovers.
> > 
> > OK, how about this?  The following patch is in the Google data center
> > kernel, but I never got around to get it upstream (oops, was on my
> > todo list, but it never happened).
> > 
> > If you want to adopt this for usptream, and add support for
> > BLKSECDISCARD as well as BLKDISCARD, then you could for each file that
> > you want to do the per-file secure discard, you would just have to
> > open the file, call the BLKSECDISCARD ioctl, and then delete the file.
> > 
> > Cheers,
> > 
> > 					- Ted
> > 
> > commit 16ff6352b123aa134417793d636f05cd4e240eaa
> > Author: Theodore Ts'o <tytso@google.com>
> > Date:   Fri Dec 20 12:48:26 2013 -0500
> > 
> >     ext4: add support for the BLKDISCARD ioctl
> >     
> >     The blkdicard ioctl previously only worked on block devices.  Allow
> >     this ioctl to work on ext4 files.
> >     
> >     This commit is intended to be sent upstream.
> 
> Not in that form - it's an ugly API hack.
> 
> This is really just an extension of hole punching (if the blocks in
> the file are being removed) or zeroing (if the blocks are being
> retained by the file). Either way, fallocate() is the interface
> used for per-file block level manipulations, and either of these
> operations could issue a discard (secure or not) during the
> punch/zero operation....

I definitely agree with Dave here it is an ugly API hack. Fallocate
seems much more suitable for this.

New flag FALLOC_FL_ISSUE_DISCARD which would work with
FALLOC_FL_PUNCH_HOLE, FALLOC_FL_ZERO_RANGE and possibly
FALLOC_FL_COLLAPSE_RANGE might actually be useful.

-Lukas

> 
> Cheers,
> 
> Dave.
> 
