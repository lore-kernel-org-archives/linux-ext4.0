From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Date: Mon, 3 Nov 2008 12:37:50 -0800
Message-ID: <20081103123750.67c96224.akpm@linux-foundation.org>
References: <4908C951.2000309@redhat.com>
	<20081103184426.GA31894@ajones-laptop.nbttech.com>
	<20081103113318.35b0c266.akpm@linux-foundation.org>
	<20081103201428.GB30565@ajones-laptop.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org, sct@redhat.com,
	linux-kernel@vger.kernel.org
To: Arthur Jones <ajones@riverbed.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754184AbYKCUkB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 15:40:01 -0500
In-Reply-To: <20081103201428.GB30565@ajones-laptop.nbttech.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 3 Nov 2008 12:14:28 -0800
Arthur Jones <ajones@riverbed.com> wrote:

> Hi Andrew, ...
> 
> On Mon, Nov 03, 2008 at 11:33:18AM -0800, Andrew Morton wrote:
> > [...]
> > > --- a/fs/ext3/super.c
> > > +++ b/fs/ext3/super.c
> > > @@ -2392,7 +2392,13 @@ static int ext3_sync_fs(struct super_block *sb, int wait)
> > >       if (journal_start_commit(EXT3_SB(sb)->s_journal, &target)) {
> > >               if (wait)
> > >                       log_wait_commit(EXT3_SB(sb)->s_journal, target);
> > > -     }
> > > +     } else if (wait)
> > > +             /*
> > > +              * We may have a commit in progress, clear it out
> > > +              * before we go on...
> > > +              */
> > > +             ext3_force_commit(sb);
> > > +
> > >       return 0;
> > >  }
> > 
> > Can we do
> > 
> >         sb->s_dirt = 0;
> >         if (wait)
> >                 ext3_force_commit(...);
> >         else
> >                 journal_start_commit(...);
> 
> I think this is what you had in mind:

yup.

> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 18eaa78..2b48b85 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -2386,13 +2386,12 @@ static void ext3_write_super (struct super_block * sb)
>  
>  static int ext3_sync_fs(struct super_block *sb, int wait)
>  {
> -	tid_t target;
> -
>  	sb->s_dirt = 0;
> -	if (journal_start_commit(EXT3_SB(sb)->s_journal, &target)) {
> -		if (wait)
> -			log_wait_commit(EXT3_SB(sb)->s_journal, target);
> -	}
> +	if (wait)
> +		ext3_force_commit(sb);
> +	else
> +		journal_start_commit(EXT3_SB(sb)->s_journal, NULL);
> +
>  	return 0;
>  }
>  
> I tried this and it too fixes the problem.  FWIW I agree it
> looks better...
> 

OK.  But still, questions remain.

- should we clear s_dirt if log_wait_commit() didn't work?

- ext3_force_commit() clears s_dirt also

- should ext3_sync_fs() be dropping the ext3_force_commit() return
  value on the floor?

This is all rather worrisome.
