From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH] ext4: error should be cleared if ea_inode isn't added to
 the cache
Date: Tue, 11 Jul 2017 21:37:16 -0700
Message-ID: <CAAeU0aP-v4YZN05MH=gREEpE2AORUmHSqUKkxuOQ43BvWD268g@mail.gmail.com>
References: <1499831813-13218-1-git-send-email-emoly.liu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Emoly Liu <emoly.liu@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yb0-f182.google.com ([209.85.213.182]:36644 "EHLO
        mail-yb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756159AbdGLEhS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Jul 2017 00:37:18 -0400
Received: by mail-yb0-f182.google.com with SMTP id f194so3460198yba.3
        for <linux-ext4@vger.kernel.org>; Tue, 11 Jul 2017 21:37:17 -0700 (PDT)
In-Reply-To: <1499831813-13218-1-git-send-email-emoly.liu@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Reviewed-by: tahsin@google.com

On Tue, Jul 11, 2017 at 8:56 PM, Emoly Liu <emoly.liu@intel.com> wrote:
> For Lustre, if ea_inode fails in hash validation but passes parent
> inode and generation checks, it won't be added to the cache as well
> as the error "-EFSCORRUPTED" should be cleared, otherwise it will
> cause "Structure needs cleaning" when running getfattr command.
>
> Signed-off-by: Emoly Liu <emoly.liu@intel.com>
> Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-9723
> ---
>  fs/ext4/xattr.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index cff4f41..de217a0 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -451,6 +451,7 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
>                 }
>                 /* Do not add ea_inode to the cache. */
>                 ea_inode_cache = NULL;
> +               err = 0;
>         } else if (err)
>                 goto out;
>
> --
> 1.8.3.1
>
