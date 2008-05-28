From: Jan Kara <jack@suse.cz>
Subject: Re: Delayed allocation and page_lock vs transaction start ordering
Date: Wed, 28 May 2008 11:33:24 +0200
Message-ID: <20080528093323.GB8289@duck.suse.cz>
References: <20080415161430.GC28699@duck.suse.cz> <20080521082109.GA18746@skywalker> <20080526172124.GK32407@duck.suse.cz> <20080526180043.GB14718@skywalker> <20080527124312.GG5178@duck.suse.cz> <20080527151128.GA13237@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:55142 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751390AbYE1JdZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 May 2008 05:33:25 -0400
Content-Disposition: inline
In-Reply-To: <20080527151128.GA13237@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 27-05-08 20:41:28, Aneesh Kumar K.V wrote:
> On Tue, May 27, 2008 at 02:43:12PM +0200, Jan Kara wrote:
> > On Mon 26-05-08 23:30:43, Aneesh Kumar K.V wrote:
> > 
> > > I have got another question now related to page_mkwrite. AFAIU writepage
> > > writeout dirty buffer_heads. It also looks at whether the pages are
> > > dirty or not. In the page_mkwrite callback both are not true. ie we call
> > > set_page_dirty from do_wp_page after calling page_mkwrite. I haven't
> > > verified whether the above is correct or not. Just thinking reading the
> > > code.
> >   Writepage call itself doesn't look at whether the page is dirty or not -
> > that flag is already cleared when writepage is called. You are right that
> > the page is marked dirty only after page_mkwrite is called - the meaning of
> > page_mkwrite() call is roughly "someone wants to do the first write to this
> > page via mmap, prepare filesystem for that". But we don't really care
> > whether the page is dirty or not - we know it carries correct data (it is
> > uptodate) and so we can write it if we want (and need).
> > 
> 
> I am looking at  __block_write_full_page and we have
> 
> if (!buffer_mapped(bh) && buffer_dirty(bh)) {
> 	WARN_ON(bh->b_size != blocksize);
> 	err = get_block(inode, block, bh, 1);
> 	if (err)
> 
> ie, we do get_block only if the buffer_head is dirty. So I am bit
> doubtful whether we are actually allocating blocks via page_mkwrite.
  Good catch, we should mark unmapped buffers dirty before calling writepage.
Actually, if the page didn't have any buffers, block_write_full_page() will
create them all dirty so that's probably why I didn't hit it in my testing
but it's definitely safer to mark them dirty explicitely. Thanks.
  It is enough to change ext4_bh_mapped() to something like:
static int ext4_bh_prepare_fill(handle_t *handle, struct buffer_head *bh)
{
	if (!buffer_mapped(bh)) {
		/*
		 * Mark buffer as dirty so that block_write_full_page()
		 * writes it
		 */
		set_buffer_dirty(bh);
		return 1;
	}
	return 0;
}

  Should I send you an updated patch with this change and the changes we spoke
about yesterday, or just an incremental changes which you will fold yourself
into the big one?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
