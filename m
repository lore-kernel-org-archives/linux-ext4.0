From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Mon, 2 May 2011 18:23:34 +0200
Message-ID: <20110502162334.GJ4556@quack.suse.cz>
References: <20110406112135.GE31057@dastard>
 <4DBE746F.3090707@ubuntu.com>
 <20110502105629.GA4556@quack.suse.cz>
 <4DBE9537.4050708@ubuntu.com>
 <20110502122055.GB5855@quack.suse.cz>
 <4DBEA3DF.1060306@ubuntu.com>
 <20110502131619.GC5855@quack.suse.cz>
 <20110502132204.GA7708@infradead.org>
 <20110502142055.GF4556@quack.suse.cz>
 <20110502144155.GA8045@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Surbhi Palande <surbhi.palande@ubuntu.com>,
	Dave Chinner <david@fromorbit.com>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53476 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944Ab1EBQXh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 May 2011 12:23:37 -0400
Content-Disposition: inline
In-Reply-To: <20110502144155.GA8045@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 02-05-11 10:41:55, Christoph Hellwig wrote:
> On Mon, May 02, 2011 at 04:20:55PM +0200, Jan Kara wrote:
> >   Hmm, but what prevents the following race?
> > 
> >   Thread 1					Thread 2
> > ..
> > xfs_trans_alloc()
> >   xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
> > 						freeze_super()
> 
>                                                   sb->s_frozen = SB_FREEZE_TRANS;
> > 						  ...
> > 						  xfs_fs_freeze()
> > 						    ...
> > 						    xfs_quiesce_attr()
> 
> 						      waits for all active
> 						      transactions
> 
> > 						    ...
> 
>    xfs_trans_alloc
>      -> blocks in xfs_wait_for_freeze
  But why should it block when xfs_wait_for_freeze() gets called before
freeze_super() gets called? The other thread calls freeze_super() just
after xfs_wait_for_freeze() in thread 1 and before _xfs_trans_alloc() gets
called.  Or am I missing some serialization somewhere?

>      (thus doesn't get to _xfs_trans_alloc)
> 
> >   _xfs_trans_alloc()
> >     atomic_inc(&mp->m_active_trans);
> >     ... goes on modifying the filesystem
> > 
> >   It seems to be a similar problem as in ext4 - the atomic_inc() and
> > vfs_check_frozen() are in the wrong order...
> 
> I can't see the problem in this scheme.  Note that we want
> _xfs_trans_alloc to be able to create a transaction for
> xfs_fs_log_dummy, so that we can write the dummy log record after
> freezing out all other transactions, so that one is special cased
> and doesn't do the xfs_wait_for_freeze.
  OK.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
