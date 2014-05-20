From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext4: Reduce contention on s_orphan_lock
Date: Tue, 20 May 2014 23:03:54 +0200
Message-ID: <20140520210354.GB5686@quack.suse.cz>
References: <1400589949-25595-1-git-send-email-jack@suse.cz>
 <1400589949-25595-3-git-send-email-jack@suse.cz>
 <537B8693.4000904@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33124 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbaETVD5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 May 2014 17:03:57 -0400
Content-Disposition: inline
In-Reply-To: <537B8693.4000904@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 20-05-14 10:45:07, Thavatchai Makphaibulchoke wrote:
> On 05/20/2014 06:45 AM, Jan Kara wrote:
> > +	if (dirty) {
> > +		err = ext4_handle_dirty_super(handle, sb);
> > +		rc = ext4_mark_iloc_dirty(handle, inode, &iloc);
> > +		if (!err)
> > +			err = rc;
> > +		if (err) {
> > +			/*
> > +			 * We have to remove inode from in-memory list if
> > + 			 * addition to on disk orphan list failed. Stray orphan
> > +			 * list entries can cause panics at unmount time.
> > +			 */
> > +			mutex_lock(&sbi->s_orphan_lock);
> > +			list_del(&EXT4_I(inode)->i_orphan);
> > +			mutex_unlock(&sbi->s_orphan_lock);
> > +		}
> > +	}
> 
> Sorry Jan, I just noticed this.
> 
> I don't believe you could this optimization either.  Since you drop the
> s_oprhan_lock in between, you essentially have an interval where there is
> a stray in-memory orphan and could cause a panic as the comment above
> mentioned.
  No, I think we are fine in this case. I'm not sure what race you are
exactly thinking of but unmount cannot certainly happen since we have a
reference to active inode in the filesystem.
 
> As for comments regarding ext4_mark_iloc() optimization, in your case
> since you are holding the i_mutex, should not that prevent the inode from
> being reclaimed?
  Yes, that prevents the inode from being reclaimed but it doesn't prevent
the previous inode in the list from being reclaimed and we need to update
also that one...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
