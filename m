From: Wang Shilong <wshilong@ddn.com>
Subject: RE: [PATCH 1/2] ext4, project: expand inode extra size if possible
Date: Fri, 30 Jun 2017 09:54:49 +0000
Message-ID: <3ED34739A4E85E4F894367D57617CDEFCA597743@LAX-EX-MB2.datadirect.datadirectnet.com>
References: <20170630035148.63305-1-wshilong@ddn.com>,<535692b6-b000-e040-2fdc-2ef5dcbff1ab@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "tytso@mit.edu" <tytso@mit.edu>, Li Xi <lixi@ddn.com>,
        "yi.zhang@huawei.com" <yi.zhang@huawei.com>,
        "adilger@dilger.ca" <adilger@dilger.ca>,
        Shuichi Ihara <sihara@ddn.com>
To: "miaoxie@huawei.com" <miaoxie@huawei.com>,
        Wang Shilong <wangshilong1991@gmail.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from legacy.ddn.com ([64.47.133.206]:1804 "EHLO legacy.ddn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751940AbdF3KA1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Jun 2017 06:00:27 -0400
In-Reply-To: <535692b6-b000-e040-2fdc-2ef5dcbff1ab@huawei.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


________________________________________
From: Miao Xie [miaoxie@huawei.com]
Sent: Friday, June 30, 2017 16:48
To: Wang Shilong; linux-ext4@vger.kernel.org
Cc: tytso@mit.edu; Li Xi; yi.zhang@huawei.com; adilger@dilger.ca; Wang Shilong; Shuichi Ihara
Subject: Re: [PATCH 1/2] ext4, project: expand inode extra size if possible

on 2017/6/30 at 11:51, Wang Shilong wrote:
> when upgrading from old format, try to set project id
> to old file first time, it will return EOVERFLOW, but if
> that file is dirtied(touch etc), changing project id will
> be allowed, this might be confusing for users, we could
> try to expand @i_extra_iszie here too.
>
> Reported-by: zhangyi(F) <yi.zhang@huawei.com>
> Signed-off-by: Wang Shilong <wshilong@ddn.com>
> ---
>  fs/ext4/ext4.h  |  3 +++
>  fs/ext4/inode.c |  7 +++----
>  fs/ext4/ioctl.c | 17 +++++++++++++++--
>  3 files changed, 21 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 3219154..640f006 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2453,6 +2453,9 @@ int ext4_walk_page_buffers(handle_t *handle,
>                          int *partial,
>                          int (*fn)(handle_t *handle,
>                                    struct buffer_head *bh));
> +int ext4_expand_extra_isize(struct inode *inode,
> +                         unsigned int new_extra_isize,
> +                         struct ext4_iloc iloc, handle_t *handle);
>  int do_journal_get_write_access(handle_t *handle,
>                               struct buffer_head *bh);
>  #define FALL_BACK_TO_NONDELALLOC 1
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5cf82d0..d53fae6 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5632,10 +5632,9 @@ ext4_reserve_inode_write(handle_t *handle, struct inode *inode,
>   * Expand an inode by new_extra_isize bytes.
>   * Returns 0 on success or negative error number on failure.
>   */
> -static int ext4_expand_extra_isize(struct inode *inode,
> -                                unsigned int new_extra_isize,
> -                                struct ext4_iloc iloc,
> -                                handle_t *handle)
> +int ext4_expand_extra_isize(struct inode *inode,
> +                         unsigned int new_extra_isize,
> +                         struct ext4_iloc iloc, handle_t *handle)
>  {
>       struct ext4_inode *raw_inode;
>       struct ext4_xattr_ibody_header *header;
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 0c21e22..819f59d 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -319,6 +319,7 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
>       struct ext4_iloc iloc;
>       struct ext4_inode *raw_inode;
>       struct dquot *transfer_to[MAXQUOTAS] = { };
> +     bool need_expand = false;
>
>       if (!ext4_has_feature_project(sb)) {
>               if (projid != EXT4_DEF_PROJID)
> @@ -350,7 +351,10 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
>               goto out_unlock;
>
>       raw_inode = ext4_raw_inode(&iloc);
> -     if (!EXT4_FITS_IN_INODE(raw_inode, ei, i_projid)) {
> +     if (!EXT4_FITS_IN_INODE(raw_inode, ei, i_projid) &&
> +         !ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND)) {
> +             need_expand = true;
> +     } else if (!EXT4_FITS_IN_INODE(raw_inode, ei, i_projid)) {
>               err = -EOVERFLOW;
>               brelse(iloc.bh);
>               goto out_unlock;
> @@ -361,12 +365,21 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
>
>       handle = ext4_journal_start(inode, EXT4_HT_QUOTA,
>               EXT4_QUOTA_INIT_BLOCKS(sb) +
> -             EXT4_QUOTA_DEL_BLOCKS(sb) + 3);
> +             EXT4_QUOTA_DEL_BLOCKS(sb) + 3 +
> +             need_expand ? EXT4_DATA_TRANS_BLOCKS(sb) : 0);
>       if (IS_ERR(handle)) {
>               err = PTR_ERR(handle);
>               goto out_unlock;
>       }
>
> +     if (need_expand) {
> +             err = ext4_expand_extra_isize(inode,
> +                                   EXT4_SB(sb)->s_want_extra_isize,
> +                                   iloc, handle);
> +             if (err)
> +                     goto out_stop;
> +     }
> +

ext4_expand_extra_isize should be invoked after ext4_reserve_inode_write.

--->Yup, indeed.

And I think it is better to restructure ext4_expand_extra_isize by moving NO_EXPAND check,
nojournal check and journal credits extend into it, and then we just if i_projid is in
the inode or not, if not, invoke ext4_expand_extra_isize. (don't forget to do cleanup for
ext4_mark_inode_dirty), And then we can remove many check in the above code.

--->thanks for good suggestions, will fix it.


Thanks
Miao

>       err = ext4_reserve_inode_write(handle, inode, &iloc);
>       if (err)
>               goto out_stop;
>
