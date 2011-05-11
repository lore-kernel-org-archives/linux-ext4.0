From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] Rewrite ext4_page_mkwrite, fix fs freezing
Date: Wed, 11 May 2011 11:27:52 +0200
Message-ID: <20110511092752.GA5057@quack.suse.cz>
References: <1305066574-1573-1-git-send-email-jack@suse.cz>
 <20110511003012.GC6933@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110511003012.GC6933@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 10-05-11 20:30:12, Ted Tso wrote:
> On Wed, May 11, 2011 at 12:29:31AM +0200, Jan Kara wrote:
> > 
> >   following three patches reimplement ext4_page_mkwrite() so that it returns
> > locked pages (which is necessary for stable pages work and also for fixing of
> > freezing code). As a bonus we also avoid taking i_alloc_sem as it's not
> > necessary and use generic block_page_mkwrite() helper. The common delalloc
> > path should be more straightforward now.
> 
> How does this relate to Darrick Wong's patches?  Are your patches in
> addition to or instead of his?
  It's in addition to those (although with my patches, a generic change to
block_page_mkwrite() would be enough for ext4). If you plan to merge those
now, I can rediff on top of those patches.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
