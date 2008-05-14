From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH 4/4] jbd: fix error handling for checkpoint io (rebased)
Date: Wed, 14 May 2008 10:37:47 -0400
Message-ID: <20080514143747.GC20256@unused.rdu.redhat.com>
References: <482A6E00.6080303@hitachi.com> <482A6FA3.9000104@hitachi.com> <20080514131621.GB20256@unused.rdu.redhat.com> <20080514144410.GG24363@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Andrew Morton <akpm@linux-foundation.org>, sct@redhat.com,
	adilger@clusterfs.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
	sugita <yumiko.sugita.yf@hitachi.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757015AbYENOyD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 May 2008 10:54:03 -0400
Content-Disposition: inline
In-Reply-To: <20080514144410.GG24363@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 14, 2008 at 04:44:10PM +0200, Jan Kara wrote:
> > >  
> > > Index: linux-2.6.26-rc2/fs/ext3/super.c
> > > ===================================================================
> > > --- linux-2.6.26-rc2.orig/fs/ext3/super.c
> > > +++ linux-2.6.26-rc2/fs/ext3/super.c
> > > @@ -395,7 +395,10 @@ static void ext3_put_super (struct super
> > >  	ext3_xattr_put_super(sb);
> > >  	journal_destroy(sbi->s_journal);
> > >  	if (!(sb->s_flags & MS_RDONLY)) {
> > > -		EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
> > > +		if (!is_checkpoint_aborted(sbi->s_journal)) {
> > > +			EXT3_CLEAR_INCOMPAT_FEATURE(sb,
> > > +				EXT3_FEATURE_INCOMPAT_RECOVER);
> > > +		}
> > >  		es->s_state = cpu_to_le16(sbi->s_mount_state);
> > >  		BUFFER_TRACE(sbi->s_sbh, "marking dirty");
> > >  		mark_buffer_dirty(sbi->s_sbh);
> > 
> > Is this bit here really needed?  If we abort the journal the fs will be mounted
> > read only and we should never get in here.  Is there a case where we could abort
> > the journal and not be flipped to being read-only?  If there is such a case I
> > would think that we should fix that by making the fs read-only, and not have
> > this check.
>   Actually, journal_abort() (which could be called from journal_destroy())
> does nothing to the filesystem as such. So at this moment, ext3 can still
> happily think everything is OK. We only detect aborted journal in
> ext3_journal_start_sb() and call ext3_abort() in that case, which does all
> that is needed...
>

Hmm you're right, I was thinking we did some other stuff before put_super which
would have caught a journal abort but it looks like thats not the case.  Still
shouldn't do is_checkpoint_aborted(sbi->s_journal) since journal_destroy()
kfree's the journal.  Should probably move the is_journal_aborted() check above
that or something.  Thanks,

Josef 
