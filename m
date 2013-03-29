From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH, RFC V2] ext3: add ioctl to force 32-bit hashes from
 indexed dirs
Date: Fri, 29 Mar 2013 12:43:34 +0100
Message-ID: <20130329114334.GB5913@quack.suse.cz>
References: <51546EED.8030507@redhat.com>
 <5154AAB4.2000701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Anand Avati <avati@redhat.com>, Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52979 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826Ab3C2Lnh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Mar 2013 07:43:37 -0400
Content-Disposition: inline
In-Reply-To: <5154AAB4.2000701@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 28-03-13 15:40:20, Eric Sandeen wrote:
> This adds a new ioctl, EXT3_IOC_32BITHASH, which allows a
> userspace application to request 32-bit rather than 64-bit
> hashes from readdir on an indexed / dx / htree directory.
> 
> Gluster had been relying on the top bits of the d_off being
> free; there are some reports that filling all 64 bits breaks
> Samba as well.  The infrastructure to return 32-bit hashes
> already exists; NFS can turn it on, and it's turned on for
> 32-bit processes as well.  So it's just a matter of flipping
> on the f_mode flag before readdir starts.
> 
> Care needs to be taken that we don't change the FMODE flag
> after readdir has been started, so we make sure that
> filp->private_data has not yet been set before we set the flag.
> (Thanks Zach!).
> 
> Pre-submission-fixes-by: Zach Brown <zab@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2:
> fix "readir" typo
> rename goto target to *_out like others
> remove parameter; we can't really ever turn this back off once it's used.
> closing and reopening is the only way to get back to 64 bit hashes.
  Looks good. Just one nit below:

> diff --git a/fs/ext3/ext3.h b/fs/ext3/ext3.h
> +	case EXT3_IOC_32BITHASH: {
> +		int err = 0;
> +
> +		/* Serialize with readdir */
> +		if ((err = mutex_lock_killable(&inode->i_mutex)))
> +			return err;
> +
> +		/* protect f_mode */
> +		spin_lock(&filp->f_lock);
> +
> +		/* Only valid for htree directories */
> +		if (!S_ISDIR(inode->i_mode) || !is_dx_dir(inode)) {
  Won't it be better to return ENOTDIR in !S_ISDIR case?

> +			err = -EINVAL;
> +			goto hash32bits_out;
> +		}
> +
> +		/* Have we already started readdir on this dx dir? */
> +		if (filp->private_data) {
> +			err = -EINVAL;
  And here maybe EBUSY, but in this case I'm really undecided.

> +			goto hash32bits_out;
> +		}
> +
> +		filp->f_mode |= FMODE_32BITHASH;
> +hash32bits_out:
> +		spin_unlock(&filp->f_lock);
> +		mutex_unlock(&inode->i_mutex);
> +		return err;
> +	}
>  	case FITRIM: {
>  
>  		struct super_block *sb = inode->i_sb;

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
