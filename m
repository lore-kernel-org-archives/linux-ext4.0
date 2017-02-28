From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: ext2/4 large inode xattr mismash?
Date: Mon, 27 Feb 2017 20:05:32 -0800
Message-ID: <20170228040532.GB5266@birch.djwong.org>
References: <20170227181056.GA5266@birch.djwong.org>
 <B757EF06-0644-4596-B02E-E9E39142DD77@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>, ngkaho1234@gmail.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:26249 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751578AbdB1FUY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Feb 2017 00:20:24 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v1S46gpo020158
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-ext4@vger.kernel.org>; Tue, 28 Feb 2017 04:06:42 GMT
Content-Disposition: inline
In-Reply-To: <B757EF06-0644-4596-B02E-E9E39142DD77@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 27, 2017 at 03:42:11PM -0700, Andreas Dilger wrote:
> On Feb 27, 2017, at 11:10 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > 
> > Hi Ted,
> > 
> > Today ngkaho1234 pointed out on IRC that if you do the following:
> > 
> > $ mkfs.ext2 /dev/sda -F
> > $ mount /dev/sda /mnt -t ext4
> > $ touch /mnt/x
> > $ setfattr -n user.name1 -v moo /mnt/x
> > $ umount /mnt
> > $ mount /dev/sda /mnt -t ext2
> > $ setfattr -n user.name1 -v urk /mnt/x
> > $ umount /mnt
> > 
> > Then you get this broken looking result:
> > $ mount /dev/sda /mnt -e ext4
> > $ getfattr /mnt/x
> > getfattr: Removing leading '/' from absolute path names
> > # file: mnt/x
> > user.name1
> > user.name1
> > 
> > Looking through debugfs, it seems that ext4 wrote user.name1=moo as an
> > ibody xattr, then ext2 wrote user.name1=urk into an external xattr block
> > and set i_file_acl.  ext4 sees the attr it wrote, ext2 sees the attr it
> > wrote, and neither can see the attr the other wrote.
> > 
> > $ debugfs -R 'features' /dev/sda
> > Filesystem features: ext_attr resize_inode dir_index filetype sparse_super large_file
> > 
> > $ debugfs -R 'stat /x' /dev/sda
> > Inode: 12   Type: regular    Mode:  0644   Flags: 0x0
> > Generation: 2341792653    Version: 0x00000000:00000001
> > User:     0   Group:     0   Project:     0   Size: 0
> > File ACL: 617    Directory ACL: 0
> > Links: 1   Blockcount: 8
> > Fragment:  Address: 0    Number: 0    Size: 0
> > ctime: 0x58b45e2b:926e39a8 -- Mon Feb 27 09:13:15 2017
> > atime: 0x58b45e21:c4f666c0 -- Mon Feb 27 09:13:05 2017
> > mtime: 0x58b45e21:c4f666c0 -- Mon Feb 27 09:13:05 2017
> > crtime: 0x58b45e21:c4f666c0 -- Mon Feb 27 09:13:05 2017
> > Size of extra inode fields: 32
> > Extended attributes:
> >  user.name1 (3) = "moo"
> >  user.name1 (3) = "urk"
> > BLOCKS:
> > 
> > This is wrong -- we don't have RO_COMPAT_EXTRA_ISIZE set, so ext4 should
> > /not/ be setting i_extra_isize=32.  Unfortunately, it does set
> > i_extra_isize, which enables ext4_xattr_ibody_set to write xattrs into
> > the inode body.  That's a problem, because ext2 doesn't know about
> > inline attrs or i_extra_isize.
> 
> I suspect that this isn't a big problem in real life, since most systems
> these days are using ext4 to mount ext2 filesystems, instead of using the
> separate ext2 module, and it could understand the extra data anyway.
> 
> The thing to check/fix in the ext4 code is to not set i_extra_isize if the
> EXTRA_ISIZE feature isn't set.  Also, e2fsck should set the feature flag
> if it finds valid extra inode data beyond 128 bytes, since this is already
> true out in the wild, so we don't want to clobber existing (meta)data in
> large inodes.
> 
> Unfortunately, our policy is to not enable features in-kernel automatically,
> to avoid the problem of potentially making the filesystem unmountable,
> otherwise we could do the same in ext4.  That said, e2fsck will prompt the
> user to fix this if needed.
> 
> > It occurred to me to check the s_inode_size, which is 256 on this
> > supposedly ext2 filesystem.  I'd have thought _fill_super would check
> > this value, but apparently its only criteria are that s_inode_size is at
> > least 128, a power of 2, and no larger than a block.  But AFAIK ext2 has
> > no ability to use any inode space beyond the first 128 bytes, so what
> > good are large inodes?
> 
> I don't think the 256-byte inode size should be considered a problem on
> ext2 by itself.  The old code understands the larger inode size, it just
> didn't do anything with that larger size until ext3 had fast xattrs and
> the added timestamp fields.  The other thought is to just get rid of the
> ext2 code completely, and the problem would be gone...  I don't think
> there are (m)any cases where ext2 is faster than ext4, if nojournal
> is used to level the playing field.
> 
> > Oh, and e2fsck apparently doesn't notice if there are inodes with
> > i_extra_isize set even if ro_compat_extra_isize is not set.
> > 
> > I could see a bunch of fixes to resolve this problem:
> > 
> > 1) Teach ext4 not to set i_extra_isize unless the feature bit is set.
> > 2) ext2_iget grows the ability to return -EFSCORRUPTED for inodes that
> >   have big inodes and i_extra_isize set, to encourage people to run
> >   e2fsck.
> 
> No, it shouldn't be accessing that space if the feature flag isn't set,
> and should return an error at mount if it is (if not read-only).  That
> is the reason the EXTRA_ISIZE was created as a read-only feature, so
> that ext2 can't add xattrs or change the extended timestamps that conflict
> with values in the large inode.

