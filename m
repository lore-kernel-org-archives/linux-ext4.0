From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fs/ext{3,4}: fix potential race when setversion ioctl
 updates inode
Date: Thu, 5 Jan 2012 12:42:05 +0100
Message-ID: <20120105114205.GB14947@quack.suse.cz>
References: <20120103013152.GA26455@dztty>
 <20120104174609.GD28907@quack.suse.cz>
 <6C16105A-D0EE-413E-B993-F223CFC75307@dilger.ca>
 <20120104233254.GH28907@quack.suse.cz>
 <20120105003751.GA4010@dztty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
To: Djalal Harouni <tixxdz@opendz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47851 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755739Ab2AELmK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Jan 2012 06:42:10 -0500
Content-Disposition: inline
In-Reply-To: <20120105003751.GA4010@dztty>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 05-01-12 01:40:09, Djalal Harouni wrote:
> On Thu, Jan 05, 2012 at 12:32:54AM +0100, Jan Kara wrote:
> > > With the metadata checksum feature we were discussing using the inode
> > > generation as part of the seed for the directory leaf block checksum, so
> > > that it wasn't possible to incorrectly access stale directory blocks from
> > > a previous incarnation of the same inode number.
> > > 
> > > We were discussing just disabling this ioctl on filesystems with metadata
> > > checksums, and printing a deprecation warning for filesystems without that
> > > feature enabled.  I'm not aware of any real-world use for this ioctl, since
> > > NFS cannot use it to reconstruct handles because there's no API to allocate
> > > an inode with a specific number, so setting the generation is pointless.
> >   OK, I didn't know this. I'm fine with deprecating the ioctl if it's
> > useless but since that's going to take a while I think the cleanup still
> > makes some sense.
> Actually I've grepped this ioctl but did not found use cases, but as
> ext{3,2} also support it, I did not say anything (this is old, there is
> even the EXT4_IOC_SETVERSION_OLD ioctl ?). I don't know if this ioctl is
> used or not.
> 
> Only the reiserfs and ext{2,3,4} filesystems support this ioctl. The reiserfs
> do not use mutexes at all, even in the REISERFS_IOC_SETFLAGS ioctl which will
> test and set _all_ the possible values of the i_flags field.
> Perhaps I should also send a patch for this ?
  Yes, possibly reiserfs should use i_mutex for that ioctl.

> And perhaps ext2 should also be updated.
  Sure. Send a patch my way when you have it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
