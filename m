From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] ext4: increase the protection of drop nlink and ext4
 inode destroy
Date: Thu, 5 Jan 2017 09:38:38 -0800
Message-ID: <20170105173838.GC14021@birch.djwong.org>
References: <1482755657-28791-1-git-send-email-yi.zhang@huawei.com>
 <141922.1483225153@turing-police.cc.vt.edu>
 <10c6fa5d-a7bb-a87c-11ad-8d30230a6075@huawei.com>
 <20170104215424.GB14021@birch.djwong.org>
 <20170104233550.oy7nzc3rxppmejbk@thunk.org>
 <5505c121-8038-1b72-423a-42f36257e959@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, Valdis.Kletnieks@vt.edu,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca
To: "zhangyi (F)" <yi.zhang@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5505c121-8038-1b72-423a-42f36257e959@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 05, 2017 at 03:24:14PM +0800, zhangyi (F) wrote:
> 
> On 2017/1/5 7:35, Theodore Ts'o wrote:
> > 
> > So how exactly how did we get into this state?  When we read the inode
> > into memory, if i_nlink is zero, we declare the file system as
> > corrupted immediately.
> > 
> > So I assume this is happening the on-disk i_links_count (which is read
> > into inode->i_nlink) was too low.  So I think the way we should be
> > handling this is in unlink and rename, before we let i_nlink drop to

D'oh, /me failed to notice the patch was against fs/inode.c, not
fs/ext4/inode.c.  Sorry for the noise.

> > zero, we need to check to see if there are other dcache entries
> > pointing at the inode.  If so, we need to call ext4_error(), and in
> > the errors=continue case, return EFSCORRUPTED (aka EUCLEAN).
> > 
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3662,6 +3662,11 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
>         }
> 
>         if (new.inode) {
> +               if (new.inode->i_nlink == 0) {
> +                       ext4_warning_inode(new.inode, "Removing file '%.*s' with no links",
> +                                      new.dentry->d_name.len, new.dentry->d_name.name);
> +                       set_nlink(new.inode, 1);

Not sure we need to dump the dentry d_name, but I guess it can't hurt.

> +               }
>                 ext4_dec_count(handle, new.inode);
>                 new.inode->i_ctime = ext4_current_time(new.inode);
>         }
> 
> Because the filesystem have many errors, and the reason of i_nlink becomes
> zero is unknown, the on-disk i_links_count was too low may be one reason.  I
> think we can add i_nlink check in ext4_rename just like ext4_unlink did, it
> can avoid inversion under any case.

Er... yes, you could add the same hunk to ext4_unlink.

--D

> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
