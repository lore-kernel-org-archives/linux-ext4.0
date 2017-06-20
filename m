From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH v2 28/31] quota: add get_inode_usage callback to transfer
 multi-inode charges
Date: Tue, 20 Jun 2017 05:01:34 -0700
Message-ID: <CAAeU0aO6=BB0RfOObD6UpbRu03wA734_JgG=2a_+-x2X60ScxA@mail.gmail.com>
References: <20170619123614.GA20405@quack2.suse.cz> <20170620091210.13343-1-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-kernel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170620091210.13343-1-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 19, 2017 at 5:36 AM, Jan Kara <jack@suse.cz> wrote:
> On Mon 19-06-17 04:46:00, Tahsin Erdogan wrote:
>> >> I tried that approach by adding a "int get_inode_usage(struct inode
>> >> *inode, qsize_t *usage)" callback to dquot_operations. Unfortunately,
>> >> ext4 code that calculates the number of internal inodes
>> >> (ext4_xattr_inode_count()) is subject to failures so the callback has
>> >> to be able to report errors. And, that itself is problematic because
>> >> we can't afford to have errors in dquot_free_inode(). If you have
>> >> thoughts about how to address this please let me know.
>> >
>> > Well, you can just make dquot_free_inode() return error. Now most callers
>> > won't be able to do much with an error from dquot_free_inode() but that's
>> > the case also for other things during inode deletion - just handle it as
>> > other fatal failures during inode freeing.
>> >
>> I just checked dquot_free_inode() to see whether it calls anything
>> that could fail. It calls mark_all_dquot_dirty() and ignores the
>> return code from it. I would like to follow the same for the
>> get_inode_usage() as the only use case for get_inode_usage() (ext4)
>> should not fail at inode free time.
>>
>> Basically, I want to avoid changing return type from void to int
>> because it would create a new responsibility for the filesystem
>> implementations who do not know how to deal with it.
>
> Heh, this "pushing of responsibility" looks like a silly game. If an error
> can happen in a function, it is better to report it as far as easily
> possible (unless we can cleanly handle it which we cannot here). I'm guilty
> of making dquot_free_inode() ignore errors from mark_all_dquot_dirty() and
> in retrospect it would have been better if these were propagated to the
> caller as well. And eventually we can fix this if we decide we care enough.
> I'm completely fine with just returning an error from dquot_free_inode()
> and ignore it in all the callers except for ext4. Then filesystems which
> care enough can try to handle the error. That way we at least don't
> increase the design debt from the past.

In the latest version, I have added a get_inode_usage() callback to be
used in __dquot_transfer(). However, I didn't use it in
dquot_alloc_inode() and dquot_free_inode(), so I owe you an
explanation.

Before ea_inode feature, ext4 used the following simple inode quota operations:

- call dquot_alloc_inode() when a new inode is created
- call dquot_free_inode() when inode is deleted
- call dquot_transfer() when ownership of an inode changed

With ea_inode feature, setting a large extended attribute on an inode
may store EA value in an external inode. These extended attribute
inodes (called xattr inode from now on) are shareable. So, there can
be more than inodes that reference them. From quota tracking
perspective, the xattr inodes are charged to all referencing users as
if no sharing occurs. Xattr inodes themselves have quota flag disabled
on them. With this design, the quota operations that we need are:

1- call dquot_alloc_inode() when a non-xattr inode is created
2- increment inode charge on parent inode when a reference on an xattr
inode is taken
3- decrement inode charge on parent when reference is dropped
4- call dquot_free_inode() when non-xattr inode is deleted
5- call dquot_transfer() when "parent" ownership changes. Transfer has
to carry additional references due to xattr inodes

Latest version of patch collapses "increment inode" operation into
dquot_alloc_inode() so it calls dquot_alloc_inode() for both 1) and 2)
above. Similarly it calls dquot_free_inode() for both 3) and 4). We
could invent new operations to make the function names more explicit
but as is it achieves the intended behavior.

With the design above, calling get_inode_usage() from
dquot_alloc_inode() is not very useful because it will always get back
1. And more importantly, it will prohibit dquot_alloc_inode() from
being used for inode increment operation (use case 3 above).

Sorry for the long description, I hope this makes sense.


