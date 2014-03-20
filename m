From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: kill i_version support for Hurd-castrated file systems
Date: Wed, 19 Mar 2014 23:27:57 -0600
Message-ID: <3DF297F8-04E0-4EE6-8CD5-127997293D5A@dilger.ca>
References: <20140319202009.GA21361@jessie01> <1395290051-25682-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"1o5g4r8o@gmail.com" <1o5g4r8o@gmail.com>,
	"738758@bugs.debian.org" <738758@bugs.debian.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33097 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaCTF2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Mar 2014 01:28:17 -0400
Received: by mail-pa0-f42.google.com with SMTP id fb1so415553pad.29
        for <linux-ext4@vger.kernel.org>; Wed, 19 Mar 2014 22:28:17 -0700 (PDT)
In-Reply-To: <1395290051-25682-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Probably worthwhile to make those !EXT4_OS_HURD checks likely()?

Cheers, Andreas

> On Mar 19, 2014, at 22:34, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> The Hurd file system uses uses the inode field which is now used for
> i_version for its translator block.  This means that ext2 file systems
> that are formatted for GNU Hurd can't be used to support NFSv4.  Given
> that Hurd file systems don't support extents, and a huge number of
> modern file system features, this is no great loss.
> 
> If we don't do this, the attempt to update the i_version field will
> stomp over the translator block field, which will cause file system
> corruption for Hurd file systems.  This can be replicated via:
> 
> mke2fs -t ext2 -o hurd /dev/vdc
> mount -t ext4 /dev/vdc /vdc
> touch /vdc/bug0000
> umount /dev/vdc
> e2fsck -f /dev/vdc
> 
> Addresses-Debian-Bug: #738758
> 
> Reported-By: Gabriele Giacone <1o5g4r8o@gmail.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> fs/ext4/inode.c | 29 ++++++++++++++++++-----------
> 1 file changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 7cc2455..ed2c13a 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4168,11 +4168,14 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>    EXT4_INODE_GET_XTIME(i_atime, inode, raw_inode);
>    EXT4_EINODE_GET_XTIME(i_crtime, ei, raw_inode);
> 
> -    inode->i_version = le32_to_cpu(raw_inode->i_disk_version);
> -    if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE) {
> -        if (EXT4_FITS_IN_INODE(raw_inode, ei, i_version_hi))
> -            inode->i_version |=
> -            (__u64)(le32_to_cpu(raw_inode->i_version_hi)) << 32;
> +    if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
> +        cpu_to_le32(EXT4_OS_HURD)) {
> +        inode->i_version = le32_to_cpu(raw_inode->i_disk_version);
> +        if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE) {
> +            if (EXT4_FITS_IN_INODE(raw_inode, ei, i_version_hi))
> +                inode->i_version |=
> +            (__u64)(le32_to_cpu(raw_inode->i_version_hi)) << 32;
> +        }
>    }
> 
>    ret = 0;
> @@ -4388,12 +4391,16 @@ static int ext4_do_update_inode(handle_t *handle,
>            raw_inode->i_block[block] = ei->i_data[block];
>    }
> 
> -    raw_inode->i_disk_version = cpu_to_le32(inode->i_version);
> -    if (ei->i_extra_isize) {
> -        if (EXT4_FITS_IN_INODE(raw_inode, ei, i_version_hi))
> -            raw_inode->i_version_hi =
> -            cpu_to_le32(inode->i_version >> 32);
> -        raw_inode->i_extra_isize = cpu_to_le16(ei->i_extra_isize);
> +    if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
> +        cpu_to_le32(EXT4_OS_HURD)) {
> +        raw_inode->i_disk_version = cpu_to_le32(inode->i_version);
> +        if (ei->i_extra_isize) {
> +            if (EXT4_FITS_IN_INODE(raw_inode, ei, i_version_hi))
> +                raw_inode->i_version_hi =
> +                    cpu_to_le32(inode->i_version >> 32);
> +            raw_inode->i_extra_isize =
> +                cpu_to_le16(ei->i_extra_isize);
> +        }
>    }
> 
>    ext4_inode_csum_set(inode, raw_inode, ei);
> -- 
> 1.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
