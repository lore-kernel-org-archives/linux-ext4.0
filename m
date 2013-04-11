From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Fix data corruption with direct IO read in
 dioread_nolock mode
Date: Thu, 11 Apr 2013 23:07:56 +0200
Message-ID: <20130411210756.GC9379@quack.suse.cz>
References: <1365438463-23025-1-git-send-email-jack@suse.cz>
 <20130411132036.GA3448@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756816Ab3DKVH6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Apr 2013 17:07:58 -0400
Content-Disposition: inline
In-Reply-To: <20130411132036.GA3448@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 11-04-13 21:20:36, Zheng Liu wrote:
> On Mon, Apr 08, 2013 at 06:27:43PM +0200, Jan Kara wrote:
> > When ext4 is mounted in dioread_nolock mode, it calls
> > __blockdev_direct_IO() without DIO_LOCKING flag which also means mapping
> > is not synced before direct IO starts. As a result consistency between
> > buffered writes and following direct IO reads is broken. More
> > importantly, if the file is truncated, and extented back, zeroing of the
> > tail page is not visible to the following direct IO read which will return
> > stale data.
> > 
> > Fix the problem by flushing dirty pages before issuing direct IO read.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext4/indirect.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> > index b505a14..c18bf1c 100644
> > --- a/fs/ext4/indirect.c
> > +++ b/fs/ext4/indirect.c
> > @@ -809,6 +809,10 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
> >  
> >  retry:
> >  	if (rw == READ && ext4_should_dioread_nolock(inode)) {
> > +		ret = filemap_write_and_wait_range(inode->i_mapping, offset,
> > +						   offset + count - 1);
> > +		if (ret)
> > +			goto out;
> >  		if (unlikely(atomic_read(&EXT4_I(inode)->i_unwritten))) {
> >  			mutex_lock(&inode->i_mutex);
> >  			ext4_flush_unwritten_io(inode);
> 
> Hi Jan,
> 
> Sorry for the late reply.  I have a question about this patch.  In your
> patch, we flush dirty pages befoer issuing a dio read.  But we have
> flushed dirty pages in generic_file_aio_read().  So is it really
> necessary to flush dirty pages again?
  Doh, you are right. I didn't notice that. Thanks for correcting me. I was
seeing a failure in xfstest 091 (fsx using direct IO) with dioread_nolock
and I thought the missing flush was the culprit (as fsx saw non-zeros in
the tail of the page that was truncated). After adding the flush I didn't
see it anymore. But now I'm not able to trigger the failure again
regardless whether the patch is applied or not. So Ted, please drop the
patch and I'll watch out if I ever see the failure again.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
