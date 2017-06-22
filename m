From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH 01/11] ext4: Don't clear SGID when inheriting ACLs
Date: Thu, 22 Jun 2017 17:32:05 +0200
Message-ID: <CAHc6FU6fb3mVFaHi1-8VtAkSfLNd-L26455PreBMpW_G1Qe3Gg@mail.gmail.com>
References: <20170622133115.16968-1-jack@suse.cz> <20170622133115.16968-2-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170622133115.16968-2-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 22, 2017 at 3:31 PM, Jan Kara <jack@suse.cz> wrote:
> When new directory 'DIR1' is created in a directory 'DIR0' with SGID bit
> set, DIR1 is expected to have SGID bit set (and owning group equal to
> the owning group of 'DIR0'). However when 'DIR0' also has some default
> ACLs that 'DIR1' inherits, setting these ACLs will result in SGID bit on
> 'DIR1' to get cleared if user is not member of the owning group.
>
> Fix the problem by moving posix_acl_update_mode() out of
> __ext4_set_acl() into ext4_set_acl(). That way the function will not be
> called when inheriting ACLs which is what we want as it prevents SGID
> bit clearing and the mode has been properly set by posix_acl_create()
> anyway.
>
> Fixes: 073931017b49d9458aa351605b43a7e34598caef
> CC: stable@vger.kernel.org
> CC: linux-ext4@vger.kernel.org
> CC: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Jan Kara <jack@suse.cz>

This is looking good, thanks.

Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>

> ---
>  fs/ext4/acl.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
> index 3ec0e46de95f..37242af33ff2 100644
> --- a/fs/ext4/acl.c
> +++ b/fs/ext4/acl.c
> @@ -193,13 +193,6 @@ __ext4_set_acl(handle_t *handle, struct inode *inode, int type,
>         switch (type) {
>         case ACL_TYPE_ACCESS:
>                 name_index = EXT4_XATTR_INDEX_POSIX_ACL_ACCESS;
> -               if (acl) {
> -                       error = posix_acl_update_mode(inode, &inode->i_mode, &acl);
> -                       if (error)
> -                               return error;
> -                       inode->i_ctime = current_time(inode);
> -                       ext4_mark_inode_dirty(handle, inode);
> -               }
>                 break;
>
>         case ACL_TYPE_DEFAULT:
> @@ -242,7 +235,16 @@ ext4_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>         if (IS_ERR(handle))
>                 return PTR_ERR(handle);
>
> +       if (type == ACL_TYPE_ACCESS && acl) {
> +               error = posix_acl_update_mode(inode, &inode->i_mode, &acl);
> +               if (error)
> +                       goto out_stop;
> +               inode->i_ctime = current_time(inode);
> +               ext4_mark_inode_dirty(handle, inode);
> +       }
> +
>         error = __ext4_set_acl(handle, inode, type, acl);
> +out_stop:
>         ext4_journal_stop(handle);
>         if (error == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
>                 goto retry;
> --
> 2.12.3
>
