From: Jan Kara <jack@suse.cz>
Subject: Re: WARNING: at fs/ext4/inode.c:230 ext4_evict_inode+0x41b/0x510
Date: Tue, 9 Jul 2013 10:39:36 +0200
Message-ID: <20130709083936.GB21060@quack.suse.cz>
References: <20130708183829.GA3205@roeck-us.net>
 <20130709033510.GE6000@thunk.org>
 <20130709040658.GA7763@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>
To: Guenter Roeck <linux@roeck-us.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34115 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485Ab3GIIjl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jul 2013 04:39:41 -0400
Content-Disposition: inline
In-Reply-To: <20130709040658.GA7763@roeck-us.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 08-07-13 21:06:58, Guenter Roeck wrote:
> On Mon, Jul 08, 2013 at 11:35:10PM -0400, Theodore Ts'o wrote:
> > On Mon, Jul 08, 2013 at 11:38:29AM -0700, Guenter Roeck wrote:
> > > Hi,
> > > 
> > > seen this morning with a brand new top-of-tree kernel (as of last night) plus a
> > > couple of patches I am working on.
> > > 
> > > Due to my changes, there is a slight chance that the problem is not due to an
> > > upstream bug, but I think that is quite unlikely (my changes are unrelated
> > > to file system code).
> > > 
> > > If there is anything I can help to track this down, please let me know.
> > > 
> > > [13071.291013] ------------[ cut here ]------------
> > > [13071.291021] WARNING: at fs/ext4/inode.c:230 ext4_evict_inode+0x41b/0x510()
> > 
> > Hmm, this warning was added by commit 5dc23bdd5: ext4: remove
> > ext4_ioend_wait().
> > 
> > What sort of work load are you running on this machine?  Do you know
> > what might have triggered it?
> > 
> My nightly kernel builds were running at the time. This is a sequence of git
> clone/checkout operations followed by builds for several targets.
> 
> I have the same kernel running on three systems, but this only happened on the
> build machine, and I have not seen it again during the day.
> 
> I'll let you know if it happens again tonight.
  Thanks for report. I think I see what's going on. I think we completed
bio directly in ext4_end_bio() (as it didn't need unwritten conversion) but
io_end is released only a bit later which can race with ext4_evict_inode()
as:
	CPU1					CPU2
ext4_end_bio()				ext4_evict_inode()
  ext4_finish_bio()
    end_page_writeback();
					  truncate_inode_pages()
					    evict page
					WARN_ON(i_ioend_count > 0);
  ext4_put_io_end_defer()			
    ext4_release_io_end()
      dec i_ioend_count

This seems harmless. I'll see if I can easily fix this to make the warning
still useful. If not, I'll just rip out i_ioend_count completely as it's
there only as a sanity check until the new code settles down...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
