From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: ext2/4 large inode xattr mismash?
Date: Mon, 27 Feb 2017 10:10:56 -0800
Message-ID: <20170227181056.GA5266@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, ngkaho1234@gmail.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25572 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751497AbdB0SMw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Feb 2017 13:12:52 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Today ngkaho1234 pointed out on IRC that if you do the following:

$ mkfs.ext2 /dev/sda -F
$ mount /dev/sda /mnt -t ext4
$ touch /mnt/x
$ setfattr -n user.name1 -v moo /mnt/x
$ umount /mnt
$ mount /dev/sda /mnt -t ext2
$ setfattr -n user.name1 -v urk /mnt/x
$ umount /mnt

Then you get this broken looking result:
$ mount /dev/sda /mnt -e ext4
$ getfattr /mnt/x 
getfattr: Removing leading '/' from absolute path names
# file: mnt/x
user.name1
user.name1

Looking through debugfs, it seems that ext4 wrote user.name1=moo as an
ibody xattr, then ext2 wrote user.name1=urk into an external xattr block
and set i_file_acl.  ext4 sees the attr it wrote, ext2 sees the attr it
wrote, and neither can see the attr the other wrote.

$ debugfs -R 'features' /dev/sda
Filesystem features: ext_attr resize_inode dir_index filetype sparse_super large_file

$ debugfs -R 'stat /x' /dev/sda
Inode: 12   Type: regular    Mode:  0644   Flags: 0x0
Generation: 2341792653    Version: 0x00000000:00000001
User:     0   Group:     0   Project:     0   Size: 0
File ACL: 617    Directory ACL: 0
Links: 1   Blockcount: 8
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x58b45e2b:926e39a8 -- Mon Feb 27 09:13:15 2017
 atime: 0x58b45e21:c4f666c0 -- Mon Feb 27 09:13:05 2017
 mtime: 0x58b45e21:c4f666c0 -- Mon Feb 27 09:13:05 2017
crtime: 0x58b45e21:c4f666c0 -- Mon Feb 27 09:13:05 2017
Size of extra inode fields: 32
Extended attributes:
  user.name1 (3) = "moo"
  user.name1 (3) = "urk"
BLOCKS:

This is wrong -- we don't have RO_COMPAT_EXTRA_ISIZE set, so ext4 should
/not/ be setting i_extra_isize=32.  Unfortunately, it does set
i_extra_isize, which enables ext4_xattr_ibody_set to write xattrs into
the inode body.  That's a problem, because ext2 doesn't know about
inline attrs or i_extra_isize.

It occurred to me to check the s_inode_size, which is 256 on this
supposedly ext2 filesystem.  I'd have thought _fill_super would check
this value, but apparently its only criteria are that s_inode_size is at
least 128, a power of 2, and no larger than a block.  But AFAIK ext2 has
no ability to use any inode space beyond the first 128 bytes, so what
good are large inodes?

Oh, and e2fsck apparently doesn't notice if there are inodes with
i_extra_isize set even if ro_compat_extra_isize is not set.

I could see a bunch of fixes to resolve this problem:

1) Teach ext4 not to set i_extra_isize unless the feature bit is set.
2) ext2_iget grows the ability to return -EFSCORRUPTED for inodes that
   have big inodes and i_extra_isize set, to encourage people to run
   e2fsck.
3) e2fsck will move attrs and zap i_extra_isize if i_extra_isize is set
   on a filesystem that doesn't support it.
4) mke2fs probably should stop allocating 256 byte inodes with the ext2
   and ext3 profiles, though it's not clear to me why the ext2 driver
   even allows this -- maybe there's some context here I don't know?

So ... /me isn't sure how to deal with this.  List? :)

--D
