From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/8] fs: Improve filesystem freezing handling
Date: Mon, 6 Feb 2012 16:17:45 +0100
Message-ID: <20120206151745.GD6890@quack.suse.cz>
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
 <1327091686-23177-2-git-send-email-jack@suse.cz>
 <4F2C9FF8.2010207@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Christoph Hellwig <hch@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45910 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755348Ab2BFPRs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Feb 2012 10:17:48 -0500
Content-Disposition: inline
In-Reply-To: <4F2C9FF8.2010207@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 03-02-12 21:03:20, Eric Sandeen wrote:
> On 1/20/12 2:34 PM, Jan Kara wrote:
> > vfs_check_frozen() tests are racy since the filesystem can be frozen just after
> > the test is performed. Thus in write paths we can end up marking some pages or
> > inodes dirty even though filesystem is already frozen. This creates problems
> > with flusher thread hanging on frozen filesystem.
> > 
> > Another problem is that exclusion between ->page_mkwrite() and filesystem
> > freezing has been handled by setting page dirty and then verifying s_frozen.
> > This guaranteed that either the freezing code sees the faulted page, writes it,
> > and writeprotects it again or we see s_frozen set and bail out of page fault.
> > This works to protect from page being marked writeable while filesystem
> > freezing is running but has an unpleasant artefact of leaving dirty (although
> > unmodified and writeprotected) pages on frozen filesystem resulting in similar
> > problems with flusher thread as the first problem.
> > 
> > This patch aims at providing exclusion between write paths and filesystem
> > freezing. We implement a writer-freeze read-write semaphores in the superblock
> > for each freezing level (currently there are two - SB_FREEZE_WRITE for data and
> > SB_FREEZE_TRANS for metadata). Write paths which should block freezing on given
> > level (e.g. ->block_page_mkwrite(), ->aio_write() for SB_FREEZE_WRITE level;
> > transaction lifetime for SB_FREEZE_TRANS level) hold reader side of the
> > semaphore. Code freezing the filesystem to a given level takes the writer side.
> > 
> > Only that we don't really want to bounce cachelines of the semaphore between
> > CPUs for each write happening. So we implement the reader side of the semaphore
> > as a per-cpu counter and the writer side is implemented using s_frozen
> > superblock field.
> > 
> > Acked-by: "Theodore Ts'o" <tytso@mit.edu>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> ...
> 
> > @@ -135,6 +157,11 @@ static struct super_block *alloc_super(struct file_system_type *type)
> >  #else
> >  		INIT_LIST_HEAD(&s->s_files);
> >  #endif
> > +		if (init_sb_writers(s, SB_FREEZE_WRITE, "sb_writers_write"))
> > +			goto err_out;
> > +		if (init_sb_writers(s, SB_FREEZE_TRANS, "sb_writers_trans"))
> > +			goto err_out;
> > +
> >  		s->s_bdi = &default_backing_dev_info;
> >  		INIT_LIST_HEAD(&s->s_instances);
> >  		INIT_HLIST_BL_HEAD(&s->s_anon);
> > @@ -186,6 +213,17 @@ static struct super_block *alloc_super(struct file_system_type *type)
> >  	}
> >  out:
> >  	return s;
> > +err_out:
> > +	security_sb_free(s);
> > +#ifdef CONFIG_SMP
> > +	if (s->s_files)
> > +		free_percpu(s->s_files);
> > +#endif
> > +	destroy_sb_writers(s, SB_FREEZE_WRITE);
> > +	destroy_sb_writers(s, SB_FREEZE_TRANS);
> 
> You probably ran into this already but the writer percpu vars need
> to be torn down in destroy_super() as well.
  Actually not. Thanks for spotting this.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
