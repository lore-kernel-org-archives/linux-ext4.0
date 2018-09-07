From: Mike Marshall <hubcap@omnibond.com>
Subject: Re: [PATCH v2 5/5] orangefs: cache NULL when both default_acl and acl
 are NULL
Date: Fri, 7 Sep 2018 14:11:08 -0400
Message-ID: <CAOg9mSR1n88LBpmr7kOdSRx84FtnzUzsxG+oV4=vWVjz0Zkfbw@mail.gmail.com>
References: <20180831143352.22970-1-cgxu519@gmx.com> <20180831143352.22970-5-cgxu519@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: jack@suse.com, "Theodore Ts'o" <tytso@mit.edu>,
        adilger.kernel@dilger.ca, jaegeuk@kernel.org, yuchao0@huawei.com,
        shaggy@kernel.org, Martin Brandenburg <martin@omnibond.com>,
        devel@lists.orangefs.org, LKML <linux-kernel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        jfs-discussion@lists.sourceforge.net,
        Mike Marshall <hubcap@omnibond.com>
To: cgxu519@gmx.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180831143352.22970-5-cgxu519@gmx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Thanks... I've added your patch to 4.19-rc2, run it through xfstests,
and added it to my linux-next tree...

-Mike
On Fri, Aug 31, 2018 at 10:35 AM Chengguang Xu <cgxu519@gmx.com> wrote:
>
> default_acl and acl of newly created inode will be initiated
> as ACL_NOT_CACHED in vfs function inode_init_always() and later
> will be updated by calling xxx_init_acl() in specific filesystems.
> Howerver, when default_acl and acl are NULL then they keep the value
> of ACL_NOT_CACHED, this patch tries to cache NULL for acl/default_acl
> in this case.
>
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
> ---
> v1->v2:
> - Coding style change.
>
>  fs/orangefs/acl.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/orangefs/acl.c b/fs/orangefs/acl.c
> index 10587413b20e..72d2ff17d27b 100644
> --- a/fs/orangefs/acl.c
> +++ b/fs/orangefs/acl.c
> @@ -167,12 +167,16 @@ int orangefs_init_acl(struct inode *inode, struct inode *dir)
>                 error = __orangefs_set_acl(inode, default_acl,
>                                            ACL_TYPE_DEFAULT);
>                 posix_acl_release(default_acl);
> +       } else {
> +               inode->i_default_acl = NULL;
>         }
>
>         if (acl) {
>                 if (!error)
>                         error = __orangefs_set_acl(inode, acl, ACL_TYPE_ACCESS);
>                 posix_acl_release(acl);
> +       } else {
> +               inode->i_acl = NULL;
>         }
>
>         /* If mode of the inode was changed, then do a forcible ->setattr */
> --
> 2.17.1
>
