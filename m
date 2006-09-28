From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ext4 compat flag assignments
Date: Thu, 28 Sep 2006 17:06:50 -0600
Message-ID: <20060928230650.GN22010@schatzie.adilger.int>
References: <20060922091520.GC6335@schatzie.adilger.int> <20060928085515.GC27104@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:25483 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1750826AbWI1XGx
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Sep 2006 19:06:53 -0400
To: Alexandre Ratchov <alexandre.ratchov@bull.net>
Content-Disposition: inline
In-Reply-To: <20060928085515.GC27104@openx1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 28, 2006  10:55 +0200, Alexandre Ratchov wrote:
> here is a list of fields we plan to use for the 64bit support, they must be
> zero on file systems without the EXT4_FEATURE_INCOMPAT_64BIT.
> 
> struct ext4_super_block
> {
> 	/* at offset 0xfe */
> 	__le32	s_desc_size;		/* Group descriptor size */

I believe this is actually a __u16 and not __u32.  The group descriptor
can't be larger than a filesystem block anyways.  Formerly called
s_reserved_word_pad.

> > - EXT4_FEATURE_RO_COMPAT_GDT_CSUM (0x0010?) - store a crc16 checksum in
> >   the group descriptor (s_uuid[16] | __u32 group | ext3_group_desc
> >   (excluding gd_checksum itself)).  This allows the kernel to more safely
> >   manage UNINIT groups.  Incomplete patch, e2fsck support mostly done.

 struct ext3_group_desc
 {
        __le32  bg_block_bitmap;                /* Blocks bitmap block */
        __le32  bg_inode_bitmap;                /* Inodes bitmap block */
        __le32  bg_inode_table;         /* Inodes table block */
        __le16  bg_free_blocks_count;   /* Free blocks count */
        __le16  bg_free_inodes_count;   /* Free inodes count */
        __le16  bg_used_dirs_count;     /* Directories count */
-       __u16   bg_pad;
-       __le32  bg_reserved[3];
+       __le16  bg_flags;
+       __le32  bg_reserved[2];
+       __le16  bg_itable_unused;       /*Unused inodes count*/
+       __le16  bg_checksum;		/*crc16(s_uuid+group_num+group_desc)*/
 };

> > - EXT4_FEATURE_RO_COMPAT_DIR_NLINK (0x0020?) - allow directories to have >
> >   65000 subdirectories (i_nlinks) by setting i_nlinks = 1 for such
> >   directories.  RO_COMPAT protects old filesystems from unlinking such
> >   directories incorrectly and losing all files therein.  Needs RO_COMPAT
> >   flag handling, needs e2fsck support, but very heavily tested.

No extra fields needed, just compat.  Bumps EXT3_LINK_MAX to 65000.

> > - EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE (0x0040?) - add s_min_extra_isize and
> >   s_want_extra_isize fields to superblock, which allow specifying
> >   the minimum and desired i_extra_isize fields in large inodes
> >   (for nsec+epoch timestamps, potential other uses).  Needs RO_COMPAT
> >   flag handling, needs e2fsck support, patch complete, little testing.

No patch yet which uses s_*_extra_isize, they can go in next available slots.
struct ext3_inode {
        } osd2;                         /* OS dependent 2 */
        __le16  i_extra_isize;
        __le16  i_pad1;
        __le32  i_ctime_extra;  /* extra Change time      (nsec << 2 | epoch) */
        __le32  i_mtime_extra;  /* extra Modification time(nsec << 2 | epoch) */
        __le32  i_atime_extra;  /* extra Access time      (nsec << 2 | epoch) */
        __le32  i_extra_reserved1;
}

> There's also the change attribute patch; it currently uses the l_i_reserved2
> field of the inode:
> 
> -                       __u32   l_i_reserved2;
> +                       __le32  l_i_change_attribute;
> 
> -#define i_reserved2    osd2.linux2.l_i_reserved2
> +#define i_chattr       osd2.linux2.l_i_change_attribute
> 
> It doesn't need RO_COMPAT/INCOMPAT flag because there are no incompatibility
> issues with kernels that do not support the change attribute but that mount
> file systems that have used it. Also it doesn't really need changes in fsck.

Did we decide if l_i_change_attribute would also be the ctime nsec value?
That would affect the RO_COMPAT_EXTRA_ISIZE implementation above, putting
the i_ctime_extra in place of l_i_reserved2.  That doesn't change the
patch significantly, though it does need the "always increment" change.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

