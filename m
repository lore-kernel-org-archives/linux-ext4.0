From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/4] e2fsck: Discard only unused parts of inode table
Date: Mon, 12 Mar 2012 08:26:50 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1203120821290.5543@dhcp-27-109.brq.redhat.com>
References: <1330933776-2696-1-git-send-email-lczerner@redhat.com> <20120311192705.GE1048@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	sandeen@redhat.com
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab2CLH0z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Mar 2012 03:26:55 -0400
In-Reply-To: <20120311192705.GE1048@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 11 Mar 2012, Ted Ts'o wrote:

> On Mon, Mar 05, 2012 at 08:49:33AM +0100, Lukas Czerner wrote:
> > @@ -435,6 +481,7 @@ static void check_inode_bitmaps(e2fsck_t ctx)
> >  	int		skip_group = 0;
> >  	int		redo_flag = 0;
> >  	io_manager	manager = ctx->fs->io->manager;
> > +	unsigned long long	first_free = fs->super->s_inodes_per_group + 1;
> 
> This doesn't need to be an unsigned long long; an "int" will do just
> as well.
> 
> > +			/*
> > +			 * If the last inode is free, we can discard it as well.
> > +			 */
> > +			if (inodes >= first_free)
> > +				e2fsck_discard_inodes(ctx, group, first_free,
> > +						      inodes - first_free + 1);
> 
> There's no guarantee the last inode is free here.  This needs to read:
> 
> 			if (!bitmap && inodes >= first_free)

Hi Ted,

if the last inode is not free then:

	first_free = fs->super->s_inodes_per_group + 1;

so the condition

	if (inodes >= first_free)

would be false. Otherwise it is guaranteed that the last inode is free. But
I agree that your change makes it more obvious.

Thanks!
-Lukas

> 
> I'll fix this up in my version of the patches.
> 
> 					- Ted
> 
