From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] [17/23] EXT3: Fix set but unused variables
Date: Tue, 15 Jun 2010 16:01:32 +0200
Message-ID: <20100615140132.GB18513@atrey.karlin.mff.cuni.cz>
References: <20100610110.764742110@firstfloor.org> <20100610111053.43E78B1A2B@basil.firstfloor.org> <20100614172718.GC6666@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: tytso@mit.edu, Andi Kleen <andi@firstfloor.org>,
	linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:45345 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757725Ab0FOOBe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jun 2010 10:01:34 -0400
Content-Disposition: inline
In-Reply-To: <20100614172718.GC6666@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Thu, Jun 10, 2010 at 01:10:53PM +0200, Andi Kleen wrote:
> > Index: linux-2.6.35-rc2-gcc/fs/jbd/recovery.c
> > ===================================================================
> > --- linux-2.6.35-rc2-gcc.orig/fs/jbd/recovery.c
> > +++ linux-2.6.35-rc2-gcc/fs/jbd/recovery.c
> > @@ -283,12 +283,10 @@ int journal_recover(journal_t *journal)
> >  int journal_skip_recovery(journal_t *journal)
> >  {
> >  	int			err;
> > -	journal_superblock_t *	sb;
> >  
> >  	struct recovery_info	info;
> >  
> >  	memset (&info, 0, sizeof(info));
> > -	sb = journal->j_superblock;
> 
> Oops, spoke too soon.  This will cause a compile error if
> CONFIG_JBD_DEBUG is defined.
> 
> The following pesudo-patch is required:
> 
>  #ifdef CONFIG_JBD_DEBUG
> -		int dropped = info.end_transaction - be32_to_cpu(sb->s_sequence);
> +		int dropped = info.end_transaction - 
> +				be32_to_cpu(journal->j_superblock->s_sequence);
>  #endif
  I have merged the patch with your fix to my tree.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