On Tue, Jun 20, 2017 at 2:12 AM, Tahsin Erdogan <tahsin@google.com> wrote:
> Ext4 ea_inode feature allows storing xattr values in external inodes to
> be able to store values that are bigger than a block in size. Ext4 also
> has deduplication support for these type of inodes. With deduplication,
> the actual storage waste is eliminated but the users of such inodes are
> still charged full quota for the inodes as if there was no sharing
> happening in the background.
>
> This design requires ext4 to manually charge the users because the
> inodes are shared.
>
> An implication of this is that, if someone calls chown on a file that
> has such references we need to transfer the quota for the file and xattr
> inodes. Current dquot_transfer() function implicitly transfers one inode
> charge. With ea_inode feature, we would like to transfer multiple inode
> charges.
>
> Add get_inode_usage callback which can interrogate the total number of
> inodes that were charged for a given inode.
>
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> ---
> v2:
>   - added get_inode_usage() callback to query total inodes charge to
>     be transferred
>
>  fs/ext4/inode.c       |  7 +++++++
>  fs/ext4/ioctl.c       |  6 ++++++
>  fs/ext4/super.c       | 21 ++++++++++----------
>  fs/ext4/xattr.c       | 54 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ext4/xattr.h       |  2 ++
>  fs/quota/dquot.c      | 16 +++++++++++----
>  include/linux/quota.h |  2 ++
>  7 files changed, 94 insertions(+), 14 deletions(-)
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ea95bd9eab81..cd22de0b5d2c 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5295,7 +5295,14 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>                         error = PTR_ERR(handle);
>                         goto err_out;
>                 }
> +
> +               /* dquot_transfer() calls back ext4_get_inode_usage() which
> +                * counts xattr inode references.
> +                */
> +               down_read(&EXT4_I(inode)->xattr_sem);
>                 error = dquot_transfer(inode, attr);
> +               up_read(&EXT4_I(inode)->xattr_sem);
> +
>                 if (error) {
>                         ext4_journal_stop(handle);
>                         return error;
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index dde8deb11e59..42b3a73143cf 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -373,7 +373,13 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
>
>         transfer_to[PRJQUOTA] = dqget(sb, make_kqid_projid(kprojid));
>         if (!IS_ERR(transfer_to[PRJQUOTA])) {
> +
> +               /* __dquot_transfer() calls back ext4_get_inode_usage() which
> +                * counts xattr inode references.
> +                */
> +               down_read(&EXT4_I(inode)->xattr_sem);
>                 err = __dquot_transfer(inode, transfer_to);
> +               up_read(&EXT4_I(inode)->xattr_sem);
>                 dqput(transfer_to[PRJQUOTA]);
>                 if (err)
>                         goto out_dirty;
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 2bfacd737bb6..4b15bf674d45 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1263,16 +1263,17 @@ static struct dquot **ext4_get_dquots(struct inode *inode)
>  }
>
>  static const struct dquot_operations ext4_quota_operations = {
> -       .get_reserved_space = ext4_get_reserved_space,
> -       .write_dquot    = ext4_write_dquot,
> -       .acquire_dquot  = ext4_acquire_dquot,
> -       .release_dquot  = ext4_release_dquot,
> -       .mark_dirty     = ext4_mark_dquot_dirty,
> -       .write_info     = ext4_write_info,
> -       .alloc_dquot    = dquot_alloc,
> -       .destroy_dquot  = dquot_destroy,
> -       .get_projid     = ext4_get_projid,
> -       .get_next_id    = ext4_get_next_id,
> +       .get_reserved_space     = ext4_get_reserved_space,
> +       .write_dquot            = ext4_write_dquot,
> +       .acquire_dquot          = ext4_acquire_dquot,
> +       .release_dquot          = ext4_release_dquot,
> +       .mark_dirty             = ext4_mark_dquot_dirty,
> +       .write_info             = ext4_write_info,
> +       .alloc_dquot            = dquot_alloc,
> +       .destroy_dquot          = dquot_destroy,
> +       .get_projid             = ext4_get_projid,
> +       .get_inode_usage        = ext4_get_inode_usage,
> +       .get_next_id            = ext4_get_next_id,
>  };
>
>  static const struct quotactl_ops ext4_qctl_operations = {
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index d7e60358ec91..5e20f29afe9e 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -734,6 +734,60 @@ static void ext4_xattr_update_super_block(handle_t *handle,
>         }
>  }
>
> +int ext4_get_inode_usage(struct inode *inode, qsize_t *usage)
> +{
> +       struct ext4_iloc iloc = { .bh = NULL };
> +       struct buffer_head *bh = NULL;
> +       struct ext4_inode *raw_inode;
> +       struct ext4_xattr_ibody_header *header;
> +       struct ext4_xattr_entry *entry;
> +       qsize_t ea_inode_refs = 0;
> +       void *end;
> +       int ret;
> +
> +       lockdep_assert_held_read(&EXT4_I(inode)->xattr_sem);
> +
> +       if (ext4_test_inode_state(inode, EXT4_STATE_XATTR)) {
> +               ret = ext4_get_inode_loc(inode, &iloc);
> +               if (ret)
> +                       goto out;
> +               raw_inode = ext4_raw_inode(&iloc);
> +               header = IHDR(inode, raw_inode);
> +               end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
> +               ret = xattr_check_inode(inode, header, end);
> +               if (ret)
> +                       goto out;
> +
> +               for (entry = IFIRST(header); !IS_LAST_ENTRY(entry);
> +                    entry = EXT4_XATTR_NEXT(entry))
> +                       if (entry->e_value_inum)
> +                               ea_inode_refs++;
> +       }
> +
> +       if (EXT4_I(inode)->i_file_acl) {
> +               bh = sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl);
> +               if (!bh) {
> +                       ret = -EIO;
> +                       goto out;
> +               }
> +
> +               if (ext4_xattr_check_block(inode, bh)) {
> +                       ret = -EFSCORRUPTED;
> +                       goto out;
> +               }
> +
> +               for (entry = BFIRST(bh); !IS_LAST_ENTRY(entry);
> +                    entry = EXT4_XATTR_NEXT(entry))
> +                       if (entry->e_value_inum)
> +                               ea_inode_refs++;
> +       }
> +       *usage = ea_inode_refs + 1;
> +out:
> +       brelse(iloc.bh);
> +       brelse(bh);
> +       return ret;
> +}
> +
>  static inline size_t round_up_cluster(struct inode *inode, size_t length)
>  {
>         struct super_block *sb = inode->i_sb;
> diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
> index 67616cb9a059..26119a67c8c3 100644
> --- a/fs/ext4/xattr.h
> +++ b/fs/ext4/xattr.h
> @@ -193,3 +193,5 @@ extern void ext4_xattr_inode_set_class(struct inode *ea_inode);
>  #else
>  static inline void ext4_xattr_inode_set_class(struct inode *ea_inode) { }
>  #endif
> +
> +extern int ext4_get_inode_usage(struct inode *inode, qsize_t *usage);
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index 48813aeaab80..53a17496c5c5 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -1910,6 +1910,7 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
>  {
>         qsize_t space, cur_space;
>         qsize_t rsv_space = 0;
> +       qsize_t inode_usage = 1;
>         struct dquot *transfer_from[MAXQUOTAS] = {};
>         int cnt, ret = 0;
>         char is_valid[MAXQUOTAS] = {};
> @@ -1919,6 +1920,13 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
>
>         if (IS_NOQUOTA(inode))
>                 return 0;
> +
> +       if (inode->i_sb->dq_op->get_inode_usage) {
> +               ret = inode->i_sb->dq_op->get_inode_usage(inode, &inode_usage);
> +               if (ret)
> +                       return ret;
> +       }
> +
>         /* Initialize the arrays */
>         for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
>                 warn_to[cnt].w_type = QUOTA_NL_NOWARN;
> @@ -1946,7 +1954,7 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
>                         continue;
>                 is_valid[cnt] = 1;
>                 transfer_from[cnt] = i_dquot(inode)[cnt];
> -               ret = check_idq(transfer_to[cnt], 1, &warn_to[cnt]);
> +               ret = check_idq(transfer_to[cnt], inode_usage, &warn_to[cnt]);
>                 if (ret)
>                         goto over_quota;
>                 ret = check_bdq(transfer_to[cnt], space, 0, &warn_to[cnt]);
> @@ -1963,7 +1971,7 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
>                 /* Due to IO error we might not have transfer_from[] structure */
>                 if (transfer_from[cnt]) {
>                         int wtype;
> -                       wtype = info_idq_free(transfer_from[cnt], 1);
> +                       wtype = info_idq_free(transfer_from[cnt], inode_usage);
>                         if (wtype != QUOTA_NL_NOWARN)
>                                 prepare_warning(&warn_from_inodes[cnt],
>                                                 transfer_from[cnt], wtype);
> @@ -1971,13 +1979,13 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
>                         if (wtype != QUOTA_NL_NOWARN)
>                                 prepare_warning(&warn_from_space[cnt],
>                                                 transfer_from[cnt], wtype);
> -                       dquot_decr_inodes(transfer_from[cnt], 1);
> +                       dquot_decr_inodes(transfer_from[cnt], inode_usage);
>                         dquot_decr_space(transfer_from[cnt], cur_space);
>                         dquot_free_reserved_space(transfer_from[cnt],
>                                                   rsv_space);
>                 }
>
> -               dquot_incr_inodes(transfer_to[cnt], 1);
> +               dquot_incr_inodes(transfer_to[cnt], inode_usage);
>                 dquot_incr_space(transfer_to[cnt], cur_space);
>                 dquot_resv_space(transfer_to[cnt], rsv_space);
>
> diff --git a/include/linux/quota.h b/include/linux/quota.h
> index 3434eef2a5aa..bfd077ca6ac3 100644
> --- a/include/linux/quota.h
> +++ b/include/linux/quota.h
> @@ -332,6 +332,8 @@ struct dquot_operations {
>          * quota code only */
>         qsize_t *(*get_reserved_space) (struct inode *);
>         int (*get_projid) (struct inode *, kprojid_t *);/* Get project ID */
> +       /* Get number of inodes that were charged for a given inode */
> +       int (*get_inode_usage) (struct inode *, qsize_t *);
>         /* Get next ID with active quota structure */
>         int (*get_next_id) (struct super_block *sb, struct kqid *qid);
>  };
> --
> 2.13.1.518.g3df882009-goog
>
