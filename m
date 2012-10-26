From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH, RFC] Ext3: Mount partition as read only if during orphan
 cleanup truncate fails to obtain journal handle.
Date: Fri, 26 Oct 2012 20:42:23 +0900
Message-ID: <CAKYAXd91L8Ar+kO-oPg9_j65s_4xtd87JJZ7S8B7EH_jB-NLgA@mail.gmail.com>
References: <1351075364-2886-1-git-send-email-ashish.sangwan2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: jack@suse.cz, linux-ext4@vger.kernel.org,
	Ashish Sangwan <ashish.sangwan2@gmail.com>,
	=?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Ashish Sangwan <ashishsangwan2@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49956 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364Ab2JZLmZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Oct 2012 07:42:25 -0400
In-Reply-To: <1351075364-2886-1-git-send-email-ashish.sangwan2@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add Cc in mail loop.

Thanks.

2012/10/24, Ashish Sangwan <ashishsangwan2@gmail.com>:
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
> will only remove the inode from in-memory list just 1 time. This will
> trigger
> j_assert during put super.
>
> This patch handles both the problems. If truncate fails, first in-memory
> list is cleared and than the partition is mounted as read only.
> Failure to obtain journal handle during mount may suggest that journal
> device is corrupted.
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
> @@ -1540,7 +1540,22 @@ static void ext3_orphan_cleanup (struct super_block *
> sb,
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
> +                                        "orphan  inode = %lu. Running
> e2fsck"
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
>
