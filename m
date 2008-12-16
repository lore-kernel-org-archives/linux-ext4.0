From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] vfs: introduce helper function to safely NUL-terminate
	symlinks
Date: Tue, 16 Dec 2008 16:46:38 -0700
Message-ID: <20081216234638.GX5000@webber.adilger.int>
References: <1229442720-31056-1-git-send-email-duaneg@dghda.com>
 <1229442720-31056-2-git-send-email-duaneg@dghda.com>
 <1229442720-31056-3-git-send-email-duaneg@dghda.com>
 <1229442720-31056-4-git-send-email-duaneg@dghda.com>
 <1229442720-31056-5-git-send-email-duaneg@dghda.com>
 <1229442720-31056-6-git-send-email-duaneg@dghda.com>
 <1229442720-31056-1-git-send-email-duaneg@dghda.com>
 <1229442720-31056-2-git-send-email-duaneg@dghda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:46811 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbYLPXqp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Dec 2008 18:46:45 -0500
In-reply-to: <1229442720-31056-6-git-send-email-duaneg@dghda.com>
 <1229442720-31056-2-git-send-email-duaneg@dghda.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 16, 2008  15:51 +0000, Duane Griffin wrote:
> A number of filesystems were potentially triggering kernel bugs due to
> corrupted symlink names on disk. This helper helps safely terminate the
> names.
> 
> +static inline void nd_terminate_link(void *name,unsigned len,unsigned maxlen)
> +{
> +	((char *) name)[min(len, maxlen)] = '\0';
> +}

> @@ -4200,9 +4201,11 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>  	} else if (S_ISLNK(inode->i_mode)) {
> +		if (ext4_inode_is_fast_symlink(inode)) {
>  			inode->i_op = &ext4_fast_symlink_inode_operations;
> +			nd_terminate_link(ei->i_data, inode->i_size,
> +				sizeof(ei->i_data));
> +		} else {
>  			inode->i_op = &ext4_symlink_inode_operations;
>  			ext4_set_aops(inode);
>  		}

With sizeof(ei->i_data) = 15 * 4 = 60 bytes, this will set ei->i_data[60]
as NUL, which is writing 1 byte beyond the end of the array.

Note that in ext[234]_symlink() the check for fast symlinks is:

	l = strlen(symname)+1;
        if (l > sizeof (EXT3_I(inode)->i_data)) {
		inode->i_op = &ext3_symlink_inode_operations;
	} else {
		inode->i_op = &ext3_fast_symlink_inode_operations;
		inode->i_size = l-1;
	}

so in fact the fast symlinks should always have space for a trailing NUL
character, and "sizeof(ei->i_data) - 1" is the right maxlen to use for
ext[234].

That might not be true for other filesystems, in which case you would
need to add a "padding" field after the symlink name in memory to hold
the trailing NUL.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

