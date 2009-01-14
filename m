From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2: Update also inode on disk when dir is IS_DIRSYNC
Date: Wed, 14 Jan 2009 16:12:34 +0100
Message-ID: <20090114151234.GG19950@duck.suse.cz>
References: <1231850522-11074-1-git-send-email-jack@suse.cz> <20090113151716.cefb738b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, pavel@suse.cz
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:56996 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758818AbZANPMg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Jan 2009 10:12:36 -0500
Content-Disposition: inline
In-Reply-To: <20090113151716.cefb738b.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 13-01-09 15:17:16, Andrew Morton wrote:
> On Tue, 13 Jan 2009 13:42:02 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
> > We used to just write changed page for IS_DIRSYNC inodes. But we also have to
> > update directory inode itself just for the case that we've allocated a new
> > block and changed i_size.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > CC: Pavel Machek <pavel@suse.cz>
> > ---
> >  fs/ext2/dir.c |    5 ++---
> >  1 files changed, 2 insertions(+), 3 deletions(-)
> > 
> >   Andrew, would you please merge the patch? Ext3 and ext4 don't have this
> > problem BTW.
> > 
> > diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
> > index 9a0fc40..7fba549 100644
> > --- a/fs/ext2/dir.c
> > +++ b/fs/ext2/dir.c
> > @@ -94,11 +94,10 @@ static int ext2_commit_chunk(struct page *page, loff_t pos, unsigned len)
> >  		i_size_write(dir, pos+len);
> >  		mark_inode_dirty(dir);
> >  	}
> > +	unlock_page(page);
> >  
> >  	if (IS_DIRSYNC(dir))
> > -		err = write_one_page(page, 1);
> > -	else
> > -		unlock_page(page);
> > +		err = ext2_sync_inode(dir);
> >  
> 
> But with this change we no longer sync the data page?  Don't we need
> something like this:
  Oh, correct, we do. I was confused by sync_inode() calling fdatawrite()
but did not realize that the way ext2_sync_inode() calls it has start ==
end == 0. Thanks for spotting this.

> static int ext2_commit_chunk(struct page *page, loff_t pos, unsigned len)
> {
> 	struct address_space *mapping = page->mapping;
> 	struct inode *dir = mapping->host;
> 	int err = 0;
> 
> 	dir->i_version++;
> 	block_write_end(NULL, mapping, pos, len, len, page, NULL);
> 
> 	if (pos+len > dir->i_size) {
> 		i_size_write(dir, pos+len);
> 		mark_inode_dirty(dir);
> 	}
> 
> 	if (IS_DIRSYNC(dir)) {
> 		err = write_one_page(page, 1);
> 		if (err == 0)
> 			err = ext2_sync_inode(dir);
> 	} else {
> 		unlock_page(page);
> 	}
> 
> 	return err;
> }
> 
> ?
  Yes, I'll send you a new version of the patch and also send refreshed
second patch with blkdev_issue_flush() calls.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
