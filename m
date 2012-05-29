From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: force ro mount if ext3_setup_super() fails
Date: Tue, 29 May 2012 16:09:16 +0200
Message-ID: <20120529140916.GD23991@quack.suse.cz>
References: <4FBE6935.3000301@redhat.com>
 <49CDEB80-418A-492C-B3F1-8E2A46DA9E29@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45039 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab2E2OJY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 May 2012 10:09:24 -0400
Content-Disposition: inline
In-Reply-To: <49CDEB80-418A-492C-B3F1-8E2A46DA9E29@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 24-05-12 11:41:57, Andreas Dilger wrote:
> On 2012-05-24, at 11:00 AM, Eric Sandeen wrote:
> > If ext3_setup_super() fails i.e. due to a too-high revision,
> > the error is logged in dmesg but the fs is not mounted RO as
> > indicated.
> > 
> > Tested by:
> > 
> > # mkfs.ext3 -r 4 /dev/sdb6
> > # mount /dev/sdb6 /mnt/test
> > # dmesg | grep "too high"
> > [164152.114551] EXT3-fs (sdb6): error: revision level too high, forcing read-only mode
> > # grep sdb6 /proc/mounts
> > /dev/sdb6 /mnt/test2 ext3 rw,seclabel,relatime,errors=continue,user_xattr,acl,barrier=1,data=ordered 0 0
> >                          ^^
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Reviewed-by: Andreas Dilger <adilger@whamcloud.com>
  Thanks! Merged to my tree.

									Honza

> > ---
> > 
> > diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> > index cf0b592..fef7af2 100644
> > --- a/fs/ext3/super.c
> > +++ b/fs/ext3/super.c
> > @@ -2043,7 +2043,8 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
> > 		goto failed_mount3;
> > 	}
> > 
> > -	ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY);
> > +	if (ext3_setup_super(sb, es, sb->s_flags & MS_RDONLY))
> > +		sb->s_flags |= MS_RDONLY;
> 
> I was wondering if this should be:
> 
> 	sb->s_flags |= ext3_setup_super(...)
> 
> but that might be over-thinking things.
> 
> > 	EXT3_SB(sb)->s_mount_state |= EXT3_ORPHAN_FS;
> > 	ext3_orphan_cleanup(sb, es);
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
