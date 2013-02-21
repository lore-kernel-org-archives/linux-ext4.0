From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: fix overhead calculation in bigalloc filesystem
 (Re: ... )
Date: Thu, 21 Feb 2013 13:52:58 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1302211351090.19354@localhost>
References: <1361433665-16880-1-git-send-email-lczerner@redhat.com> <20130221121545.GA30821@gmail.com> <alpine.LFD.2.00.1302211335390.19354@localhost> <alpine.LFD.2.00.1302211346240.19354@localhost>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-495425614-1361451182=:19354"
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>
To: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415Ab3BUMxF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Feb 2013 07:53:05 -0500
In-Reply-To: <alpine.LFD.2.00.1302211346240.19354@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-495425614-1361451182=:19354
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 21 Feb 2013, Luká¨ Czerner wrote:

> Date: Thu, 21 Feb 2013 13:50:03 +0100 (CET)
> From: Luká¨ Czerner <lczerner@redhat.com>
> To: Luká¨ Czerner <lczerner@redhat.com>
> Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
>     Theodore Ts'o <tytso@mit.edu>
> Subject: Re: [PATCH] ext4: fix overhead calculation in bigalloc filesystem
>     (Re: ... )
> 
> On Thu, 21 Feb 2013, Luká¨ Czerner wrote:
> 
> ..snip...
> 
> > 
> > Hi Zheng,
> > 
> > thanks for the review. I know about the other issues and I'm trying
> > to resolve those as well. Right now I have a patch which includes
> > the changes ext4_calculate_overhead() you've described below and more,
> > but even with this I still see some problems remaining.
> > 
> > Hopefully will send another patch soon.
> > 
> > Thanks!
> > -Lukas
> > 
> > > 
> > > Subject: [PATCH] ext4: fix overhead calculation in bigalloc filesystem
> > > 
> > > From: Zheng Liu <wenqing.lz@taobao.com>
> > > 
> > > ext4_calculate_overhead() should compute the overhead and stash it in
> > > sbi->s_overhead.  But we miss use EXT4_B2C() to calculate the number of
> > > clusters before first_data_block and the number of journal blocks.  This
> > > commit use EXT4_NUM_B2C() instead of EXT4_B2C() to calculate the
> > > overhead.
> > > 
> > > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > > Cc: "Theodore Ts'o" <tytso@mit.edu>
> > > ---
> > >  fs/ext4/super.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > > index 3d4fb81..6165558 100644
> > > --- a/fs/ext4/super.c
> > > +++ b/fs/ext4/super.c
> > > @@ -3219,7 +3219,7 @@ int ext4_calculate_overhead(struct super_block *sb)
> > >  	/*
> > >  	 * All of the blocks before first_data_block are overhead
> > >  	 */
> > > -	overhead = EXT4_B2C(sbi, le32_to_cpu(es->s_first_data_block));
> > > +	overhead = EXT4_NUM_B2C(sbi, le32_to_cpu(es->s_first_data_block));
> 
> ...except this. I do not think this is right because we do not skip
> the first cluster right ? We're still using it, but we can never use
> the block before es->s_first_data_block. Please correct me if I am
> wrong.

moreover we do not allow bigalloc file system with block size < 4k.

> 
> 
> > >  
> > >  	/*
> > >  	 * Add the overhead found in each block group
> > > @@ -3235,7 +3235,7 @@ int ext4_calculate_overhead(struct super_block *sb)
> > >  	}
> > >  	/* Add the journal blocks as well */
> > >  	if (sbi->s_journal)
> > > -		overhead += EXT4_B2C(sbi, sbi->s_journal->j_maxlen);
> > > +		overhead += EXT4_NUM_B2C(sbi, sbi->s_journal->j_maxlen);
> 
> This I already have in my patch I'm testing right now. And as I said
> there are other places where we misuse EXT4_B2C().
> 
> -Lukas
> 
> > >  
> > >  	sbi->s_overhead = overhead;
> > >  	smp_wmb();
> > > 
> > 
> 
--8323328-495425614-1361451182=:19354--
