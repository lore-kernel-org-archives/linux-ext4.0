From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure
 FITRIM.
Date: Tue, 17 Jun 2014 12:49:53 +1000
Message-ID: <20140617024953.GG9508@dastard>
References: <1402625647-31439-1-git-send-email-jpa@google.com>
 <539A63C1.8010809@redhat.com>
 <20140613031538.GR4453@dastard>
 <20140613033029.GS4453@dastard>
 <CAKP4w2QvVUNp18jnX69eP0hjA-T6zn2sT3TQ-P6zpu-EhXZPAQ@mail.gmail.com>
 <20140613050703.GT4453@dastard>
 <20140613142054.GA23180@thunk.org>
 <20140613143157.GB23180@thunk.org>
 <CAKP4w2S24_z1zK+Pn_Hd+Hoh8BfbpJcEw1Bk685ESWN9r6R8Dw@mail.gmail.com>
 <20140613234134.GC5036@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: JP Abgrall <jpa@google.com>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org, Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:44691 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754056AbaFQCt5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jun 2014 22:49:57 -0400
Content-Disposition: inline
In-Reply-To: <20140613234134.GC5036@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 13, 2014 at 07:41:34PM -0400, Theodore Ts'o wrote:
> On Fri, Jun 13, 2014 at 12:44:34PM -0700, JP Abgrall wrote:
> > The per-file secure discard seems to be the way to go, as there are
> > only a few places in Android where this needs to be turned on.
> > The  current idletime-fstrim would  switch from FITRIM to SFITRIM to
> > reduce the leftovers.
> 
> OK, how about this?  The following patch is in the Google data center
> kernel, but I never got around to get it upstream (oops, was on my
> todo list, but it never happened).
> 
> If you want to adopt this for usptream, and add support for
> BLKSECDISCARD as well as BLKDISCARD, then you could for each file that
> you want to do the per-file secure discard, you would just have to
> open the file, call the BLKSECDISCARD ioctl, and then delete the file.
> 
> Cheers,
> 
> 					- Ted
> 
> commit 16ff6352b123aa134417793d636f05cd4e240eaa
> Author: Theodore Ts'o <tytso@google.com>
> Date:   Fri Dec 20 12:48:26 2013 -0500
> 
>     ext4: add support for the BLKDISCARD ioctl
>     
>     The blkdicard ioctl previously only worked on block devices.  Allow
>     this ioctl to work on ext4 files.
>     
>     This commit is intended to be sent upstream.

Not in that form - it's an ugly API hack.

This is really just an extension of hole punching (if the blocks in
the file are being removed) or zeroing (if the blocks are being
retained by the file). Either way, fallocate() is the interface
used for per-file block level manipulations, and either of these
operations could issue a discard (secure or not) during the
punch/zero operation....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
