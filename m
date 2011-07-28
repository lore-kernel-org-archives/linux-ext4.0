From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] dumpe2fs: Warn when filesystem is mounted read-write
Date: Thu, 28 Jul 2011 21:51:31 +0200
Message-ID: <20110728195131.GH5044@quack.suse.cz>
References: <1311866224-27351-1-git-send-email-jack@suse.cz>
 <1968AC77-D564-47DB-8D15-5F5FBB75B08B@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57882 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565Ab1G1Tve (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Jul 2011 15:51:34 -0400
Content-Disposition: inline
In-Reply-To: <1968AC77-D564-47DB-8D15-5F5FBB75B08B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 28-07-11 10:44:30, Andreas Dilger wrote:
> On 2011-07-28, at 9:17 AM, Jan Kara <jack@suse.cz> wrote:
> > When dumpe2fs is used on a filesystem mounted read-write, printed information
> > may be old and inconsistent because e.g. updates of some superblock fields
> > happen lazily or because we do not really try to handle various intermediate
> > states of filesystem operations. Document this in the manpage and warn user
> > when dumpe2fs is used for such filesystem.
> 
> Jan, does this specifically relate to the free blocks or free inodes
> count?  My preference would actually be to have dumpe2fs print the
> correct values. I guess that means reading all of the group descriptors
> and adding up the free block/inode counts like the kernel does. 
  Yes, the number of free blocks and inodes are the main offenders,
although there are other fields like s_wtime, or s_kbytes_written that are
updated only during umount.

> I'm not against this patch in principle, since any operation on a mounted
> filesystem is inherently racy, but as it stands now the information
> printed by dumpe2fs can be completely useless. 
  Well, but OTOH in some cases it might be desirable to actually see the
real numbers stored and since dumpe2fs is mainly for debugging purposes I'd
rather have it's output as close to what's on disk as possible. If people
are interested in amount of free blocks / inodes, they should use statfs(2)
after all.  So I'd be reluctant to add some computations like you
suggest... What dumpe2fs might do is sync the filesystem (and do statfs())
to force most of the information to disk when it sees the filesystem is
mounted. I can update my patch to do this when people think it's desirable.
  
									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
