From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] ext4: increase the protection of drop nlink and ext4
 inode destroy
Date: Wed, 4 Jan 2017 13:54:24 -0800
Message-ID: <20170104215424.GB14021@birch.djwong.org>
References: <1482755657-28791-1-git-send-email-yi.zhang@huawei.com>
 <141922.1483225153@turing-police.cc.vt.edu>
 <10c6fa5d-a7bb-a87c-11ad-8d30230a6075@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Valdis.Kletnieks@vt.edu, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, adilger.kernel@dilger.ca
To: "zhangyi (F)" <yi.zhang@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:40971 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032093AbdADW6n (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jan 2017 17:58:43 -0500
Content-Disposition: inline
In-Reply-To: <10c6fa5d-a7bb-a87c-11ad-8d30230a6075@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 04, 2017 at 04:29:33PM +0800, zhangyi (F) wrote:
> On 2017/1/1 6:59, Valdis.Kletnieks@vt.edu said:
> > On Mon, 26 Dec 2016 20:34:17 +0800, yi zhang said:
> >> Because of the disk and hardware issue, the ext4 filesystem have
> >> many errors, the inode->i_nlink of ext4 becomes zero abnormally
> >> but the dentry is still positive, it will cause memory corruption
> >> after the following process:
> >>
> >>  1) Due to the inode->i_nlink is 0, this inode will be added into
> >> the orhpan list,
> > 
> >> +	if (WARN(inode->i_nlink == 0, "inode %lu nlink"
> >> +		" is already 0", inode->i_ino))
> > 
> > Can we get the filesystem? Or at least the device major/minor? If a system
> > has multiple large ext4 filesystems, it would be helpful to know which
> > one is having the problem.
> > 
> 
>         if (WARN(inode->i_nlink == 0,
> -               "inode %lu nlink is already 0", inode->i_ino))
> +               "inode %lu nlink is already 0, dev=%u:%u",
> +               inode->i_ino, MAJOR(inode->i_sb->s_dev), MINOR(inode->i_sb->s_dev)))
>                 return;
> 
> We can modify as above, it's enough to know which filesystem is having the
> problem, what do you think?

Why not:

if (inode->i_nlink == 0) {
	ext4_warning_inode(inode, "nlink is already 0");
	return;
}

?

--D

> 
> yi zhang
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
