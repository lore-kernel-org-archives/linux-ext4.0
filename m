From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: EXT4-fs (dm-1): Couldn't remount RDWR because of unprocessed
 orphan inode list
Date: Mon, 12 Sep 2011 21:52:26 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.1109122150060.9183@trent.utfs.org>
References: <alpine.DEB.2.01.1109021346290.9183@trent.utfs.org> <4E66478E.90102@redhat.com> <alpine.DEB.2.01.1109060923340.9183@trent.utfs.org> <4E664DFD.80308@redhat.com> <20110908185139.GA2393@quack.suse.cz> <alpine.DEB.2.01.1109091809180.9183@trent.utfs.org>
 <20110910200414.GA6709@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	mszeredi@suse.cz, Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from trent.utfs.org ([194.246.123.103]:56466 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab1IMEw3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Sep 2011 00:52:29 -0400
In-Reply-To: <20110910200414.GA6709@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 10 Sep 2011 at 22:04, Jan Kara wrote:
> On Fri 09-09-11 18:11:26, Christian Kujau wrote:
> > On Thu, 8 Sep 2011 at 20:51, Jan Kara wrote:
> > > There's race where VFS remount code can race with unlink and result will
> > > be unlinked file in orphan list on read-only filesystem. Christian seems to
> > > be hitting this race. Miklos Szeredi has patches
> > > (http://lkml.indiana.edu/hypermail/linux/kernel/1108.3/00169.html) to
> > > mostly close this hole but they're waiting for Al to find time to look at
> > > them / merge them AFAIK.
> > 
> > While these patches are still pending review, are they "dangerous" to 
> > apply? If not, I'd like to volunteer as a tester :-)
>   As far as I saw them, they should be pretty safe. So feel free to test
> them.

I've applied them to -rc5. It might take a few days untile the message 
occurs. Or, until "nothing happens", since I have the patches applied :-)

Meanwhile I'm trying to reproduce this issue on an x86 machine, but 
haven't succeeded yet.

Thanks,
Christian.
-- 
BOFH excuse #133:

It's not plugged in.
