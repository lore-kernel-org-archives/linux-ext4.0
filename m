From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/4] exofs: Handle error from d_splice_alias()
Date: Tue, 12 Jun 2012 11:04:12 +0200
Message-ID: <20120612090412.GB6021@quack.suse.cz>
References: <1338322067-17566-1-git-send-email-jack@suse.cz>
 <4FC5F8CC.20400@panasas.com>
 <20120608215950.GQ30000@ZenIV.linux.org.uk>
 <4FD611AA.5010006@panasas.com>
 <20120611190108.GF16086@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boaz Harrosh <bharrosh@panasas.com>,
	Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab2FLJEP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jun 2012 05:04:15 -0400
Content-Disposition: inline
In-Reply-To: <20120611190108.GF16086@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 11-06-12 15:01:08, Ted Tso wrote:
> On Mon, Jun 11, 2012 at 06:41:30PM +0300, Boaz Harrosh wrote:
> > 
> > My point being that please any changes made to ext2, in this area please also
> > apply to exofs, since it is just another copy/paste of ext2. I'll ACK any
> > which way you guys decide to properly go with, as part of the VFS changes.
> 
> Well, I already have this quick and dirty fix to address the problem
> in ext4.  See commit 7e936b7372.  If we need to make changes to all of
> the file systems to accomodate some new VFS abstraction, it might be
> worth considering whether it's easier/simpler to just put in a quick
> check like I did for ext4 (just so I could plug the security hole[1]
> quickly).
> 
> [1] It's a denial of service attack for kiosks that do automounts of
> USB sticks; granted, it's not that big a of a security deal, but some
> people care about such things.
> 
> Of course, if the new/changed VFS abstraction solves other problems,
> that's cool, but if not, sometimes a simple brute force check is
> better than something complicated if elegant.  :-)
  I think that fix in ext4 is fine. Just you don't catch the situation when
the directory entry points e.g. to a parent and that's deadlockable
trivially as well. Even if it points to some unrelated directory, you can
easily deadlock rename which tries to lock both directories. So I attempted
for a fix in VFS because that's the only place having enough information to
be able to tell whether you are creating directory hardlink or not.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
