From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: use EINVAL if not a regular file in
 ext4_fallocate()
Date: Wed, 23 Apr 2014 15:23:25 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404231521210.2157@localhost.localdomain>
References: <000e01cf5b8d$c57e9f80$507bde80$@samsung.com> <20140423060823.GA9262@gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1960674054-1398259408=:2157"
Cc: Namjae Jeon <namjae.jeon@samsung.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbaDWNXe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Apr 2014 09:23:34 -0400
In-Reply-To: <20140423060823.GA9262@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1960674054-1398259408=:2157
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Wed, 23 Apr 2014, Zheng Liu wrote:

> Date: Wed, 23 Apr 2014 14:08:23 +0800
> From: Zheng Liu <gnehzuil.liu@gmail.com>
> To: Namjae Jeon <namjae.jeon@samsung.com>
> Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4 <linux-ext4@vger.kernel.org>,
>     Luká¨ Czerner <lczerner@redhat.com>
> Subject: Re: [PATCH] ext4: use EINVAL if not a regular file in
>     ext4_fallocate()
> 
> On Sat, Apr 19, 2014 at 02:11:07PM +0900, Namjae Jeon wrote:
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> > 
> > Punch hole return EOPNOTSUPP about a non-REGULAR file also. So change EINVAL
> > to be consistent with xfs. And move this check to the start of
> > ext4_fallocate().
> 
> IMHO, EOPNOTSUPP makes sense to me.  From the man page of fallocate(2):
> 
> EOPNOTSUPP
>       The filesystem containing the file referred to by fd does not
>       support this operation; or the mode is not supported by the
>       filesystem containing the file referred to by fd.
> 
> Regards,
>                                                 - Zheng

I actually have the same opinion. There has been a discussion on
fsdevel-list and it seems that the decision was made to use EINVAL
for this case.

However there was only one person actually arguing for using EINVA
and that was Dave Chinner. Maybe we can discuss it a little bit more
?

-Lukas

> 
> > 
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > ---
> >  fs/ext4/extents.c | 9 +++------
> >  fs/ext4/inode.c   | 3 ---
> >  2 files changed, 3 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 3276865..b38f487 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -4741,9 +4741,6 @@ static long ext4_zero_range(struct file *file, loff_t offset,
> >  
> >  	trace_ext4_zero_range(inode, offset, len, mode);
> >  
> > -	if (!S_ISREG(inode->i_mode))
> > -		return -EINVAL;
> > -
> >  	/*
> >  	 * Write out all dirty pages to avoid race conditions
> >  	 * Then release them.
> > @@ -4888,6 +4885,9 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
> >  	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
> >  		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
> >  		return -EOPNOTSUPP;
> > +	
> > +	if (!S_ISREG(inode->i_mode))
> > +		return -EINVAL;
> >  
> >  	if (mode & FALLOC_FL_PUNCH_HOLE)
> >  		return ext4_punch_hole(inode, offset, len);
> > @@ -5403,9 +5403,6 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
> >  	    len & (EXT4_BLOCK_SIZE(sb) - 1))
> >  		return -EINVAL;
> >  
> > -	if (!S_ISREG(inode->i_mode))
> > -		return -EINVAL;
> > -
> >  	if (EXT4_SB(inode->i_sb)->s_cluster_ratio > 1)
> >  		return -EOPNOTSUPP;
> >  
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index d7b7462..d6cbbe3 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -3524,9 +3524,6 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
> >  	unsigned int credits;
> >  	int ret = 0;
> >  
> > -	if (!S_ISREG(inode->i_mode))
> > -		return -EOPNOTSUPP;
> > -
> >  	trace_ext4_punch_hole(inode, offset, length, 0);
> >  
> >  	/*
> > -- 
> > 1.7.11-rc0
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-1960674054-1398259408=:2157--
