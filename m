From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH, RFC] Ext3: Mount partition as read only if during
 orphan cleanup truncate fails to obtain journal handle.
Date: Mon, 29 Oct 2012 11:49:39 +0100
Message-ID: <20121029104939.GB18767@quack.suse.cz>
References: <1351075364-2886-1-git-send-email-ashish.sangwan2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org,
	Ashish Sangwan <ashish.sangwan2@gmail.com>,
	Namjae Jeon <linkinjeon@gmail.com>
To: Ashish Sangwan <ashishsangwan2@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52149 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338Ab2J2Ktl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Oct 2012 06:49:41 -0400
Content-Disposition: inline
In-Reply-To: <1351075364-2886-1-git-send-email-ashish.sangwan2@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 24-10-12 16:12:44, Ashish Sangwan wrote:
> During orphan cleanup while doing truncate, if we fail to obtain journal
> handle, the inode for which truncate was called would not be removed from
> both the on-disk and in-memory orphan lists as the call to ext3_orphan_del
> would not be executed.
> 
> This would have following consequences:
> a) As the inode is not removed from the on-disk list, truncate would be
> called again for the same inode. Each call would add the inode to the
> in-memory list. This operation would continue endlessly or until truncate
> is succeed.
> 
> b) If somehow, after some iterations, truncate is succeed, ext3_orphan_del
> will only remove the inode from in-memory list just 1 time. This will trigger
> j_assert during put super.
> 
> This patch handles both the problems. If truncate fails, first in-memory
> list is cleared and than the partition is mounted as read only.
> Failure to obtain journal handle during mount may suggest that journal
> device is corrupted.
  Could you really trigger any of the described bugs? Because
ext3_truncate() does take care to remove inode from orphan list even if
starting of a transaction fails (see out_notrans label in ext3_truncate()).
Also spitting additional messages should be unnecessary - the error which
caused truncate to fail should have logged the error message and also taken
appropriate action depending on filesystem configuration (i.e., remount fs
read-only, panic the system, or do nothing).

								Honza

> 
> Signed-off-by: Ashish Sangwan <ashish.sangwan2@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> ---
>  fs/ext3/super.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index bd60e08..798cd6f 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -1540,7 +1540,22 @@ static void ext3_orphan_cleanup (struct super_block * sb,
>  			jbd_debug(2, "truncating inode %lu to %Ld bytes\n",
>  				  inode->i_ino, inode->i_size);
>  			ext3_truncate(inode);
> -			nr_truncates++;
> +			if (list_empty(&EXT3_I(inode)->i_orphan)) {
> +				nr_truncates++;
> +			} else {
> +				/* Remove inode from in-memory orphan list */
> +				list_del_init(&EXT3_I(inode)->i_orphan);
> +				ext3_msg(sb, KERN_ERR, "Truncate failed for "
> +                                        "orphan  inode = %lu. Running e2fsck"
> +                                        " is recommended", inode->i_ino);
> +				if (!(s_flags & MS_RDONLY)) {
> +					ext3_msg(sb, KERN_INFO, "FS would be"
> +						" mounted as readonly");
> +					s_flags |= MS_RDONLY;
> +				}
> +				break;
> +			}
> +
>  		} else {
>  			printk(KERN_DEBUG
>  				"%s: deleting unreferenced inode %lu\n",
> -- 
> 1.7.11.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
