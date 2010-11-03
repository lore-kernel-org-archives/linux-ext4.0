From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: optimize orphan_list handling for ext4_setattr
Date: Wed, 3 Nov 2010 03:06:41 -0600
Message-ID: <93E1B72A-9C36-4CBA-AABD-DC0032331921@dilger.ca>
References: <87r5fevji5.fsf@dmon-lap.sw.ru>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, Ted Ts'o <tytso@mit.edu>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:53892 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab0KCJGn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Nov 2010 05:06:43 -0400
In-Reply-To: <87r5fevji5.fsf@dmon-lap.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-10-25, at 01:06, Dmitry Monakhov wrote:
> Surprisingly chown() on ext4 is not SMP scalable operation. 
> Due to unconditional orphan_del(NULL, inode) in ext4_setattr()
> result in significant performance overhead because of global orphan
> mutex, especially in no-journal mode (where orphan_add() is noop).
> It is possible to skip explicit orphan_del if possible.
> 
> Results of fchown() micro-benchmark in no-journal mode
> while (1) {
>   iteration++;
>   fchown(fd, uid, gid);
>   fchown(fd, uid + 1, gid + 1)
> }
> measured: iterations per millisecond
> | nr_tasks | w/o patch | with patch |
> |        1 |       142 |        185 |
> |        4 |       109 |        642 |

AFAICS, both ext4_orphan_add() and ext4_orphan_del() already check right at the top of the function whether the handle is valid, so I can't really understand how this patch would make any difference for no-journal mode.

> @@ -5636,7 +5640,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr 

> +		if (ext4_handle_valid(handle)) {
> +			error = ext4_orphan_add(handle, inode);
> +			orphan = 1;
> +		}
> 		EXT4_I(inode)->i_disksize = attr->ia_size;
> 		rc = ext4_mark_inode_dirty(handle, inode);
> 		if (!error)

> @@ -5636,7 +5640,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr
> 	 * If the call to ext4_truncate failed to get a transaction handle at
> 	 * all, we need to clean up the in-core orphan list manually.
> 	 */
> -	if (inode->i_nlink)
> +	if (orphan && inode->i_nlink)
> 		ext4_orphan_del(NULL, inode);
> 
> 	if (!rc && (ia_valid & ATTR_MODE))

Basically, the first hunk is moving the ext4_handle_valid() into the caller, and the second is avoiding a call to ext4_orphan_del->ext4_handle_valid(), which would likely be an unmeasurable performance difference.  No locks are taken (or avoided) before ext4_handle_valid() is checked.

I think the actual fix would be to always set "orphan = 1" after ext4_orphan_add() is called, and only call ext4_orphan_del() in that case.  This is essentially what your patch does for with-journal mode, and the non-journal mode is a red-herring due to the early exit from ext4_orphan_del().

Even better would be a no-lock check of list_empty(&ei->i_orphan()) before getting s_orphan_lock, since it shouldn't be possible to have two threads adding/removing the same inode to the orphan list (otherwise the inode may not be on the orphan list at all since add/del is not refcounted).  The only reason for s_orphan_lock is to prevent corruption of the global list.

Cheers, Andreas





