From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 2.6.33.y 14/40] ext4: Fix possible lost inode write in no
 journal mode
Date: Fri, 28 Sep 2012 11:08:41 +0800
Message-ID: <CAGBYx2Z=JuVzJTMWxO1KFUR7LnJ1zSUfd-2SLhkfPc64q0nmvA@mail.gmail.com>
References: <1275393807-14369-1-git-send-email-tytso@mit.edu> <1275393807-14369-14-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: stable@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54678 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab2I1DJE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Sep 2012 23:09:04 -0400
In-Reply-To: <1275393807-14369-14-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Curt,

In journal mode, IMHO the case you described also happens. Could you
shed light on journal mode case?

Thanks,
Yongqiang.

On Tue, Jun 1, 2010 at 8:03 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> From: Curt Wohlgemuth <curtw@google.com>
>
> commit 8b472d739b2ddd8ab7fb278874f696cd95b25a5e upstream (as of v2.6.34-rc6)
>
> In the no-journal case, ext4_write_inode() will fetch the bh and call
> sync_dirty_buffer() on it.  However, if the bh has already been
> written and the bh reclaimed for some other purpose, AND if the inode
> is the only one in the inode table block in use, then
> ext4_get_inode_loc() will not read the inode table block from disk,
> but as an optimization, fill the block with zero's assuming that its
> caller will copy in the on-disk version of the inode.  This is not
> done by ext4_write_inode(), so the contents of the inode can simply
> get lost.  The fix is to use __ext4_get_inode_loc() with in_mem set to
> 0, instead of ext4_get_inode_loc().  Long term the API needs to be
> fixed so it's obvious why latter is not safe.
>
> Addresses-Google-Bug: #2526446
>
> Signed-off-by: Curt Wohlgemuth <curtw@google.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/inode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ff04c74..28152f8 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5204,7 +5204,7 @@ int ext4_write_inode(struct inode *inode, int wait)
>         } else {
>                 struct ext4_iloc iloc;
>
> -               err = ext4_get_inode_loc(inode, &iloc);
> +               err = __ext4_get_inode_loc(inode, &iloc, 0);
>                 if (err)
>                         return err;
>                 if (wait)
> --
> 1.6.6.1.1.g974db.dirty
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best Wishes
Yongqiang Yang
