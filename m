From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/7] ext4: fsync should wait for DIO writers
Date: Wed, 12 Sep 2012 16:02:18 +0200
Message-ID: <20120912140218.GC5726@quack.suse.cz>
References: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org>
 <1347211634-11509-5-git-send-email-dmonakhov@openvz.org>
 <20120910095135.GF22903@quack.suse.cz>
 <87bohegn97.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, tytso@mit.edu,
	wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48556 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851Ab2ILOCX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Sep 2012 10:02:23 -0400
Content-Disposition: inline
In-Reply-To: <87bohegn97.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 10-09-12 14:56:04, Dmitry Monakhov wrote:
> On Mon, 10 Sep 2012 11:51:35 +0200, Jan Kara <jack@suse.cz> wrote:
> > > Even more i_mutex is not holded while punch_hole which obviously
> > > result in dangerous data corruption due to write-after-free.
> >   Yes, that's a bug. I also noticed that but didn't get to fixing it (I'm
> > actually working on a more long term fix using range locking but that's
> > more of a research project so having somehow fixed at least the most
> > blatant locking problems is good).
> Yes you right. In order to do things right we should block:
> 1) direct io
> 2) pagecache /mmap users (writeback, readpage)
> 
> A assumes I've fixed (1) but (2) is still exist
> 
> My current assumption is to do actions similar to writeback
> 
>    down_write(EXT4_I(inode)->i_data_sem)
>    while (index <= end && pagevec_lookup(&pvec, mapping, index,...) {
>         lock_page(pvec[i]);
  Here you need to use trylock to avoid possible deadlocks...

>         zero_user_page(pvec[i], 0, PAGE_SIZE);
>         ret = try_to_release_page(pvec[i]);
>    }
>    /* At this moment we know that we locked all pages in range,
>     * NOTE!!!! currently ext_remove_space may drop i_data_sem internally
>     * so it should be modified to exit once i_mutex was dropped
>    */
>    ret = ext4_ext_remove_space(inode, from, to, NO_RELOCK)
>    while (pvec_num)
>          unlock_page(pvec[i])
>    }
>    up_write(EXT4_I(inode)->i_data_sem)
> 
> Number of locked pages should not be too large
> Or even more instead of massive page locking, we can lock page
> one by one, and simulate fake writeback, so all new writers will
> wait on that bit, but readers will see zeroes.
>    down_write(EXT4_I(inode)->i_data_sem)
>    while (index <= end && pagevec_lookup(&pvec, mapping, index,...) {
>         lock_page(pvec[i]);
>         zero_user_page(pvec[i], 0, PAGE_SIZE);
>         ret = try_to_release_page(pvec[i]);
>         set_page_writeback(pvec[i]);
>         unlock_page(pvec[i])
>    }
>    
>    ret = ext4_ext_remove_space(inode, from, to, NO_RELOCK)
>    while (pvec_num) {
>          end_page_writeback(pvec[i])
>    }
>    up_write(EXT4_I(inode)->i_data_sem)
  Oh, that's a hack. Please don't do that. Using page locks is cleaner
although I agree it's not very good either. That's why I decided not to
loose time with suboptimal solutions and rather look into range locking...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