Yes, in a strict sense ext2 shouldn't be touching /anything/ after the
first 128 bytes.  However, there's no other way for ext2 to detect this
situation that ext4 has created for it (where i_extra_isize is set but
RO_COMPAT_EXTRA_ISIZE is /not/ set), which means that ext2 will exhibit
inconsistent behavior.  I'm arguing that it's better to throw errors
back to userspace than it is to allow this weird condition to continue
(non-unique xattr names).

Complicating this is the fact that ext4 has been setting i_extra_isize
without checking the feature bit since the beginning of ext4 in 2006.
Granted we've only had ext2-on-ext4 support for a few years now, but
this means that there could be "ext2" filesystems out there with the
inode field set and the feature bit cleared.

> > 3) e2fsck will move attrs and zap i_extra_isize if i_extra_isize is set
> >   on a filesystem that doesn't support it.
> 
> Wouldn't it be better to set the feature flag rather than deleting the
> xattrs (which may not fit into the xattr block and/or may consume the
> free space of the filesystem, and at a minimum will hurt performance)?

That depends -- some people aren't going to appreciate ext2 refusing to
mount their ext2 fs because e2fsck flipped on a feature bit that ext2
doesn't know about, after the supposedly-compatible ext4 stomped on it.

It'd certainly be easier to implement... though we do at least have
libext2fs apis to read and write xattrs now.

Oh, I see the libext2fs xattr code also sets i_extra_isize without
checking the feature bit. <groan>

> > 4) mke2fs probably should stop allocating 256 byte inodes with the ext2
> >   and ext3 profiles, though it's not clear to me why the ext2 driver
> >   even allows this -- maybe there's some context here I don't know?
> 
> Well, this in itself isn't harmful, and allows those filesystems to be
> updated to ext4 easily in the future.  I think the root of the problem

Ok, I'm convinced that > 128b inodes on ext2 is a real thing. :)

> is that ext4 is enabling a feature without checking the feature flag.

Yes, indeed.  For certain, we must prohibit ext4 from setting
i_extra_isize if the feature flag isn't set.

--D

> > So ... /me isn't sure how to deal with this.  List? :)
> > 
> > --D
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 
