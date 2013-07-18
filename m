From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: block direct I/O writes during ext4_truncate
Date: Thu, 18 Jul 2013 16:11:17 +0200
Message-ID: <20130718141117.GB10419@quack.suse.cz>
References: <1373861479-15136-1-git-send-email-tytso@mit.edu>
 <20130716154658.GE25632@quack.suse.cz>
 <20130716164942.GA6002@thunk.org>
 <20130717182709.GB26859@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130717182709.GB26859@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 17-07-13 14:27:10, Ted Tso wrote:
> On Tue, Jul 16, 2013 at 12:49:42PM -0400, Theodore Ts'o wrote:
> > On Tue, Jul 16, 2013 at 05:46:58PM +0200, Jan Kara wrote:
> > > and ext4_setattr() does (again under i_mutex):
> > >                                         ext4_inode_block_unlocked_dio(inode);
> > >                                         inode_dio_wait(inode);
> > >                                         ext4_inode_resume_unlocked_dio(inode);
> > 
> > Ah, I missed this; thanks for pointing this out.
> 
> I took a closer look, and there are other code paths which call
> ext4_truncate() which don't call ext4_inode_block_unlocked_dio() and
> inode_dio_wait().  In particular, the orphan cleanup code and the
> SETFLAGS ioctl.
  True although both should be harmless. Also you have
ext4_truncate_failed_write() which is harmless as well.

> I suspect the right answer is to move these these calls, and possibly
> also the truncate_pagecache() call.
  Could be.

> The other thing that we probably will want to do as a cleanup for the
> next merge window is to look at merging more of the code paths for
> ext4_punch_hole() and ext4_truncate().
  Yeah, that would be definitely worthwhile effort.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
