From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] ext4: Wait for proper transaction commit on fsync
Date: Tue, 20 Oct 2009 18:05:11 +0200
Message-ID: <20091020160511.GB25760@duck.suse.cz>
References: <1256023478-746-1-git-send-email-jack@suse.cz> <1256023478-746-5-git-send-email-jack@suse.cz> <20091020123131.GA30182@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, tytso@mit.edu,
	chris.mason@oracle.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38088 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbZJTQGP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Oct 2009 12:06:15 -0400
Content-Disposition: inline
In-Reply-To: <20091020123131.GA30182@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 20-10-09 18:01:31, Aneesh Kumar K.V wrote:
> On Tue, Oct 20, 2009 at 09:24:38AM +0200, Jan Kara wrote:
> > We cannot rely on buffer dirty bits during fsync because pdflush can come
> > before fsync is called and clear dirty bits without forcing a transaction
> > commit. What we do is that we track which transaction has last changed
> > the inode and which transaction last changed allocation and force it to
> > disk on fsync.
<snip>
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 10539e3..3e167f6 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -3315,6 +3315,11 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
> >  	newblock = ext_pblock(&newex);
> >  	allocated = ext4_ext_get_actual_len(&newex);
> >  	set_buffer_new(bh_result);
> > +	
> > +	atomic_set(&EXT4_I(inode)->i_sync_tid, handle->h_transaction->t_tid);
> > +	atomic_set(&EXT4_I(inode)->i_datasync_tid,
> > +		   handle->h_transaction->t_tid);
> > +	printk("Datasync tid %u\n", handle->h_transaction->t_tid);
> 
> The printk need to be removed ?
  Ah, missed that debugging aid. Will fix.

> Also i am wondering wether we need to update i_datasync_tid only if we
> allocate new blocks ? How about writing to an fallocate area. I guess
  Yes, we need to update it only if we allocate new blocks but that should
be what I've done (but maybe I screwed up...).

> we need to track the transaction in which we are marking an extent
> initialized.
  You are right that i_datasync_tid needs to be updated also when we
convert uninitialized extents to initialized ones. I'll fix this case.
Thanks for review.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
