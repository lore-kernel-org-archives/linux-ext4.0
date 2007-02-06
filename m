From: Johann Lombardi <johann.lombardi@bull.net>
Subject: Re: [RFC] [PATCH 1/1] Nanosecond timestamps
Date: Tue, 6 Feb 2007 16:12:42 +0100
Message-ID: <20070206151242.GB3140@lombardij>
References: <1170427790.6464.6.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>, tytso <tytso@mit.edu>,
	sct <sct@redhat.com>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47098 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbXBFPMK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Feb 2007 10:12:10 -0500
In-Reply-To: <1170427790.6464.6.camel@garfield>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Feb 02, 2007 at 08:19:50PM +0530, Kalpak Shah wrote:
> Index: linux-2.6.19/fs/ext3/super.c
> ===================================================================
> --- linux-2.6.19.orig/fs/ext3/super.c
> +++ linux-2.6.19/fs/ext3/super.c
> @@ -1770,6 +1772,32 @@ static int ext3_fill_super (struct super
>         }
>  
>         ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY);
> +
> +       /* determine the minimum size of new large inodes, if present */
> +       if (sbi->s_inode_size > EXT3_GOOD_OLD_INODE_SIZE) {
> +           EXT3_SB(sb)->s_want_extra_isize = sizeof(struct ext3_inode) -  EXT3_GOOD_OLD_INODE_SIZE;

Maybe EXT3_SB(sb)-> could be replaced by sbi-> here and in the lines below.

> +               if (EXT3_HAS_RO_COMPAT_FEATURE(sb,
> +                   EXT3_FEATURE_RO_COMPAT_EXTRA_ISIZE)) {
> +                       if (EXT3_SB(sb)->s_want_extra_isize <
> +                           le32_to_cpu(es->s_want_extra_isize))
                                ^^
> +                               EXT3_SB(sb)->s_want_extra_isize =
> +                                       le32_to_cpu(es->s_want_extra_isize);
                                            ^^
> +                       if (EXT3_SB(sb)->s_want_extra_isize <
> +                           le32_to_cpu(es->s_min_extra_isize))
                                ^^
> +                               EXT3_SB(sb)->s_want_extra_isize =
> +                                       le32_to_cpu(es->s_min_extra_isize);
                                            ^^
Since es->s_{min,want}_extra_isize are both __u16 (BTW, shouldn't it be __le16?),
I think you should use le16_to_cpu() instead of le32_to_cpu().

> +               }
> +       }
> +       /* Check if enough inode space is available */
> +       if (EXT3_GOOD_OLD_INODE_SIZE + EXT3_SB(sb)->s_want_extra_isize >
> +                                                       sbi->s_inode_size) {
> +               EXT3_SB(sb)->s_want_extra_isize = sizeof(struct ext3_inode) - EXT3_GOOD_OLD_INODE_SIZE;
> +               printk(KERN_INFO "EXT3-fs: required extra inode space not"
> +                       "available.\n");
> +       }

If the inode size is EXT3_GOOD_OLD_INODE_SIZE, sbi->s_want_extra_isize won't be
initialized. However, it should not be an issue because the ext3_sb_info
is set to zero in ext3_fill_super().

Johann
