From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] Rewrite ext4_page_mkwrite, fix fs freezing
Date: Wed, 11 May 2011 19:03:17 +0200
Message-ID: <20110511170317.GM5057@quack.suse.cz>
References: <1305066574-1573-1-git-send-email-jack@suse.cz>
 <20110511003012.GC6933@thunk.org>
 <20110511092752.GA5057@quack.suse.cz>
 <20110511164836.GG18929@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110511164836.GG18929@tux1.beaverton.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 11-05-11 09:48:36, Darrick J. Wong wrote:
> On Wed, May 11, 2011 at 11:27:52AM +0200, Jan Kara wrote:
> > On Tue 10-05-11 20:30:12, Ted Tso wrote:
> > > On Wed, May 11, 2011 at 12:29:31AM +0200, Jan Kara wrote:
> > > > 
> > > >   following three patches reimplement ext4_page_mkwrite() so that it returns
> > > > locked pages (which is necessary for stable pages work and also for fixing of
> > > > freezing code). As a bonus we also avoid taking i_alloc_sem as it's not
> > > > necessary and use generic block_page_mkwrite() helper. The common delalloc
> > > > path should be more straightforward now.
> > > 
> > > How does this relate to Darrick Wong's patches?  Are your patches in
> > > addition to or instead of his?
> >   It's in addition to those (although with my patches, a generic change to
> > block_page_mkwrite() would be enough for ext4). If you plan to merge those
> > now, I can rediff on top of those patches.
> 
> Just to be clear, your new __block_page_mkwrite still needs a patch to call
> wait_on_page_writeback to provide stable page writes, correct?
  Correct.

> I think we'd still need a wait_on_page_writeback for the "all buffers are
> mapped" VM_FAULT_LOCKED exit from ext4_page_mkwrite?
  Ah, right, I forgot about that one.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
