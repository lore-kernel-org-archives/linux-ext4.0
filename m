From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH 3/4] quota: add project quota support
Date: Sat, 2 Aug 2014 12:58:43 +0800
Message-ID: <CAPTn0cApuK0op-Owij28TOCpS3LMsR8EPxXEudc86pc1436hew@mail.gmail.com>
References: <CAPTn0cCRzZSKhaqnuGGDJ2tVwC-=NX2TkNfOVd-sYGfBZ1vBPg@mail.gmail.com>
	<B9644F34-F0D0-4B51-88B8-77749B2C08A2@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:45853 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaHBE6n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Aug 2014 00:58:43 -0400
Received: by mail-ig0-f175.google.com with SMTP id uq10so2686982igb.8
        for <linux-ext4@vger.kernel.org>; Fri, 01 Aug 2014 21:58:43 -0700 (PDT)
In-Reply-To: <B9644F34-F0D0-4B51-88B8-77749B2C08A2@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2014-08-01 14:20 GMT+08:00 Andreas Dilger <adilger@dilger.ca>:
> On Aug 1, 2014, at 3:07, Li Xi <pkuelelixi@gmail.com> wrote:
>
> +projid_t ext4_inode_projid_get(struct inode *inode, struct ext4_inode *raw,
> +                   struct ext4_inode_info *ei)
> +{
> +    projid_t projid = 0;
> +
> +    if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
> +        EXT4_FITS_IN_INODE(raw, ei, i_projid))
> +        projid = (projid_t)le32_to_cpu(raw->i_projid);
> +    return projid;
> +}
>
>
> Is zero considered an invalid project ID? Otherwise, if the i_projid field
> does not fit into the inode this may be confusing for the quota code.
Yeah, zero is a valid project ID and it is the default ID. In oder to eliminate
unnecessary error handle codes, when an inode does not have project ID
saved on disk, its ID is treated as zero. Thus, all default files will
be accounted
as project zero. Is there any potential problems with that?
>
> +static void ext4_inode_projid_set(struct inode *inode, struct ext4_inode
> *raw,
> +                  struct ext4_inode_info *ei)
> +{
> +    __u32 projid;
> +
> +    projid = __kprojid_val(inode->i_projid);
> +    if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
> +        EXT4_FITS_IN_INODE(raw, ei, i_projid))
> +        raw->i_projid = cpu_to_le32(projid);
> +}
>
>
> This needs to return an error if the i_projid field doesn't fit into the
> extended inode space, try to extend the inode space if it can.
> Otherwise, the project quota accounting for this inode will
> be lost when the inode is dropped from cache.
Sure, I've added error checking to it.
>
> We have patches in the Lustre e2fsprogs tree to allow e2fsck
> to check and increase the minimum required i_extra_size to ensure
> all inodes will have space for this field, along with a test case:
>
> http://git.hpdd.intel.com/tools/e2fsprogs.git/commit/15298ff518422a0cba2b8ea37094bd57c8451708
> http://git.hpdd.intel.com/tools/e2fsprogs.git/commit/37365a7c8c85da27b32d52324a2cc48e942306d6
>
> That would allow users to avoid errors during operation if
> enabling project quotas on an existing filesystem.
Thanks for remiding. It seems that kernel codes will increase
inode size to save project ID automatically (ext4_expand_extra_isize).
But we found a deadlock problem of EXT4_I(inode)->i_data_sem
which happens when increasing the size. I will push a fix patch soon.

Regards,
Li Xi
