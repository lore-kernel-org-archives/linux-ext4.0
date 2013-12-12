From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] ext4: Retry allocation when inline->extent
 conversion failed
Date: Thu, 12 Dec 2013 10:39:36 +0100
Message-ID: <20131212093936.GA1886@quack.suse.cz>
References: <1386670440-3158-1-git-send-email-jack@suse.cz>
 <1386670440-3158-2-git-send-email-jack@suse.cz>
 <20131212064422.GA16199@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	Akira Fujita <a-fujita@rs.jp.nec.com>,
	linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52794 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab3LLJjl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 04:39:41 -0500
Content-Disposition: inline
In-Reply-To: <20131212064422.GA16199@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 12-12-13 14:44:22, Zheng Liu wrote:
> Hi Jan,
> 
> On Tue, Dec 10, 2013 at 11:13:58AM +0100, Jan Kara wrote:
> > Similarly as other ->write_begin functions in ext4, also
> > ext4_da_write_inline_data_begin() should retry allocation if the
> > conversion failed because of ENOSPC. This avoids returning ENOSPC
> > prematurely because of uncommitted block deletions.
> 
> I don't see why we need to try again here.  If there is no enough space
> in inline data, ext4_da_convert_inline_data_to_extent() just read the
> inline data into a page and clear EXT4_STATE_MAY_INLINE_DATA flag.  If
> we try again, we will encounter an ENOSPC error again.  So why do we
> need to retry allocation?
  Umm, I don't think so. ext4_da_convert_inline_data_to_extent() calls
ext4_da_get_block_prep() and that can falsely fail with ENOSPC if there are
blocks freed in currently running transaction. So we call
ext4_should_retry_alloc() which forces commit of the current transaction
and then we retry the allocation.

								Honza

> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext4/inline.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> > index bae987549dc3..ed6e71fe5e9d 100644
> > --- a/fs/ext4/inline.c
> > +++ b/fs/ext4/inline.c
> > @@ -849,11 +849,13 @@ int ext4_da_write_inline_data_begin(struct address_space *mapping,
> >  	handle_t *handle;
> >  	struct page *page;
> >  	struct ext4_iloc iloc;
> > +	int retries;
> >  
> >  	ret = ext4_get_inode_loc(inode, &iloc);
> >  	if (ret)
> >  		return ret;
> >  
> > +retry_journal:
> >  	handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
> >  	if (IS_ERR(handle)) {
> >  		ret = PTR_ERR(handle);
> > @@ -875,6 +877,11 @@ int ext4_da_write_inline_data_begin(struct address_space *mapping,
> >  							    inode,
> >  							    flags,
> >  							    fsdata);
> > +		ext4_journal_stop(handle);
> > +		handle = NULL;
> > +		if (ret == -ENOSPC &&
> > +		    ext4_should_retry_alloc(inode->i_sb, &retries))
> > +			goto retry_journal;
> >  		goto out;
> >  	}
> >  
> > -- 
> > 1.8.1.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
