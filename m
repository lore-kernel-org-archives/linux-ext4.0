From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/4] fs: Improve filesystem freezing handling
Date: Thu, 12 Jan 2012 21:07:53 +0100
Message-ID: <20120112200753.GC8778@quack.suse.cz>
References: <1326331253-6497-1-git-send-email-jack@suse.cz>
 <1326331253-6497-2-git-send-email-jack@suse.cz>
 <DB1320A4-7621-44D2-B339-78CB38FAC186@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <dchinner@redhat.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Christoph Hellwig <hch@infradead.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104Ab2ALUHz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jan 2012 15:07:55 -0500
Content-Disposition: inline
In-Reply-To: <DB1320A4-7621-44D2-B339-78CB38FAC186@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 12-01-12 12:53:35, Andreas Dilger wrote:
> On 2012-01-11, at 6:20 PM, Jan Kara wrote:
> > /**
> > + * sb_start_write - drop write access to a superblock
> > + * @sb: the super we wrote to
> > + *
> > + * Decrement number of writers to the filesystem and wake up possible
> > + * waiters wanting to freeze the filesystem.
> > + */
> > +void sb_end_write(struct super_block *sb)
> > +{
> > +#ifdef CONFIG_SMP
> > +	this_cpu_dec(sb->s_writers);
> > +#else
> > +	preempt_disable();
> > +	sb->s_writers--;
> > +	preempt_enable();
> > +#endif
> > +	/*
> > +	 * Make sure s_writers are updated before we wake up waiters in
> > +	 * freeze_super().
> > +	 */
> > +	smp_mb();
> > +	if (waitqueue_active(&sb->s_writers_wait))
> > +		wake_up(&sb->s_writers_wait);
> > +	rwsem_release(&sb->s_writers_lock_map, 1, _RET_IP_);
> > +}
> 
> Since this function is needed for calling __block_page_mkwrite(), which is
> EXPORT_SYMBOL(), both sb_start_write() and sb_end_write() themselves need
> to be EXPORT_SYMBOL().
  Good point. Fixed. Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
