From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Do not convert to indirect with bigalloc enabled
Date: Tue, 9 Apr 2013 12:07:21 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1304091206540.22989@localhost>
References: <1365070685-5088-1-git-send-email-lczerner@redhat.com> <20130408061011.GB328@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763214Ab3DIKH1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Apr 2013 06:07:27 -0400
In-Reply-To: <20130408061011.GB328@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 8 Apr 2013, Zheng Liu wrote:

> Date: Mon, 8 Apr 2013 14:10:11 +0800
> From: Zheng Liu <gnehzuil.liu@gmail.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
> Subject: Re: [PATCH] ext4: Do not convert to indirect with bigalloc enabled
> 
> On Thu, Apr 04, 2013 at 12:18:05PM +0200, Lukas Czerner wrote:
> > With bigalloc feature enabled we do not support indirect addressing at all
> > so we have to prevent extent addressing to indirect addressing
> > conversion in this case. The problem has been introduced with the commit
> > "ext4: support simple conversion of extent-mapped inodes to use i_blocks"
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  fs/ext4/extents.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 6c5a70a..ddb6628 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -4735,6 +4735,10 @@ int ext4_ind_migrate(struct inode *inode)
> >  	    (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
> >  		return -EINVAL;
> >  
> > +	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> > +				       EXT4_FEATURE_RO_COMPAT_BIGALLOC))
> > +		return -EOPNOTSUPP;
> > +
> >  	down_write(&EXT4_I(inode)->i_data_sem);
> >  	ret = ext4_ext_check_inode(inode);
> >  	if (ret)
> 
> I am wandering whether ext4_ind_migrate needs to be moved into
> fs/ext4/migrate.c file.  Maybe it is better.

You're right, it make much more sense. I'll prepare a patch.

Thanks!
-Lukas

> 
> Regards,
>                                                 - Zheng
> 
