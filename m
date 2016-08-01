From: Jan Kara <jack@suse.cz>
Subject: Re: [4.7-rc6 ext3 BUG] kernel BUG at fs/ext4/xattr.c:1331
Date: Mon, 1 Aug 2016 14:19:30 +0200
Message-ID: <20160801121930.GB19431@quack2.suse.cz>
References: <20160718022356.GC1922@dastard>
 <20160718030256.GD1922@dastard>
 <83e3076d-4f84-705d-5259-b3ac1aaf90b7@redhat.com>
 <20160718052447.GE1922@dastard>
 <20160728135432.GA19398@quack2.suse.cz>
 <20160729002112.GX16044@dastard>
 <20160729064210.GA3611@quack2.suse.cz>
 <20160801030909.GD12853@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54821 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbcHAMTd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Aug 2016 08:19:33 -0400
Content-Disposition: inline
In-Reply-To: <20160801030909.GD12853@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 31-07-16 23:09:09, Ted Tso wrote:
> On Fri, Jul 29, 2016 at 08:42:10AM +0200, Jan Kara wrote:
> > 
> > I have written some fixes, working on testing them... So hopefully I can
> > submit them later today or next week.
> 
> How complicated are the fixes?  This should work as a temporary
> workaround and it going to be very simple to backport.

Relatively simple but there are still some bugs lurking - I have the
original issue fixed but I have implemented xfstests which stress the inode
expansion code in various ways and so far they are still able to crash the
kernel... Tomorrow I will be looking more into it and hopefully will be
able to finish the fixes.

Regarding your patch - I think it's a reasonable band-aid although I'll
have to backport proper fixes to 4.4 anyway (it's a base of our next
enterprise release), which is where i_projid got introduced as well, so
eventually we will have proper stable fixes for all relevant kernels
anyway.

								Honza

> commit e92d5b1cf6af642bc5018562e58044fd771f82bf
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Sun Jul 31 23:08:28 2016 -0400
> 
>     ext4: suppress inode growth for file systems w/o project quota
>     
>     We have not added a new "extra" inode field in a very long time, and
>     the code to deal with moving the extended attributes down to make room
>     for the extra inode fields has bitrotted and can cause kernel BUGS.
>     
>     Very few people will likely use project quotas (and those that do will
>     likely be creating a new file system from scratch) so as a temporary
>     pallative until we are sure the inode expansion code is all sane,
>     let's not try to expand the inode "extra" fields if the project
>     feature has not been enabled.
>     
>     Cc: stable@vger.kernel.org # v4.4+
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index c13a4e4..e2622ba 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3968,6 +3968,17 @@ no_journal:
>  	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE) {
>  		sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
>  						     EXT4_GOOD_OLD_INODE_SIZE;
> +		/*
> +		 * This is a temporary hack; we have not added a new
> +		 * "extra" inode field in a long time, and the code to
> +		 * expand the inode structure has bitrotted and can
> +		 * cause kernel BUG's.  If the file system does not
> +		 * have the project feature, let's not try to expand
> +		 * the inode's extra size as a temporary pallitive
> +		 * until we can fix up the inode expansion code.
> +		 */
> +		if (!ext4_has_feature_project(sb))
> +			sbi->s_want_extra_isize -= sizeof(__le32);
>  		if (ext4_has_feature_extra_isize(sb)) {
>  			if (sbi->s_want_extra_isize <
>  			    le16_to_cpu(es->s_want_extra_isize))
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
