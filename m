From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext3: Don't update ctime in ext3_splice_branch()
Date: Wed, 1 Feb 2012 11:46:33 +0100
Message-ID: <20120201104633.GA16714@quack.suse.cz>
References: <4F2657BD.8030208@sx.jp.nec.com>
 <20120130175217.GA7827@quack.suse.cz>
 <4F28F021.8030904@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55657 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845Ab2BAKqg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Feb 2012 05:46:36 -0500
Content-Disposition: inline
In-Reply-To: <4F28F021.8030904@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 01-02-12 16:56:17, Kazuya Mio wrote:
> 2012/01/31 2:52, Jan Kara wrote:
> >  Thanks for the patches.  This is true for ordinary writes but not true
> >when you write via mmap. We call file_update_time() during page fault so
> >ctime won't be completely wrong but still we should update it after block
> >is allocated during writeback to reflect that new block is allocated to
> >the inode.
> 
> Should we update ctime whenever a block is allocated?
  Since ctime should be updated whenever inode is changed, and allocating
block updates i_blocks (via dquot_alloc_block()), we should update ctime.

> If so, ordinary write in ext4 with indirect block mapping has the same problem
> due to the following patch, right?
> http://marc.info/?l=linux-ext4&m=124505184027078&w=4
  It's kind of the same problem. But things are more complicated by the
fact that ext4 also does delayed allocation so, as changelog of the patch
you reference says, it's kind of unexpected from users to see ctime
suddently update when VM decides to do writeout triggering block
allocation. I'd think updating ctime is a correct (although unexpected)
thing to do but I can understand Ted's position as well and he's ext4
maintainer :).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
