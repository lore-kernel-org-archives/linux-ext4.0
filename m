From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] ext3: Warn if mounting rw on a disk requiring
 stable page writes
Date: Wed, 21 Nov 2012 03:15:43 +0100
Message-ID: <20121121021543.GI10507@quack.suse.cz>
References: <20121121020027.10225.43206.stgit@blackbox.djwong.org>
 <20121121020056.10225.15220.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	tytso@mit.edu, rminnich@sandia.gov, viro@zeniv.linux.org.uk,
	martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab2KUCPs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Nov 2012 21:15:48 -0500
Content-Disposition: inline
In-Reply-To: <20121121020056.10225.15220.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 20-11-12 18:00:56, Darrick J. Wong wrote:
> ext3 doesn't properly isolate pages from changes during writeback.  Since the
> recommended fix is to use ext4, for now we'll just print a warning if the user
> tries to mount in write mode.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/ext3/super.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 5366393..5b3725d 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -1325,6 +1325,14 @@ static int ext3_setup_super(struct super_block *sb, struct ext3_super_block *es,
>  			"forcing read-only mode");
>  		res = MS_RDONLY;
>  	}
> +	if (!read_only &&
> +	    queue_requires_stable_pages(bdev_get_queue(sb->s_bdev))) {
> +		ext3_msg(sb, KERN_ERR,
> +			"error: ext3 cannot safely write data to a disk "
> +			"requiring stable pages writes; forcing read-only "
> +			"mode.  Upgrading to ext4 is recommended.");
> +		res = MS_RDONLY;
> +	}
>  	if (read_only)
>  		return res;
>  	if (!(sbi->s_mount_state & EXT3_VALID_FS))
  Why this? ext3 should be fixed by your change to
filemap_page_mkwrite()... Or does testing show otherwise?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
