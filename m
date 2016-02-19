From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix bh->b_state corruption
Date: Fri, 19 Feb 2016 00:08:24 -0500
Message-ID: <20160219050824.GB12743@thunk.org>
References: <1452185721-32477-1-git-send-email-jack@suse.cz>
 <20160218160948.GA23044@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nikolay Borisov <kernel@kyup.com>, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.com>, stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160218160948.GA23044@quack.suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Feb 18, 2016 at 05:09:48PM +0100, Jan Kara wrote:
> On Thu 07-01-16 17:55:21, Jan Kara wrote:
> > From: Jan Kara <jack@suse.com>
> > 
> > ext4 can update bh->b_state non-atomically in _ext4_get_block() and
> > ext4_da_get_block_prep(). Usually this is fine since bh is just a
> > temporary storage for mapping information on stack but in some cases it
> > can be fully living bh attached to a page. In such case non-atomic
> > update of bh->b_state can race with an atomic update which then gets
> > lost. Usually when we are mapping bh and thus updating bh->b_state
> > non-atomically, nobody else touches the bh and so things work out fine
> > but there is one case to especially worry about: ext4_finish_bio() uses
> > BH_Uptodate_Lock on the first bh in the page to synchronize handling of
> > PageWriteback state. So when blocksize < pagesize, we can be atomically
> > modifying bh->b_state of a buffer that actually isn't under IO and thus
> > can race e.g. with delalloc trying to map that buffer. The result is
> > that we can mistakenly set / clear BH_Uptodate_Lock bit resulting in the
> > corruption of PageWriteback state or missed unlock of BH_Uptodate_Lock.
> > 
> > Fix the problem by always updating bh->b_state bits atomically.
> > 
> > CC: stable@vger.kernel.org
> > Reported-by: Nikolay Borisov <kernel@kyup.com>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Ping Ted? This seems to have fallen through the cracks?

Oops, sorry.  Thanks, applied.

						- Ted
