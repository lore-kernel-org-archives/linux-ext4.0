From: Jan Kara <jack@suse.cz>
Subject: Re: EXT4-fs (dm-1): Couldn't remount RDWR because of unprocessed
 orphan inode list
Date: Wed, 5 Oct 2011 20:03:39 +0200
Message-ID: <20111005180339.GG23467@quack.suse.cz>
References: <alpine.DEB.2.01.1109021346290.9183@trent.utfs.org>
 <4E66478E.90102@redhat.com>
 <alpine.DEB.2.01.1109060923340.9183@trent.utfs.org>
 <4E664DFD.80308@redhat.com>
 <20110908185139.GA2393@quack.suse.cz>
 <alpine.DEB.2.01.1109091809180.9183@trent.utfs.org>
 <20110910200414.GA6709@quack.suse.cz>
 <alpine.DEB.2.01.1109122150060.9183@trent.utfs.org>
 <alpine.DEB.2.01.1109152044090.5628@trent.utfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org, mszeredi@suse.cz,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35811 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934703Ab1JESDl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Oct 2011 14:03:41 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1109152044090.5628@trent.utfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 15-09-11 20:49:19, Christian Kujau wrote:
> On Mon, 12 Sep 2011 at 21:52, Christian Kujau wrote:
> > On Sat, 10 Sep 2011 at 22:04, Jan Kara wrote:
> > > On Fri 09-09-11 18:11:26, Christian Kujau wrote:
> > > > On Thu, 8 Sep 2011 at 20:51, Jan Kara wrote:
> > > > > There's race where VFS remount code can race with unlink and result will
> > > > > be unlinked file in orphan list on read-only filesystem. Christian seems to
> > > > > be hitting this race. Miklos Szeredi has patches
> > > > > (http://lkml.indiana.edu/hypermail/linux/kernel/1108.3/00169.html) to
> > > > > mostly close this hole but they're waiting for Al to find time to look at
> > > > > them / merge them AFAIK.
> > > > 
> > > > While these patches are still pending review, are they "dangerous" to 
> > > > apply? If not, I'd like to volunteer as a tester :-)
> > >   As far as I saw them, they should be pretty safe. So feel free to test
> > > them.
> > 
> > I've applied them to -rc5. It might take a few days untile the message 
> > occurs. Or, until "nothing happens", since I have the patches applied :-)
> 
> With Miklos' patches applied to -rc5, this happend again just now :-(
  Thanks for careful testing! Hmm, since you are able to reproduce on ppc
but not on x86 there might be some memory ordering bug in Miklos' patches
or it's simply because of different timing. Miklos, care to debug this
further?

> > Meanwhile I'm trying to reproduce this issue on an x86 machine, but 
> > haven't succeeded yet.
> 
> After a ~3k remounts with constantly reading from the filesystem in 
> question[0], I still was NOT able to reproduce this on an x86 VM :(
> 
> Any ideas?


								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
