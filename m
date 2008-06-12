From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 1/2] ext3: kill 2 useless magic numbers
Date: Thu, 12 Jun 2008 16:11:34 -0700
Message-ID: <1213312294.3698.30.camel@localhost.localdomain>
References: <48507964.1060309@cn.fujitsu.com>
	 <20080612063847.GR3726@webber.adilger.int>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Li Zefan <lizf@cn.fujitsu.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38101 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756253AbYFLXLk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jun 2008 19:11:40 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5CNBabF028419
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 19:11:36 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5CNBas0233192
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 19:11:36 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5CNBZ4A008146
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 19:11:36 -0400
In-Reply-To: <20080612063847.GR3726@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-06-12 at 00:38 -0600, Andreas Dilger wrote:
> On Jun 12, 2008  09:18 +0800, Li Zefan wrote:
> > dx_root_limit() will never return 20, and I can't figure out
> > what 20 stands for. This function has never changed since htree
> > directory indexing was merged.
> > 
> > Similar for dx_node_limit() and the magic 22.
> 
> This was for testing htree split code more aggressively, but can be
> removed.
> 
> Acked-by: Andreas Dilger <adilger@sun.com>

I added the ext4 version to the patch queue

Mingming
> 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > ---
> >  fs/ext3/namei.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> > index 0b8cf80..d282ea8 100644
> > --- a/fs/ext3/namei.c
> > +++ b/fs/ext3/namei.c
> > @@ -240,13 +240,13 @@ static inline unsigned dx_root_limit (struct inode *dir, unsigned infosize)
> >  {
> >  	unsigned entry_space = dir->i_sb->s_blocksize - EXT3_DIR_REC_LEN(1) -
> >  		EXT3_DIR_REC_LEN(2) - infosize;
> > -	return 0? 20: entry_space / sizeof(struct dx_entry);
> > +	return entry_space / sizeof(struct dx_entry);
> >  }
> >  
> >  static inline unsigned dx_node_limit (struct inode *dir)
> >  {
> >  	unsigned entry_space = dir->i_sb->s_blocksize - EXT3_DIR_REC_LEN(0);
> > -	return 0? 22: entry_space / sizeof(struct dx_entry);
> > +	return entry_space / sizeof(struct dx_entry);
> >  }
> >  
> >  /*
> > -- 
> > 1.5.4.rc3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

