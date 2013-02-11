From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 12/12] ext4: start handle at the last possible moment when creating inodes
Date: Mon, 11 Feb 2013 09:00:59 -0700
Message-ID: <31662628-7A29-42C8-A18F-80122EC4F9F4@dilger.ca>
References: <1360446832-12724-1-git-send-email-tytso@mit.edu> <1360446832-12724-13-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:57937 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757632Ab3BKQBB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Feb 2013 11:01:01 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so2737426dak.19
        for <linux-ext4@vger.kernel.org>; Mon, 11 Feb 2013 08:01:00 -0800 (PST)
In-Reply-To: <1360446832-12724-13-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-02-09, at 14:53, Theodore Ts'o <tytso@mit.edu> wrote:

> In ext4_{create,mknod,mkdir,symlink}(), don't start the journal handle
> until the inode has been succesfully allocated.  In order to do this,
> we need to start the handle in the ext4_new_inode().  So create a new
> variant of this function, ext4_new_inode_start_handle(), so the handle
> can be created at the last possible minute, before we need to modify
> the inode allocation bitmap block.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> fs/ext4/ext4.h   | 17 ++++++++--
> fs/ext4/ialloc.c | 15 +++++++--
> fs/ext4/namei.c  | 94 ++++++++++++++++++++++++++------------------------------
> 3 files changed, 71 insertions(+), 55 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 9897cdf..05940ce 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1991,9 +1991,20 @@ extern int ext4fs_dirhash(const char *name, int len, struct
>              dx_hash_info *hinfo);
> 
> /* ialloc.c */
> -extern struct inode *ext4_new_inode(handle_t *, struct inode *, umode_t,
> -                    const struct qstr *qstr, __u32 goal,
> -                    uid_t *owner);
> +extern struct inode *__ext4_new_inode(handle_t *, struct inode *, umode_t,
> +                      const struct qstr *qstr, __u32 goal,
> +                      uid_t *owner, int handle_type,
> +                      unsigned int line_no, int nblocks);
> +
> +#define ext4_new_inode(handle, dir, mode, qstr, goal, owner) \
> +    __ext4_new_inode((handle), (dir), (mode), (qstr), (goal), (owner), \
> +             0, 0, 0)
> +#define ext4_new_inode_start_handle(dir, mode, qstr, goal, owner, \
> +                    type, nblocks)            \
> +    __ext4_new_inode(0, (dir), (mode), (qstr), (goal), (owner), \

Please use "NULL" instead of "0" for pointers.

Cheers, Andreas