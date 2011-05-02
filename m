From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Mon, 2 May 2011 16:20:55 +0200
Message-ID: <20110502142055.GF4556@quack.suse.cz>
References: <20110406054005.GD31057@dastard>
 <20110406061856.GC23285@quack.suse.cz>
 <20110406112135.GE31057@dastard>
 <4DBE746F.3090707@ubuntu.com>
 <20110502105629.GA4556@quack.suse.cz>
 <4DBE9537.4050708@ubuntu.com>
 <20110502122055.GB5855@quack.suse.cz>
 <4DBEA3DF.1060306@ubuntu.com>
 <20110502131619.GC5855@quack.suse.cz>
 <20110502132204.GA7708@infradead.org>
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
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110502132204.GA7708@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 02-05-11 09:22:04, Christoph Hellwig wrote:
> On Mon, May 02, 2011 at 03:16:19PM +0200, Jan Kara wrote:
> > Dave, Christoph, any opinions on this?
> 
> The busyloop in xfs_quiesce_attr which waits for all active transactions
> to finish is supposed to fix this issue.
  Hmm, but what prevents the following race?

  Thread 1					Thread 2
..
xfs_trans_alloc()
  xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
						freeze_super()
						  ...
						  xfs_fs_freeze()
						    ...
						    xfs_quiesce_attr()
						    ...
  _xfs_trans_alloc()
    atomic_inc(&mp->m_active_trans);
    ... goes on modifying the filesystem

  It seems to be a similar problem as in ext4 - the atomic_inc() and
vfs_check_frozen() are in the wrong order...

> Note that XFS traditionally expects a two stage freeze process where
> we first freeze new VFS-level writes, then flush the caches and then
> stop transactions, wait for them to finish and do the remainder of
> the freeze process, but I really messed that process up when moving
> the sequence to generic code.  Funnily enough it seems to work
> neverless.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
