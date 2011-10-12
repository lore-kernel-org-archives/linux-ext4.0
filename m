From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 12/28] ext4: Use i_generation in inode-related metadata
	checksums
Date: Wed, 12 Oct 2011 14:28:38 -0700
Message-ID: <20111012212838.GP12447@tux1.beaverton.ibm.com>
References: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com> <20111008075502.20506.15728.stgit@elm3c44.beaverton.ibm.com> <BFA9D351-575B-4B48-B5D8-D01DF5317A7C@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40568 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266Ab1JLVfO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Oct 2011 17:35:14 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Wed, 12 Oct 2011 17:30:26 -0400
Content-Disposition: inline
In-Reply-To: <BFA9D351-575B-4B48-B5D8-D01DF5317A7C@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 12, 2011 at 12:52:30PM -0700, Andreas Dilger wrote:
> On 2011-10-08, at 12:55 AM, Darrick J. Wong wrote:
> > Whenever we are calculating a checksum for a piece of metadata that is
> > associated with an inode, incorporate i_generation into that calculation
> > so that old metadata blocks cannot be re-associated after a delete/create cycle.
> 
> It would be better to fold this into the previous patch, since it will
> otherwise cause the inode checksum algorithm to change in the middle of the patch series.

Sure.  I guess I can go do that on the e2fsprogs side too.

> On a related note, in ext4_new_inode() it would be useful to change the
> setting of i_generation so that it skips i_generation == 0, which doesn't
> contribute to the checksum:
> 
>         spin_lock(&sbi->s_next_gen_lock);
>         inode->i_generation = sbi->s_next_generation++;
> +	if (unlikely(inode->i_generation == 0))
> +	        inode->i_generation = sbi->s_next_generation++;
>         spin_unlock(&sbi->s_next_gen_lock);

For that to happen the UUID+inode would have to checksum to zero, which seems
fairly unlikely since I set the "initial" value in ext4_chksum to ~0 to avoid
the case where UUID = 0, and there's no such thing as inode 0, which means thee
likelihood of the checksum being 0 at this point ought to be 1:2^32.  Even
then, the checksum will be different if the value of i_generation changes.

That said, if we /do/ implement this, then perhaps e2fsprogs should be taught
to set i_generation, as it does not do that currently.

> > diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> > index 6e5876a..d4b59e9 100644
> > --- a/fs/ext4/ialloc.c
> > +++ b/fs/ext4/ialloc.c
> > @@ -1031,11 +1031,14 @@ got:
> > 	/* Precompute second piece of crc */
> > 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
> > 			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
> > +		__u32 crc;
> > 		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> > 		__le32 inum = cpu_to_le32(inode->i_ino);
> > -		ei->i_uuid_inum_crc = ext4_chksum(sbi, sbi->s_uuid_crc,
> > -						  (__u8 *)&inum,
> > -						  sizeof(inum));
> > +		__le32 gen = cpu_to_le32(inode->i_generation);
> > +		crc = ext4_chksum(sbi, sbi->s_uuid_crc, (__u8 *)&inum,
> > +				  sizeof(inum));
> > +		ei->i_uuid_inum_crc = ext4_chksum(sbi, crc, (__u8 *)&gen,
> > +						  sizeof(gen));
> > 	}
> > 
> > 	ext4_clear_state_flags(ei); /* Only relevant on 32-bit archs */
> > 
> > diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> > index f18bfe3..fdf0b1e 100644
> > --- a/fs/ext4/ioctl.c
> > +++ b/fs/ext4/ioctl.c
> > @@ -149,6 +149,10 @@ flags_out:
> > 		if (!inode_owner_or_capable(inode))
> > 			return -EPERM;
> > 
> > +		if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> > +				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> > +			return -ENOTTY;
> 
> This should get an ext4_warning() in the non-checksum case to warn
> users that this ioctl is deprecated and will be removed in the
> future unless there is a good reason to keep it.

Ok.  Maybe put it in feature_removal_schedule.txt too?  Maybe not; the ioctl is
not being totally removed, it's merely unsupported for the metadata_csum case.

--D

