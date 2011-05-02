From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Mon, 2 May 2011 16:26:17 +0200
Message-ID: <20110502142617.GG4556@quack.suse.cz>
References: <20110406112135.GE31057@dastard>
 <4DBE746F.3090707@ubuntu.com>
 <20110502105629.GA4556@quack.suse.cz>
 <4DBE9537.4050708@ubuntu.com>
 <20110502122055.GB5855@quack.suse.cz>
 <4DBEA3DF.1060306@ubuntu.com>
 <20110502131619.GC5855@quack.suse.cz>
 <4DBEB025.90704@ubuntu.com>
 <20110502132449.GB7708@infradead.org>
 <4DBEB14B.70208@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Dave Chinner <david@fromorbit.com>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Surbhi Palande <surbhi.palande@ubuntu.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4DBEB14B.70208@ubuntu.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 02-05-11 16:27:39, Surbhi Palande wrote:
> On 05/02/2011 04:24 PM, Christoph Hellwig wrote:
> >On Mon, May 02, 2011 at 04:22:45PM +0300, Surbhi Palande wrote:
> >>This has another advantage, that it rightfully does not let you
> >>update the access time when the F.S is frozen (touch_atime called
> >>from a read path when the F.S is frozen) Otherwise we also need to
> >>fix this path.
> >In most filesystens atime updates aren't transactional.  They just
> >get written into inode->i_atime, and at some later point when the
> >VFS tries to clean the inode it gets writtent back, either through
> >a transaction or not.
> >
> Yes, agreed. But then when a F.S is frozen the inode should not be
> dirtied? Right? So this has to be fixed?
> Also, in ext4, I think that updating atime starts a transaction.
  Yes, it does. Any mark_inode_dirty() call causes a transaction update.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
