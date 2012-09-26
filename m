From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: enable FITRIM ioctl on bigalloc file system
Date: Wed, 26 Sep 2012 15:46:16 -0400 (EDT)
Message-ID: <alpine.LFD.2.00.1209261545430.31136@dhcp-187-45.bos.redhat.com>
References: <1341342642-4156-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1208211148070.2436@dhcp-1-248.brq.redhat.com> <alpine.LFD.2.00.1209121131320.2222@new-host-2>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="269102523-1635235519-1348688777=:31136"
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928Ab2IZTqT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2012 15:46:19 -0400
In-Reply-To: <alpine.LFD.2.00.1209121131320.2222@new-host-2>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--269102523-1635235519-1348688777=:31136
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Wed, 12 Sep 2012, Luká¨ Czerner wrote:

> Date: Wed, 12 Sep 2012 11:31:46 -0400 (EDT)
> From: Luká¨ Czerner <lczerner@redhat.com>
> To: Luká¨ Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
> Subject: Re: [PATCH] ext4: enable FITRIM ioctl on bigalloc file system
> 
> On Tue, 21 Aug 2012, Luká¨ Czerner wrote:
> 
> > Date: Tue, 21 Aug 2012 11:48:27 +0200 (CEST)
> > From: Luká¨ Czerner <lczerner@redhat.com>
> > To: Lukas Czerner <lczerner@redhat.com>
> > Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
> > Subject: Re: [PATCH] ext4: enable FITRIM ioctl on bigalloc file system
> > 
> > On Tue, 3 Jul 2012, Lukas Czerner wrote:
> > 
> > > Date: Tue,  3 Jul 2012 21:10:42 +0200
> > > From: Lukas Czerner <lczerner@redhat.com>
> > > To: linux-ext4@vger.kernel.org
> > > Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
> > > Subject: [PATCH] ext4: enable FITRIM ioctl on bigalloc file system
> > > 
> > > With a minor tweaks regarding minimum extent size to discard and
> > > discarded bytes reporting the FITRIM can be enabled on bigalloc file
> > > system and it works without any problem.
> > > 
> > > This patch fixes minlen handling and discarded bytes reporting to
> > > take into consideration bigalloc enabled file systems and finally
> > > removes the restriction and allow FITRIM to be used on file system with
> > > bigalloc feature enabled.
> > 
> > any comments on this ?
> > 
> > Thanks!
> > -Lukas
> 
> ping^2

ping^3

> 
> > > 
> > > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > > ---
> > >  fs/ext4/ioctl.c   |    7 -------
> > >  fs/ext4/mballoc.c |    5 +++--
> > >  2 files changed, 3 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> > > index e34deac..9d6e0bc 100644
> > > --- a/fs/ext4/ioctl.c
> > > +++ b/fs/ext4/ioctl.c
> > > @@ -420,13 +420,6 @@ resizefs_out:
> > >  		if (!blk_queue_discard(q))
> > >  			return -EOPNOTSUPP;
> > >  
> > > -		if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
> > > -			       EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
> > > -			ext4_msg(sb, KERN_ERR,
> > > -				 "FITRIM not supported with bigalloc");
> > > -			return -EOPNOTSUPP;
> > > -		}
> > > -
> > >  		if (copy_from_user(&range, (struct fstrim_range __user *)arg,
> > >  		    sizeof(range)))
> > >  			return -EFAULT;
> > > diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> > > index 1cd6994..c4bd0a6 100644
> > > --- a/fs/ext4/mballoc.c
> > > +++ b/fs/ext4/mballoc.c
> > > @@ -4984,7 +4984,8 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
> > >  
> > >  	start = range->start >> sb->s_blocksize_bits;
> > >  	end = start + (range->len >> sb->s_blocksize_bits) - 1;
> > > -	minlen = range->minlen >> sb->s_blocksize_bits;
> > > +	minlen = EXT4_NUM_B2C(EXT4_SB(sb),
> > > +			      range->minlen >> sb->s_blocksize_bits);
> > >  
> > >  	if (unlikely(minlen > EXT4_CLUSTERS_PER_GROUP(sb)) ||
> > >  	    unlikely(start >= max_blks))
> > > @@ -5044,6 +5045,6 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
> > >  		atomic_set(&EXT4_SB(sb)->s_last_trim_minblks, minlen);
> > >  
> > >  out:
> > > -	range->len = trimmed * sb->s_blocksize;
> > > +	range->len = EXT4_C2B(EXT4_SB(sb), trimmed) << sb->s_blocksize_bits;
> > >  	return ret;
> > >  }
> > > 
> > 
--269102523-1635235519-1348688777=:31136--
