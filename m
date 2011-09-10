From: Jan Kara <jack@suse.cz>
Subject: Re: EXT4-fs (dm-1): Couldn't remount RDWR because of unprocessed
 orphan inode list
Date: Sat, 10 Sep 2011 22:04:14 +0200
Message-ID: <20110910200414.GA6709@quack.suse.cz>
References: <alpine.DEB.2.01.1109021346290.9183@trent.utfs.org>
 <4E66478E.90102@redhat.com>
 <alpine.DEB.2.01.1109060923340.9183@trent.utfs.org>
 <4E664DFD.80308@redhat.com>
 <20110908185139.GA2393@quack.suse.cz>
 <alpine.DEB.2.01.1109091809180.9183@trent.utfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org, mszeredi@suse.cz,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42948 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933495Ab1IJUEQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Sep 2011 16:04:16 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1109091809180.9183@trent.utfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 09-09-11 18:11:26, Christian Kujau wrote:
> On Thu, 8 Sep 2011 at 20:51, Jan Kara wrote:
> > There's race where VFS remount code can race with unlink and result will
> > be unlinked file in orphan list on read-only filesystem. Christian seems to
> > be hitting this race. Miklos Szeredi has patches
> > (http://lkml.indiana.edu/hypermail/linux/kernel/1108.3/00169.html) to
> > mostly close this hole but they're waiting for Al to find time to look at
> > them / merge them AFAIK.
> 
> While these patches are still pending review, are they "dangerous" to 
> apply? If not, I'd like to volunteer as a tester :-)
  As far as I saw them, they should be pretty safe. So feel free to test
them.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
