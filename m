From: Jan Kara <jack@suse.cz>
Subject: Re: EXT4-fs (dm-1): Couldn't remount RDWR because of unprocessed
 orphan inode list
Date: Thu, 8 Sep 2011 20:51:39 +0200
Message-ID: <20110908185139.GA2393@quack.suse.cz>
References: <alpine.DEB.2.01.1109021346290.9183@trent.utfs.org>
 <4E66478E.90102@redhat.com>
 <alpine.DEB.2.01.1109060923340.9183@trent.utfs.org>
 <4E664DFD.80308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christian Kujau <lists@nerdbynature.de>,
	linux-ext4@vger.kernel.org, mszeredi@suse.cz,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43999 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933495Ab1IJUdp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Sep 2011 16:33:45 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 977DB89471
	for <linux-ext4@vger.kernel.org>; Sat, 10 Sep 2011 22:33:44 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <4E664DFD.80308@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 06-09-11 11:44:45, Eric Sandeen wrote:
> On 9/6/11 11:37 AM, Christian Kujau wrote:
> > On Tue, 6 Sep 2011 at 11:17, Eric Sandeen wrote:
> >> It's probably not a bug or flaw; orphan inodes can occur for legitimate
> >> reasons (fs goes down while someone is holding open an unlinked file),
> > 
> > The filesystem is being constantly accessed by an application, holding at 
> > least one file open (readonly). And then there is this mechanism trying to 
> > remount the filesystem rw and then ro again every day. I guess this equals
> > the scenario of "fs goes down (remount!) while someone is holding open a 
> > file"?
> 
> well, no - "goes down" means "crashed or lost power"
> 
> >> Did you happen to also get a message like this on the original mount?
> >>                 ext4_msg(sb, KERN_ERR, "write access "
> >>                         "unavailable, skipping orphan cleanup");
> > 
> > I think I've seen this message before, but I'm nore sure where and it's 
> > not in the logs of this particular system.
> > 
> >> See also commit: 
> >>
> >> commit ead6596b9e776ac32d82f7d1931d7638e6d4a7bd
> >> Author: Eric Sandeen <sandeen@redhat.com>
> >> Date:   Sat Feb 10 01:46:08 2007 -0800
> >>
> >>     [PATCH] ext4: refuse ro to rw remount of fs with orphan inodes
> > 
> > Yes, I've seen this commit when I was searching where this message came
> > from. And I think I understand now why this is happening, but 
> > still...if I may ask: can't this be handled more elegantly? Do other 
> > filesystems have the same problem?
> 
> well, as the commit said, it'd be nice to handle it in remount, yes... :(
> 
> > Right now the procedure is to pause the application, stop the nfs exports,
> > unmount, fsck, mount, start nfs exports and resume the application. And
> > every few days/weeks this has to be repeated, "just because" these daily
> > remounts occur (which are the main reason for this, I suppose).
> 
> well, seems like you need to get to the root cause of the unprocessed
> orphan inodes.
> 
> I don't yet have my post-vacation thinking cap back on... does cycling
> rw/ro/rw/ro with open & unlinked files cause an orphan inode situation?
  There's race where VFS remount code can race with unlink and result will
be unlinked file in orphan list on read-only filesystem. Christian seems to
be hitting this race. Miklos Szeredi has patches
(http://lkml.indiana.edu/hypermail/linux/kernel/1108.3/00169.html) to
mostly close this hole but they're waiting for Al to find time to look at
them / merge them AFAIK.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
