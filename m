From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2: do not register write_super within VFS
Date: Wed, 11 Apr 2012 17:30:54 +0200
Message-ID: <20120411153054.GA16008@quack.suse.cz>
References: <1333446558-28171-1-git-send-email-dedekind1@gmail.com>
 <20120403223632.GA5288@quack.suse.cz>
 <1334143474.13842.0.camel@sauron.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42129 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754626Ab2DKPbB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Apr 2012 11:31:01 -0400
Content-Disposition: inline
In-Reply-To: <1334143474.13842.0.camel@sauron.fi.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 11-04-12 14:24:34, Artem Bityutskiy wrote:
> On Wed, 2012-04-04 at 00:36 +0200, Jan Kara wrote:
> > On Tue 03-04-12 12:49:18, Artem Bityutskiy wrote:
> > > From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> > > 
> > > Jan Kara removed 'sb->s_dirt' VFS flag references, so we do not need to
> > > register the ext2 'ext2_write_super()' method in the VFS superblock operations,
> > > because 'sb->s_dirt' won't be ever set to 1 and VFS won't ever call
> > > '->write_super()' anyway. Thus, remove the method.
> > > 
> > > Tested using xfstests.
> > > 
> > > Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> >   Thanks. Added to my tree.
> 
> Jan, I do not see this patch in 'for_next' of your tree.
  Yeah, it's not. So far it was in my for_next_testing and for_testing
branches. Once the branch (for_testing) passes some compile tests (done)
and runtime tests with xfstests I will update for_next branch to include
the patch as well. Because merge window is far, I don't hurry with that
very much. But if it causes problems for you I can run the tests and update
for_next tonight or tomorrow.
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
